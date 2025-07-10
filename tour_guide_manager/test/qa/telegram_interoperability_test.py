"""Interoperability – Telegram webhook round‑trip test.
Requires: pytest, python‑telegram‑bot (or just requests).
Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in your environment before running.
Run with: pytest tests/qa/telegram_interoperability_test.py
"""
import os
import time
import uuid
import requests
import pytest

API = "https://api.telegram.org/bot{token}/{method}"
TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]
CHAT_ID = os.environ["TELEGRAM_CHAT_ID"]

@pytest.mark.integration
def test_send_and_receive_confirmation():
    unique_text = f"QA‑CONFIRM {uuid.uuid4()}"
    url = API.format(token=TOKEN, method="sendMessage")
    resp = requests.post(url, json={"chat_id": CHAT_ID, "text": unique_text})
    assert resp.status_code == 200, resp.text

    # Poll the Telegram getUpdates endpoint to verify the message arrived.
    upd_url = API.format(token=TOKEN, method="getUpdates")
    deadline = time.time() + 5  # 5‑second SLA
    seen = False
    while time.time() < deadline and not seen:
        updates = requests.get(upd_url).json().get("result", [])
        seen = any(unique_text in m.get("message", {}).get("text", "") for m in updates)
        time.sleep(0.5)

    assert seen, "Telegram confirmation not received within 5s"
