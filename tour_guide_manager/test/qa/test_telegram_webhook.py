# tests/qa/test_telegram_webhook.py
import requests

WEBHOOK_URL = "http://localhost:8000/api/telegram/webhook"

def test_telegram_bot_webhook():
    payload = {
        "message": {
            "chat": {"id": 123456789},
            "text": "/tourinfo"
        }
    }

    response = requests.post(WEBHOOK_URL, json=payload)
    assert response.status_code == 200
    assert "tour" in response.text.lower()
