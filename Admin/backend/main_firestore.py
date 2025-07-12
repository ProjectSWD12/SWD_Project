from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os
import uvicorn
from dotenv import load_dotenv

import firebase_admin
from firebase_admin import credentials, firestore
load_dotenv()  # Загружает переменные из .env

# Try to locate the Firebase service account JSON file. Users can provide the
# path via environment variables. If not set, fall back to `.venv/google-services.json`
# relative to the project root to make local development easier.
cred_path = os.getenv("FIREBASE_CREDENTIALS") or os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
if not cred_path:
    # Look for `.venv/google-services.json` next to the repository root
    default_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".venv", "google-services.json"))
    if os.path.exists(default_path):
        cred_path = default_path
    else:
        raise RuntimeError(
            "Firebase credentials not found. Set FIREBASE_CREDENTIALS or GOOGLE_APPLICATION_CREDENTIALS environment variables or place google-services.json in .venv/"
        )

try:
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)
except ValueError as exc:
    raise RuntimeError(
        "Invalid Firebase credentials file. Please download a service account key JSON file from the Firebase console and provide its path via the FIREBASE_CREDENTIALS or GOOGLE_APPLICATION_CREDENTIALS environment variable."
    ) from exc

db = firestore.client()

app = FastAPI(title="Tour Guide Manager API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

excursions_ref = db.collection("excursions")
guides_ref = db.collection("guides")
companies_ref = db.collection("companies")


class Excursion(BaseModel):
    assignedTo: str
    date: str
    lunch: bool
    masterClass: bool
    meetingPlace: str
    people: int
    route: str
    time: str
    type: str


class Guide(BaseModel):
    name: str
    avatar: str
    bio: str
    createdAt: str
    email: str
    level: str
    phone: str
    telegramAlias: str
    excursionsDone: int

class Company(BaseModel):
    address: str
    name: str
    createdAt: str
    email: str
    phone: str
    banList: list[str]

class CompanyOut(Company):
    id:str


class ExcursionOut(Excursion):
    id: str


class GuideOut(Guide):
    id: str


@app.get("/guides", response_model=List[GuideOut])
def list_guides():
    docs = guides_ref.stream()
    return [GuideOut(id=doc.id, **doc.to_dict()) for doc in docs]


@app.post("/guides", response_model=GuideOut)
def create_guide(guide: Guide):
    data = guide.dict()
    doc_ref = guides_ref.document()
    doc_ref.set(data)
    return GuideOut(id=doc_ref.id, **data)


@app.get("/guides/{guide_id}", response_model=GuideOut)
def get_guide(guide_id: str):
    doc = guides_ref.document(guide_id).get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Guide not found")
    return GuideOut(id=doc.id, **doc.to_dict())


@app.put("/guides/{guide_id}", response_model=GuideOut)
def update_guide(guide_id: str, guide: Guide):
    doc_ref = guides_ref.document(guide_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Guide not found")
    doc_ref.update(guide.dict())
    data = doc_ref.get().to_dict()
    return GuideOut(id=doc_ref.id, **data)


@app.delete("/guides/{guide_id}")
def delete_guide(guide_id: str):
    doc_ref = guides_ref.document(guide_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Guide not found")
    doc_ref.delete()
    return {"message": "Guide deleted"}


@app.get("/excursions", response_model=List[ExcursionOut])
def list_excursions():
    docs = excursions_ref.stream()
    return [ExcursionOut(id=doc.id, **doc.to_dict()) for doc in docs]


@app.post("/excursions", response_model=ExcursionOut)
def create_excursion(excursion: Excursion):
    data = excursion.dict()
    doc_ref = excursions_ref.document()
    doc_ref.set(data)
    return ExcursionOut(id=doc_ref.id, **data)


@app.get("/excursions/{excursion_id}", response_model=ExcursionOut)
def get_excursion(excursion_id: str):
    doc = excursions_ref.document(excursion_id).get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Excursion not found")
    return ExcursionOut(id=doc.id, **doc.to_dict())


@app.put("/excursions/{excursion_id}", response_model=ExcursionOut)
def update_excursion(excursion_id: str, excursion: Excursion):
    doc_ref = excursions_ref.document(excursion_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Excursion not found")
    doc_ref.update(excursion.dict())
    data = doc_ref.get().to_dict()
    return ExcursionOut(id=doc_ref.id, **data)


@app.delete("/excursions/{excursion_id}")
def delete_excursion(excursion_id: str):
    doc_ref = excursions_ref.document(excursion_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Excursion not found")
    doc_ref.delete()
    return {"message": "Excursion deleted"}

@app.get("/companies", response_model=List[CompanyOut])
def list_companies():
    docs = companies_ref.stream()
    return [CompanyOut(id=doc.id, **doc.to_dict()) for doc in docs]


@app.post("/companies", response_model=CompanyOut)
def create_company(company: Company):
    data = company.dict()
    doc_ref = companies_ref.document()
    doc_ref.set(data)
    return CompanyOut(id=doc_ref.id, **data)


@app.get("/companies/{company_id}", response_model=CompanyOut)
def get_company(company_id: str):
    doc = companies_ref.document(company_id).get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Company not found")
    return CompanyOut(id=doc.id, **doc.to_dict())


@app.put("/companies/{company_id}", response_model=CompanyOut)
def update_company(company_id: str, company: Company):
    doc_ref = companies_ref.document(company_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Company not found")
    doc_ref.update(company.dict())
    data = doc_ref.get().to_dict()
    return CompanyOut(id=doc_ref.id, **data)


@app.delete("/companies/{company_id}")
def delete_company(company_id: str):
    doc_ref = companies_ref.document(company_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Company not found")
    doc_ref.delete()
    return {"message": "Company deleted"}

@app.get("/api")  # Важно: должен быть зарегистрирован именно этот путь
def read_api():
    return {"message": "Hello from API"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)