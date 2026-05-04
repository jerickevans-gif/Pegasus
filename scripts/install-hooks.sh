#!/usr/bin/env bash
# Install a git pre-commit hook that runs the fast test suites before each commit.
# Skips integration-test.sh (~30s) and validate-everything.js (~15s, network calls)
# so commits stay snappy. CI catches the rest.
#
# Usage: bash scripts/install-hooks.sh
# Bypass once: git commit --no-verify
set -e
cd "$(dirname "$0")/.."

if [[ ! -d .git ]]; then
  echo "✗ Not in a git repo (no .git/ at $(pwd))"
  exit 1
fi

HOOK=.git/hooks/pre-commit

cat > "$HOOK" <<'HOOK_BODY'
#!/usr/bin/env bash
# Pegasus pre-commit hook — runs the two fast suites that catch the bugs that
# have actually shipped to users (JS errors, broken links, frontmatter mismatches).
# Skip once with: git commit --no-verify
set -e
cd "$(git rev-parse --show-toplevel)"

# Only re-run if dashboard.html, sw.js, bin/pegasus, or the skills changed
if git diff --cached --name-only | grep -qE '^(dashboard\.html|sw\.js|bin/pegasus|skills/|templates/)'; then
  echo "▶ Pegasus pre-commit: running fast checks…"
  node scripts/test-dashboard.js >/dev/null
  echo "  ✓ dashboard regression"
  node scripts/test-links-and-jobs.js >/dev/null
  echo "  ✓ links + onclick + parser"
  echo "✓ Pre-commit OK"
fi
HOOK_BODY

chmod +x "$HOOK"
echo "✓ Installed pre-commit hook at $HOOK"
echo "  Runs test-dashboard.js + test-links-and-jobs.js when relevant files change."
echo "  Bypass once with: git commit --no-verify"
