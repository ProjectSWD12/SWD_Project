# README

---

## Usage

**MVP v2**. 
- website for guides: https://tourapp-66e02.web.app/
- website for admins: https://tourappmanager.ru/

---

## Architecture

> Diagrams are stored in `docs/architecture/`. Any format is acceptable (PlantUML, Mermaid, Draw.io). Link to the files or embed images.

### Static view

![Component diagram](docs/architecture/StaticView.svg)

Shows the system’s structure at rest. List the main modules, services, or libraries, the APIs they expose, and the compile-time or package-time dependencies between them. A reviewer should be able to see which parts can be replaced independently and where tight coupling may cause ripple effects.

### Dynamic view

![Sequence diagram](docs/architecture/DynamicView.svg)

Captures the behaviour of the system during a single, meaningful scenario (e.g., “user searches the gallery”). It traces the exact order of calls, data formats, error paths, and latency-critical hops across objects or services. This helps spot race conditions, redundant round-trips, and security gaps.

### Deployment view

![Deployment diagram](docs/architecture/DeploymentView.svg)

Describes the runtime topology: which containers/services run on which nodes, what networks and ports connect them, and which cloud resources are involved (DB, queue, CDN, secrets store, etc.). Include redundancy (replicas, zones) and scaling units, so Ops can gauge fault tolerance and cost.

---

## Development

### Kanban board

- **Link:** <https://github.com/users/ProjectSWD12/projects/1>
- **Entry criteria:**
  | Column | Entry criteria |
  |--------|----------------|
  | **Backlog** | Issue created, priority set |
  | **Ready**   | Estimated (Story Points), acceptance criteria defined |
  | **In Progress** | assignee set |
  | **Review** | CI ✅, PR checklist passed |
  | **Done** | issue closed |

### Git workflow
Does not working.

### Secrets management

[docs/secrets-management.md](docs/secrets-management.md)

---

## Quality assurance

### Quality attribute scenarios

Document: [docs/quality-assurance/quality-attribute-scenarios.md](docs/quality-assurance/quality-attribute-scenarios.md)

## 🛠️ Quality assurance

### 🔬 Automated tests
| Test level | Tooling | Directory | Local command |
|------------|---------|-----------|---------------|
| **Unit** | `flutter_test` (+ `mockito` for mocks) | `tour_guide_manager/test/` | `flutter test` |
| **QA (Acceptance)** | `flutter_test` (widget / golden) | `tour_guide_manager/test/qa/` | `flutter test test/qa` |
| **Integration** | `integration_test` | `tour_guide_manager/integration_test/` | `flutter test integration_test` |

<details>
<summary>What each level covers</summary>

* **Unit** – isolated Dart classes, widgets and functions; external dependencies are mocked.  
* **QA / Acceptance** – higher-level widget or golden tests that validate complete UI flows against product requirements.  
* **Integration** – ensures multiple layers work together on a real/emulated device using the Flutter `integration_test` harness.
</details>

---

### 🧹 Static analysis
* **Command:** `flutter analyze --fatal-infos --fatal-warnings`  
* **Linters:**  
  * `very_good_analysis` – opinionated rule-set adopted by the team  
  * `riverpod_lint` – extra checks for Riverpod state-management patterns  
* **Config:** rules are defined in `analysis_options.yaml` at the repository root.

---

### ⚙️ Continuous integration
CI is handled by **`.github/workflows/flutter_ci.yml`** and runs on every `push` and `pull_request`.

1. **Checkout** source code.  
2. **Set up Flutter** (stable channel, cached).  
3. **Install dependencies** via `flutter pub get`.  
4. **Static analysis** — `flutter analyze`.  
5. **Run tests** — unit (`flutter test`), QA/acceptance (`flutter test test/qa`), and integration (`flutter test integration_test`).  
6. *(Optional)* **Build release artifacts** once all checks pass.

A pull request cannot be merged unless this workflow succeeds.


A pull request cannot be merged unless this workflow succeeds.


### Automated tests

| Type | Framework | Path |
|------|-----------|------|
| Unit | pytest | `tour_guide_manager/test/` |
| Integration | pytest + Docker | `tour_guide_manager/integration_test/` |
| Static analysis | flutter analyze, very_good_analysis, riverpod_lint | `.github/workflows/flutter_ci.yml` |

### User acceptance tests
All tests are listed in the product backlog.

Document: [https://github.com/users/ProjectSWD12/projects/1](https://github.com/users/ProjectSWD12/projects/1)

---

## Build and deployment

### Continuous Integration

- **Workflow files:**
  - `.github/workflows/flutter_ci.yml` — linting, unit + integration tests, coverage.
- **Static analysers:** flutter analyze, very_good_analysis, riverpod_lint.

---
