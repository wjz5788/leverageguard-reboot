# Development Workflow (Manual)

The LeverageGuard repository deliberately runs without CI/CD. Follow this manual
workflow whenever you develop new features or review pull requests.

## 1. Environment Preparation

1. Clone the repository and create a feature branch from `main`.
2. Install tooling:
   - Node.js 20.x (use `fnm`/`nvm` for per-project versions).
   - Python 3.11 with `uv` (https://github.com/astral-sh/uv) or `pipx`.
   - Foundry toolchain (`foundryup`) for Solidity development.
3. Run `scripts/bootstrap_local.sh` (once populated) to install baseline
   dependencies for each subsystem.
4. Copy the relevant `.env.example` from `env/templates/` to `.env` inside the
   subsystem you touch. Never commit populated `.env` files.

## 2. Coding Guidelines

- Use feature branches named `feature/<scope>-<summary>`.
- Keep commits focused; use the `type(scope): summary` convention (`feat(risk):`
  `fix(frontend):`, `chore(docs):`).
- Write docstrings for Python services where behaviour is not obvious; keep
  TypeScript/React components small and typed.
- All security-sensitive changes must include a short risk assessment in the PR
  description, referencing affected services or contracts.

## 3. Local Quality Gates

Run the following before opening a PR (the helper script will bundle them):

```bash
./scripts/run_local_checks.sh --all
```

The script orchestrates:

- `apps/customer-web`: `npm run lint` + `npm run build`.
- `services/microservices`: `uv pip install -r requirements.txt` (on first run),
  `uv run ruff check`, `uv run pytest` (once tests are added), and a FastAPI
  smoke invocation.
- `contracts/leverageguard`: `forge fmt` + `forge test`.
- `services/risk_model`: static lint via `python -m compileall`.

If any subsystem fails, fix the issue or document why the failure is acceptable
in the PR (with sign-off from the reviewer and product owner).

## 4. Code Review Checklist

Reviewers must confirm:

1. Manual checks were executed (`scripts/run_local_checks.sh` log attached).
2. New env vars are documented in `env/templates/`.
3. Backwards compatibility with existing contracts and message schemas.
4. Rollback steps captured in `docs/10-processes/release.md` for production
   changes.
5. All secrets stay out of the repository.

## 5. Merge Policy

- Only maintainers may merge into `main`.
- Squash merge is preferred; keep the PR description as the squash message.
- Tag release candidates manually after merge (see `release.md`).

## 6. Record Keeping

Store evidence of manual test runs (screenshots, terminal logs) inside the PR
or in the shared knowledge base. During audits, link back to the PR that shipped
the change. Without evidence, a change cannot be considered production-ready.

