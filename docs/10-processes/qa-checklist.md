# QA Checklist (Manual Verification)

Use this checklist before green-lighting any deploy or tagging a release. Store
completed copies (signed-off by the QA owner) alongside the relevant PR or in
the release notes.

## Metadata

- Feature/PR ID:
- QA Owner:
- Date:
- Target Environment:

## 1. Contracts

- [ ] `forge test` executed locally (attach log excerpt).
- [ ] Gas diff reviewed (if contract changes present).
- [ ] Contract storage layout changes reviewed or migration plan documented.
- [ ] Deployment script dry-run executed against a fork or testnet.

## 2. Backend Services

- [ ] `uv run ruff check` passes in `services/microservices`.
- [ ] Critical endpoints manually exercised (list endpoints + evidence).
- [ ] Message queue publishing + consumption tested end-to-end.
- [ ] Database migrations (if any) executed against staging.
- [ ] Secrets and config verified via `.env` sample.

## 3. Risk Model Tooling

- [ ] `python services/risk_model/binance_liq_probability.py --symbol ...`
      executed with sample parameters.
- [ ] Output validated against known scenarios or spreadsheet baseline.

## 4. Frontend

- [ ] `npm run lint` / `npm run build` succeed.
- [ ] Key user journeys tested in browser (list flows + result).
- [ ] Translations or locale-sensitive copy validated (if applicable).

## 5. Operational Readiness

- [ ] Logging dashboards updated (if new services introduced).
- [ ] Alerting rules verified or created.
- [ ] Rollback plan rehearsed or at least documented.
- [ ] Runbook updates pushed to `docs/10-processes/`.

## 6. Sign-off

- QA Owner signature:
- Product Owner signature:
- Date/time of approval:

> If any boxes remain unchecked, document the risk and mitigation plan explicitly
> before proceeding. No release should ship without a completed checklist.

