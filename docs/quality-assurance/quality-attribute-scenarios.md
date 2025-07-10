# Quality Attribute Scenarios

## Functional Suitability

### Functional Correctness

Functional correctness is the degree to which the software provides **accurate results** and behaves **exactly as intended**. It is a fundamental quality because software that behaves incorrectly is unusable.

High correctness reduces bugs, improves reliability, and builds user trust.

#### Scenario 1: Saving a Valid Tour Entry

- **Source:** Authorized user (e.g., tour manager)  
- **Stimulus:** User submits a form with valid data to create a new tour  
- **Environment:** Normal operation, database is accessible  
- **Artifact:** Tour management module and database  
- **Response:** System saves the tour and shows a success confirmation  
- **Response Measure:** Tour record appears in the database and user sees a success message within ≤2 seconds  
- **How to Test:** Create a tour using valid data via UI/API. Verify data in the database and check for confirmation message.

#### Scenario 2: Handling Invalid Tour Input

- **Source:** User  
- **Stimulus:** User submits a form with invalid or missing fields  
- **Environment:** Normal operation  
- **Artifact:** Input validation logic and data storage layer  
- **Response:** Validation error is shown, and no data is saved  
- **Response Measure:** No new record in the database; user sees a clear error message  
- **How to Test:** Submit a form with empty/invalid fields. Confirm error message is shown and nothing is saved to the database.

---

## Compatibility

### Interoperability

Interoperability is the system's ability to **communicate with other systems** and **exchange data**. It’s important to support external services like Telegram and avoid isolated systems.

#### Scenario 1: Processing a Request from Telegram Bot

- **Source:** Telegram Bot  
- **Stimulus:** A user request (e.g., for tour info) sent via Telegram  
- **Environment:** System is deployed and accessible over the internet  
- **Artifact:** API endpoint for the bot  
- **Response:** The request is processed and a result is returned to the user via Telegram  
- **Response Measure:** Telegram user receives a response within ≤2 seconds; data is correct; system returns HTTP 200  
- **How to Test:** Send a request via Telegram or simulate it via webhook/Postman. Verify correct data and logs.

#### Scenario 2: Sending Notification to Telegram User

- **Source:** System  
- **Stimulus:** Tour booking is confirmed  
- **Environment:** Internet connection and Telegram API are available  
- **Artifact:** Notification module  
- **Response:** Notification is sent to the user via Telegram  
- **Response Measure:** Message is received, HTTP 200 from Telegram API, message content is correct  
- **How to Test:** Trigger a booking confirmation. Check message delivery in Telegram and validate logs and API response.

---

## Portability

### Adaptability

Adaptability is the degree to which the software can be **ported to other environments** or **changed for new needs** with minimal effort. It ensures the system can scale or evolve over time.

#### Scenario 1: Deploying on a New Platform

- **Source:** Developer/Operations decision  
- **Stimulus:** System needs to be deployed on a new OS or hosting provider  
- **Environment:** Maintenance/setup phase; new environment is available  
- **Artifact:** Deployment scripts, configuration, and source code  
- **Response:** System runs correctly with minimal adjustments  
- **Response Measure:** <5% code changes, <1 hour downtime, all tests pass  
- **How to Test:** Install and run the system in the new environment. Record what needed to be changed and validate via automated tests.

#### Scenario 2: Adding a New Notification Channel (e.g., Slack)

- **Source:** New customer requirement or feature  
- **Stimulus:** Need to integrate a new notification service  
- **Environment:** Development phase; architecture allows for extensions  
- **Artifact:** Integration module  
- **Response:** New service added without refactoring; both integrations work  
- **Response Measure:** <20 hours to implement; <10 lines of existing code changed; tests pass  
- **How to Test:** Create a new integration module, test it with mock or real service, and ensure existing Telegram functionality still works.
