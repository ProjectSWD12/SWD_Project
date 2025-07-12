# Automated Tests

Automated tests help maintain high-quality software, verify correctness, and ensure new changes don't break existing functionality.

## Testing Strategy

The project covers critical logic with automated tests across both components:

- **Flutter Application**  
  - Unit tests
  - Widget tests

- **Admin Web Panel**  
  - Unit tests
  - Integration tests

## Test Locations

| Component          | Test Types                | Directory                      | Command             |
|--------------------|---------------------------|--------------------------------|---------------------|
| Flutter Application| Unit, Widget              | `tour_guide_manager/test`      | `flutter test`      |
| Admin Panel        | Unit, Integration         | `Admin/tests`                  | `npm run test`      |

## Running Tests Locally

### Flutter tests

```bash
flutter pub get
flutter test
flutter test --coverage # generates a coverage report
