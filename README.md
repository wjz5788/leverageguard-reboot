# LeverageGuard Reboot Repository

This repository is the refreshed home for the LeverageGuard / LiqPass stack. It
consolidates on-chain contracts, off-chain services, and client applications in
one place while keeping all workflows strictly manual—no CI/CD automation is
enabled by default.

## What's Inside

- `contracts/` – Foundry-compatible Solidity sources and deployment tooling.
- `apps/` – User-facing apps (`customer-web`) and operational consoles.
- `services/` – FastAPI microservices plus risk-model tooling written in Python.
- `packages/` – Shared Python and TypeScript libraries for reuse across
  services and clients.
- `docs/` – Living documentation: blueprints, processes, reference material.
- `scripts/` – Local automation helpers (linting, smoke checks, release aides).
- `env/` – Environment variable templates and guidance.
- `infra/` – Docker Compose bundles and infrastructure reference material.
- `tests/` – Manual and automated test cases.
- `tools/` – Editor presets, git hooks, schema formatters.

Refer to `docs/00-blueprints/repository-structure.md` for the rationale behind
this layout and the migration plan from the legacy repository.

## Manual Workflow

The project intentionally avoids CI/CD. Developers are expected to run local
checks and follow the documented procedures before merging or deploying. Start
with the guides under `docs/10-processes/` and rely on the helper scripts in
`scripts/` to orchestrate the required steps.

## Getting Started

1. Clone the repository and choose a subsystem (`contracts`, `services`,
   `apps/customer-web`) to work on.
2. Bootstrap dependencies using the instructions in each subsystem's README.
3. Execute `scripts/run_local_checks.sh` (to be populated) before opening a PR.
4. Record manual verification evidence as described in
   `docs/10-processes/qa-checklist.md`.

For licensing, security, and contribution guidelines, check the respective docs
in `docs/20-reference/` and `docs/30-decisions/` (to be curated).

