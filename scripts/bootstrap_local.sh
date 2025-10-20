#!/usr/bin/env bash
# Prepare local dependencies for LeverageGuard subsystems.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() {
  printf '[BOOTSTRAP] %s\n' "$*" >&2
}

if command -v npm >/dev/null 2>&1; then
  log "Installing frontend dependencies (apps/customer-web)..."
  pushd "${ROOT_DIR}/apps/customer-web" >/dev/null
  npm ci
  popd >/dev/null
else
  log "npm not found; skip frontend bootstrap."
fi

if command -v uv >/dev/null 2>&1; then
  log "Installing Python deps via uv (services/microservices)..."
  pushd "${ROOT_DIR}/services/microservices" >/dev/null
  uv pip install -r requirements.txt
  popd >/dev/null
elif command -v python3 >/dev/null 2>&1; then
  log "uv missing; falling back to python3 -m pip."
  pushd "${ROOT_DIR}/services/microservices" >/dev/null
  python3 -m pip install --upgrade -r requirements.txt
  popd >/dev/null
else
  log "No Python interpreter detected; cannot install microservice deps."
fi

log "Bootstrap completed. Remember to set up environment files from env/templates/."
