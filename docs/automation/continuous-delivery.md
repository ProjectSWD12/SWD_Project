# Continuous Delivery (CD)

This project uses **GitHub Actions** to automatically deploy the application after successful CI builds, allowing rapid delivery of new features and improvements to users.

## Deployment Overview

Continuous Delivery is configured for two main parts:

### 1. Flutter Web Application
- **Deployment target:** Firebase Hosting
- **Trigger:** Automatically on every push to `main`

### 2. Admin Web Application
- **Deployment target:** Vercel Hosting
- **Trigger:** Automatically on every push to `main`

## GitHub Actions Workflow Example for Flutter (Firebase Hosting):

`.github/workflows/flutter-deploy.yml`

```yaml
name: Deploy Flutter to Firebase

on:
  push:
    branches: [main]

jobs:
  deploy_flutter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/[email protected]
        with:
          flutter-version: '3.x'

      - name: Install Flutter dependencies
        run: flutter pub get

      - name: Build Flutter web app
        run: flutter build web

      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/[email protected]
        with:
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          projectId: your-firebase-project-id
          channelId: live
