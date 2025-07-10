# Manual Test — Telegram Notification Delivery

## Purpose
Verify that after a tour booking, the system sends a correct Telegram message to the user.

## Steps
1. Trigger a tour booking via the UI or API.
2. Observe the Telegram user account.
3. Confirm the message was received within 2–5 seconds.
4. Check backend logs:
   - HTTP 200 from Telegram
   - Message content is correct

## Expected Result
Telegram message like:  
**"Your booking for Tour XYZ has been confirmed."**
