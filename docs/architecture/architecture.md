# Architecture Overview

## Static View

![Component diagram](docs/architecture/StaticView.svg)

Shows the system’s structure at rest. List the main modules, services, or libraries, the APIs they expose, and the compile-time or package-time dependencies between them. A reviewer should be able to see which parts can be replaced independently and where tight coupling may cause ripple effects.

## Dynamic View

![Sequence diagram](docs/architecture/DynamicView.svg)

Captures the behaviour of the system during a single, meaningful scenario (e.g., “user searches the gallery”). It traces the exact order of calls, data formats, error paths, and latency-critical hops across objects or services. This helps spot race conditions, redundant round-trips, and security gaps.

## Deployment View

![Deployment diagram](docs/architecture/Deployment.svg)

Describes the runtime topology: which containers/services run on which nodes, what networks and ports connect them, and which cloud resources are involved (DB, queue, CDN, secrets store, etc.). Include redundancy (replicas, zones) and scaling units, so Ops can gauge fault tolerance and cost.

## Tech Stack
- Flutter (Dart)
- Firebase
- GitHub Actions
