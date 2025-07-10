# tests/qa/test_create_valid_tour.py
import requests
import time

BASE_URL = "http://localhost:8000/api/tours"  # Adjust to your real API

def test_create_valid_tour():
    payload = {
        "name": "Test Tour",
        "description": "Test Description",
        "date": "2025-08-01",
        "price": 100
    }

    start_time = time.time()
    response = requests.post(BASE_URL, json=payload)
    elapsed = time.time() - start_time

    assert response.status_code == 201
    data = response.json()
    assert data["name"] == payload["name"]
    assert elapsed < 2.0  # seconds
