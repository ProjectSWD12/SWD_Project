# README

---

## Usage

**MVP v2**. 
- website for guides: https://tourapp-66e02.web.app/
- website for admins: https://tourappmanager.ru/


- **Demo URL:** <https://example.com>  <!-- TODO: replace -->
- **Test credentials:**
  - login: `achegaev06@gmail.com`
  - password: `abc22wqq`

---

## Architecture

> Diagrams are stored in `docs/architecture/`. Any format is acceptable (PlantUML, Mermaid, Draw.io). Link to the files or embed images.

### Static view

![Component diagram](docs/architecture/static-view/component.svg)

<Brief explanation of how the chosen modular structure reduces coupling and improves maintainability.>

### Dynamic view

![Sequence diagram](docs/architecture/dynamic-view/sequence.svg)

<Describe the scenario, measured response time (ms) and bottlenecks.>

### Deployment view

![Deployment diagram](docs/architecture/deployment-view/deployment.svg)

<Comment on customer installation, infrastructure and required permissions.>

---

## Development

### Kanban board

- **Link:** <https://github.com/users/ProjectSWD12/projects/1>
- **Entry criteria:**
  | Column | Entry criteria |
  |--------|----------------|
  | **Backlog** | Issue created, priority set |
  | **Ready**   | Estimated (Story Points), acceptance criteria defined |
  | **In Progress** | MR created, assignee set |
  | **Review** | CI ✅, PR checklist passed |
  | **Done** | MR merged into `main`, issue closed |

### Git workflow

- **Base flow:** Gitflow
- **Pull request template:** `.github/workflows/flutter_ci.yml`.

---

## Quality assurance

### Automated tests

| Type | Framework | Path |
|------|-----------|------|
| Unit | pytest | `tour_guide_manager/test/` |
| Integration | pytest + Docker | `tour_guide_manager/integration_test/` |
| Static analysis | flake8, mypy, bandit | `.github/workflows/flutter_ci.yml` |

---

## Build and deployment

### Continuous Integration

- **Workflow files:**
  - `.github/workflows/flutter_ci.yml` — linting, unit + integration tests, coverage.
- **Static analysers:** flutter analyze, dart analyze, flutter_lints, very_good_analysis.

---

<!-- End of template -->
