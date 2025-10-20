#!/usr/bin/env bash
# Comprehensive local check runner for the LeverageGuard repository.
# Usage: ./scripts/run_local_checks.sh [--all|--frontend|--services|--contracts|--risk-model]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

declare -a TARGETS=()
declare -a FAILURES=()

log() {
  local level="$1"; shift
  printf '[%s] %s\n' "$level" "$*" >&2
}

ensure_tool() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "WARN" "Tool '$1' not found; skipping related checks."
    return 1
  fi
  return 0
}

run_step() {
  local name="$1"; shift
  log "INFO" "Running ${name} checks..."
  if "$@"; then
    log "INFO" "${name} checks completed."
  else
    log "ERROR" "${name} checks failed."
    FAILURES+=("$name")
  fi
}

check_frontend() {
  pushd "${ROOT_DIR}/apps/customer-web" >/dev/null
  if [ ! -d node_modules ]; then
    log "INFO" "Installing frontend dependencies (npm ci)..."
    npm ci
  fi
  npm run lint
  npm run build
  popd >/dev/null
}

check_services() {
  pushd "${ROOT_DIR}/services/microservices" >/dev/null

  if command -v uv >/dev/null 2>&1; then
    uv pip install -r requirements.txt
    uv run python -m compileall .
    if uv run -- ruff --version >/dev/null 2>&1; then
      uv run ruff check .
    else
      log "WARN" "ruff not installed in uv environment; skipping lint."
    fi
  else
    log "WARN" "uv not available; falling back to python -m pip."
    python3 -m pip install --upgrade -r requirements.txt
    python3 -m compileall .
    if command -v ruff >/dev/null 2>&1; then
      ruff check .
    else
      log "WARN" "ruff not installed; skipping lint."
    fi
  fi

  popd >/dev/null
}

check_contracts() {
  if ! ensure_tool forge; then
    return 0  # already warned; do not fail the run
  fi
  pushd "${ROOT_DIR}/contracts/leverageguard" >/dev/null
  forge fmt
  forge test
  popd >/dev/null
}

check_risk_model() {
  pushd "${ROOT_DIR}/services/risk_model" >/dev/null
  python3 -m compileall binance_liq_probability.py
  python3 binance_liq_probability.py --symbol BTCUSDT --side long --lev 10 --hours 1 >/dev/null
  popd >/dev/null
}

usage() {
  cat <<EOF
Usage: $0 [options]

Options:
  --all           Run every available check (default if no options provided)
  --frontend      Run frontend lint/build
  --services      Run microservices Python checks
  --contracts     Run Foundry formatting/tests
  --risk-model    Run liquidation probability script smoke test
  -h, --help      Show this help text
EOF
}

if [[ $# -eq 0 ]]; then
  TARGETS=(frontend services contracts risk-model)
else
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all)
        TARGETS=(frontend services contracts risk-model)
        ;;
      --frontend)
        TARGETS+=(frontend)
        ;;
      --services)
        TARGETS+=(services)
        ;;
      --contracts)
        TARGETS+=(contracts)
        ;;
      --risk-model)
        TARGETS+=(risk-model)
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        log "ERROR" "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
    shift
  done
fi

declare -A RUNNERS=(
  [frontend]=check_frontend
  [services]=check_services
  [contracts]=check_contracts
  [risk-model]=check_risk_model
)

for target in "${TARGETS[@]}"; do
  if [[ -n "${RUNNERS[$target]:-}" ]]; then
    run_step "$target" "${RUNNERS[$target]}"
  else
    log "WARN" "No runner defined for target '${target}'."
  fi
done

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  log "ERROR" "Some checks failed: ${FAILURES[*]}"
  exit 1
fi

log "INFO" "All requested checks completed successfully."
