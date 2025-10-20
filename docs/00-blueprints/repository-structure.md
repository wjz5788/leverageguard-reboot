# Repository Structure Blueprint

This blueprint describes the layout for the new LeverageGuard repository that we
will provision in this iteration. It focuses on making the codebase easier to
navigate, keeping business-critical assets close to their owners, and providing
manual workflow hooks instead of CI/CD automation.

## Guiding Objectives

- Keep on-chain, off-chain, and client-facing components separated but within a
  single monorepo so that cross-cutting changes are easy to coordinate.
- Prefer convention over tooling: no automatic pipelines, only documented manual
  steps that developers can run locally.
- Ship with lightweight bootstrap scripts so new contributors can install and
  validate each subsystem without memorising ad-hoc commands.
- Document release, verification, and rollback flows explicitly since no CI/CD
  will enforce them.

## Target Layout

```
leverageguard-reboot/
├── README.md                  # High-level product + repo overview
├── docs/                      # Living documentation
│   ├── 00-blueprints/         # Architecture & planning notes (this file)
│   ├── 10-processes/          # Manual workflows (dev, QA, release)
│   ├── 20-reference/          # API contracts, data schemas, glossary
│   └── 30-decisions/          # ADRs and risk assessments
├── contracts/                 # Smart contracts (Foundry layout retained)
│   ├── leverageguard/         # Canonical contract sources
│   └── tooling/               # Deployment scripts & manual checklists
├── apps/                      # User-facing applications
│   ├── customer-web/          # Public LiqPass/LeverSafe portal (Vite/React)
│   └── ops-console/           # Internal operations dashboard (placeholder)
├── services/                  # Off-chain services
│   ├── microservices/         # FastAPI microservice cluster
│   └── risk-model/            # Liquidation probability + analytics jobs
├── packages/                  # Shared libraries + SDKs
│   ├── python/                # Python packages shared across services
│   └── typescript/            # Front-end helpers, generated client bindings
├── scripts/                   # One-off automations (checks, data sync, etc.)
├── env/                       # `.env.example` files and secrets guidance
├── infra/                     # Docker compose bundles & infrastructure notes
├── tests/                     # Manual & automated test artefacts
└── tools/                     # Editor configs, git hooks, linting presets
```

## Manual Workflow Themes

Manual workflows will be captured under `docs/10-processes` and surfaced through
simple shell entry points located in `scripts/`. They will cover:

1. **Local development flow** – environment setup steps for contracts, backend,
   and frontend; how to run local verifications; code review checklist.
2. **Quality gates** – required manual tests (unit, integration, smoke) and
   evidence recording to unblock merges.
3. **Release & rollback** – tagged release convention, manual deployment
   commands, and what to collect for compliance.
4. **Operational playbooks** – on-call checklists, ledger reconciliation, and
   data backfill runs.

These guides substitute for CI/CD and must be followed as-is. Lightweight helper
scripts (for example `scripts/run_local_checks.sh`) will orchestrate the steps
but still require a human operator to review and acknowledge the results.

## Migration Strategy

1. Copy existing smart contracts (`contracts/LeverageGuard*.sol`) into
   `contracts/leverageguard/`.
2. Move the Vite front-end (`packages/us-frontend`) into `apps/customer-web`.
3. Relocate the FastAPI microservice suite (`src/services/microservices`) under
   `services/microservices` without altering module paths.
4. Promote risk modelling scripts (e.g. `binance_liq_p.py`) to
   `services/risk-model/` and wrap them into a reusable Python package.
5. Preserve high-value documentation by curating `docs/` and migrating only
   canonical references (product help, architecture, compliance).
6. Create fresh READMEs for each subsystem so manual onboarding is self-contained
   and no cross-referencing to the legacy repository is required.

