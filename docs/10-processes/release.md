# Release & Rollback Procedure (Manual)

With CI/CD disabled, every release must follow this human-driven runbook.
Capture timestamps, command output, and operator names for auditability.

## 0. Prerequisites

- QA checklist completed and attached to the release ticket.
- Operations calendar cleared (no overlapping high-risk changes).
- Secrets validated against `env/templates/`.
- Rollback artefacts prepared (database dumps, previous contract bytecode).

## 1. Tagging the Release

1. Ensure `main` contains only approved commits.
2. Update relevant changelogs/READMEs.
3. Tag locally using semantic versioning (`vYYYY.MM.DD-x` pattern is acceptable):

   ```bash
   git tag -a v2024.05.XX -m "Release notes summary"
   git push origin v2024.05.XX
   ```

4. Create a release entry in your hosting platform with:
   - Summary of changes.
   - Links to QA checklist and manual test evidence.
   - Known issues and mitigations.

## 2. Backend Deployment

1. Stop related services in the target environment.
2. Backup databases and message queues.
3. Deploy microservices using Docker Compose or the documented method:

   ```bash
   # Example:
   docker compose -f infra/docker/microservices.yml pull
   docker compose -f infra/docker/microservices.yml up -d --build
   ```

4. Run smoke tests via `scripts/smoke_backend.sh` (to be implemented).
5. Monitor logs for at least 15 minutes; confirm metrics dashboards are healthy.

## 3. Smart Contract Deployment

1. Verify chain configuration in `contracts/tooling/`.
2. Dry-run `forge script` against a fork network.
3. When ready, deploy to the target network:

   ```bash
   forge script script/DeployLeverSafe.s.sol --rpc-url $RPC_URL --broadcast
   ```

4. Record the transaction hash, block number, and resulting contract address in
   the release record.

## 4. Frontend Deployment

1. Build artefacts locally: `npm run build` inside `apps/customer-web`.
2. Upload to hosting (e.g., S3/CloudFront, Vercel). Retain the build artefact
   for 30 days.
3. Perform a smoke walkthrough using the staging checklist before pointing DNS
   or toggling feature flags.

## 5. Post-Deployment Verification

- Execute the `docs/10-processes/qa-checklist.md` smoke subset for production.
- Notify stakeholders (support, compliance) of the release.
- Update operational runbooks if behaviour changed.

## 6. Rollback Steps

1. Re-deploy the previous Docker Compose version or revert container tags.
2. Restore database backups if schema or data mutations occurred.
3. Re-deploy the previous smart contract (if immutable change is unacceptable)
   and inform users of downtime.
4. Publish an incident report in the shared knowledge base.

## 7. Disaster Recovery Drill

At least once per quarter, rehearse a full rollback using this document and
capture findings. File the learnings in `docs/30-decisions/`.

