# Continuous Integration (CI)

This project uses **GitHub Actions** to automatically test, analyze, and build the code upon every commit and pull request, ensuring consistent quality and reliability.

## CI Pipeline Overview

The CI pipeline covers two main parts of our project:

### 1. Flutter Application
- **Dependency Installation:** `flutter pub get`
- **Code Analysis:** `flutter analyze`
- **Automated Testing:** `flutter test`

### 2. Admin Web Application
- **Dependency Installation:** `npm ci`
- **Code Analysis:** `npm run lint`
- **Automated Testing:** `npm run test`
- **Build Check:** `npm run build`

## Example GitHub Actions Workflow (`ci.yml`):

```yaml
name: CI Pipeline
on:
  push: 
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  flutter_ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/[email protected]
        with:
          flutter-version: '3.x'
      - name: Install dependencies
        run: flutter pub get
      - name: Analyze code
        run: flutter analyze
      - name: Run tests
        run: flutter test

  admin_ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v3
        with:
          node-version: '16'
      - name: Install dependencies
        run: npm ci
      - name: Lint code
        run: npm run lint
      - name: Run tests
        run: npm run test
      - name: Build Admin panel
        run: npm run build
