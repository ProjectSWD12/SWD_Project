# User Acceptance Tests (UAT)

Our project regularly undergoes User Acceptance Testing to ensure that it meets stakeholder expectations.

## UAT Procedure

1. Define test scenarios based on user stories (available via the link: https://github.com/users/ProjectSWD12/projects/1).
2. Involve actual users (tour guides, admins).
3. Perform tests on staging or production environments.
4. Collect and document feedback.

## Example UAT scenarios

| Scenario                                | Expected Outcome                    | Status         |
|-----------------------------------------|-------------------------------------|----------------|
| Guide logs in using Firebase Auth       | Successful login without errors     | ✅ Passed      |
| Guide views assigned excursions         | Correct list displayed              | ✅ Passed      |
| Admin updates excursion details         | Changes reflected immediately       | ✅ Passed      |
| Admin blacklists a user                 | User blocked from logging in        | ✅ Passed      |
| Guide accesses statistics page          | Correct and up-to-date data shown   | 🚧 In progress |

## Reporting

- Issues found during UAT are reported via GitHub Issues with the `UAT` label.
- All findings discussed and prioritized with stakeholders.
