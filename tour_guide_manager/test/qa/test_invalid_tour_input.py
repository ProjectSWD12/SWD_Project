# tests/qa/test_invalid_tour_input.py
import requests

BASE_URL = "http://localhost:8000/api/tours"

def test_create_invalid_tour():
    payload = {
        "name": "",  # Invalid: empty name
        "description": "x",
        "date": "invalid-date",
        "price": -5
    }

    response = requests.post(BASE_URL, json=payload)
    assert response.status_code == 400 or response.status_code == 422
