# Secrets Management

This project uses GitHub Secrets to securely store sensitive data like API keys and tokens.

## Secrets used:

| Secret Name               | Description                             | Usage Location                      |
|---------------------------|-----------------------------------------|-------------------------------------|
| `FIREBASE_API_KEY`        | API Key for Firebase API access         | GitHub Actions and project code     |
| `FIREBASE_SERVICE_ACCOUNT`| Firebase service account JSON           | GitHub Actions deployment           |
| `TELEGRAM_BOT_TOKEN`      | Telegram bot token (optional)           | Telegram bot and GitHub Actions     |

## Example usage in GitHub Actions:

```yaml
env:
  FIREBASE_API_KEY: ${{ secrets.FIREBASE_API_KEY }}
  TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
