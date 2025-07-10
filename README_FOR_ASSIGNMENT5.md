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

![Deployment diagram](docs/architecture/Deployment.svg)

Describes the runtime topology: which containers/services run on which nodes, what networks and ports connect them, and which cloud resources are involved (DB, queue, CDN, secrets store, etc.). Include redundancy (replicas, zones) and scaling units, so Ops can gauge fault tolerance and cost.

---

## Development

### Kanban board

- **Link:** <https://gitlab.com/example/project/-/boards>
- **Entry criteria:**
  | Column | Entry criteria |
  |--------|----------------|
  | **Backlog** | Issue created, priority set |
  | **Ready**   | Estimated (Story Points), acceptance criteria defined |
  | **In Progress** | MR created, assignee set |
  | **Review** | CI ✅, PR checklist passed |
  | **Done** | MR merged into `main`, issue closed |

### Git workflow

```mermaid
gitGraph
   commit id:"main"
   branch feature/123-awesome
   checkout feature/123-awesome
   commit id:"feat"
   checkout main
   merge feature/123-awesome
```

- **Base flow:** GitHub Flow  <!-- or Gitflow -->
- **Branch naming:** `feature/<issue-id>-<slug>` | `bugfix/<issue-id>-<slug>`
- **Commit message style:** Conventional Commits, e.g. `feat(auth): add JWT refresh`.
- **Pull request template:** `.github/PULL_REQUEST_TEMPLATE.md` (link).

### Secrets management

<Describe where you store secrets (Vault, GitLab CI Variables, Ansible Vault, etc.) and how they reach the app.>

---

## Quality assurance

### Quality attribute scenarios

Document: [docs/quality-assurance/quality-attribute-scenarios.md](docs/quality-assurance/quality-attribute-scenarios.md)

### Automated tests

| Type | Framework | Path |
|------|-----------|------|
| Unit | pytest | `tests/unit/` |
| Integration | pytest + Docker | `tests/integration/` |
| Static analysis | flake8, mypy, bandit | `.github/workflows/ci.yml` |

### User acceptance tests

Document: [docs/quality-assurance/user-acceptance-tests.md](docs/quality-assurance/user-acceptance-tests.md)

---

## Build and deployment

### Continuous Integration

- **Workflow files:**
  - `.github/workflows/ci.yml` — linting, unit + integration tests, coverage.
  - `.github/workflows/release.yml` — tag, artifact build.
- **CI Dashboard:** <https://github.com/example/project/actions>
- **Static analysers:** flake8, mypy, bandit — catch defects early.

### Continuous Deployment (optional)

- **File:** `.github/workflows/cd.yml` — deploys to staging and production.
- **Logs:** <https://github.com/example/project/actions/workflows/cd.yml>

---

<!-- End of template -->
