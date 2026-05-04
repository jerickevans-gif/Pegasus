#!/usr/bin/env bash
# Run every Pegasus test suite. Exit 1 on any failure.
# Usage: bash scripts/test-all.sh
set -e
cd "$(dirname "$0")/.."

bold() { printf "\033[1m%s\033[0m\n" "$*"; }
green() { printf "\033[32m%s\033[0m\n" "$*"; }
red() { printf "\033[31m%s\033[0m\n" "$*"; }
hr() { printf '─%.0s' $(seq 1 60); echo; }

start=$(date +%s)
pass=0; fail=0

run() {
  local name="$1"; shift
  hr; bold "▶ $name"
  if "$@"; then pass=$((pass+1)); green "  ✓ $name"
  else fail=$((fail+1)); red "  ✗ $name"
  fi
}

run "static validation (95 checks)"      node scripts/validate-everything.js
run "dashboard regression (33 checks)"   node scripts/test-dashboard.js
run "links + onclick + parser (45+ checks)" node scripts/test-links-and-jobs.js
run "CLI integration (35 checks)"        bash scripts/integration-test.sh
run "profile schema (1 example)"         node scripts/validate-profile.js
run "E2E job-finder pipeline (16 checks)" node scripts/e2e-jobfinder.js

# Visual regression is opt-in (requires playwright + pixelmatch + pngjs).
if node -e "require('playwright'); require('pixelmatch'); require('pngjs')" 2>/dev/null; then
  run "visual regression (3 viewports)"  node scripts/visual-regression.js
else
  echo "  ↷ skipped visual regression (npm i playwright pixelmatch pngjs to enable)"
fi

elapsed=$(( $(date +%s) - start ))
hr
if [[ $fail -eq 0 ]]; then
  green "✓ ALL $pass SUITES PASSING ($elapsed s)"
  exit 0
else
  red "✗ $fail of $((pass+fail)) suites failed ($elapsed s)"
  exit 1
fi
