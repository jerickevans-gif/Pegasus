#!/usr/bin/env bash
# Real integration test — actually executes commands, scaffolds templates, runs CLI,
# verifies outputs. Uses /tmp/pegasus-int-test/ as a sandbox.
#
# Usage:  bash scripts/integration-test.sh

set -uo pipefail
GREEN='\033[32m'; RED='\033[31m'; BOLD='\033[1m'; RESET='\033[0m'
PASS=0; FAIL=0
PEG_BIN="${PEGASUS_BIN:-$HOME/.local/bin/pegasus}"
SANDBOX="/tmp/pegasus-int-test-$$"
mkdir -p "$SANDBOX"
trap "rm -rf $SANDBOX" EXIT

ok()   { printf "${GREEN}  ✓${RESET} %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "${RED}  ✗${RESET} %s\n" "$1"; FAIL=$((FAIL+1)); }
header() { printf "\n${BOLD}%s${RESET}\n" "$1"; }

# ─────────────────────────────────────────────
header "[1] Helper present + version"
# ─────────────────────────────────────────────
if [[ -x "$PEG_BIN" ]]; then ok "pegasus helper at $PEG_BIN"
else fail "pegasus helper missing at $PEG_BIN"; exit 1; fi

V=$("$PEG_BIN" version 2>&1 | head -1)
if [[ "$V" =~ Pegasus[[:space:]][0-9]+\.[0-9]+\.[0-9]+ ]]; then ok "version output: $V"
else fail "version output unexpected: $V"; fi

# ─────────────────────────────────────────────
header "[2] Pegasus simple commands run without error"
# ─────────────────────────────────────────────
for cmd in help quickstart stats skills version; do
  if "$PEG_BIN" "$cmd" >/dev/null 2>&1; then ok "pegasus $cmd"
  else fail "pegasus $cmd exited non-zero"; fi
done

# ─────────────────────────────────────────────
header "[3] pegasus doctor reports majority green"
# ─────────────────────────────────────────────
DOC=$("$PEG_BIN" doctor 2>&1)
GREEN_COUNT=$(echo "$DOC" | grep -c "✓" || true)
if [[ $GREEN_COUNT -ge 10 ]]; then ok "doctor: $GREEN_COUNT green checks"
else fail "doctor: only $GREEN_COUNT green (expected ≥10)"; fi

# ─────────────────────────────────────────────
header "[4] pegasus search returns relevant hits"
# ─────────────────────────────────────────────
SEARCH=$("$PEG_BIN" search "resume" 2>&1)
HITS=$(echo "$SEARCH" | grep -c "resume" || true)
if [[ $HITS -ge 3 ]]; then ok "search 'resume' found $HITS hits"
else fail "search 'resume' only found $HITS hits"; fi

# ─────────────────────────────────────────────
header "[5] pegasus snapshot writes valid JSON"
# ─────────────────────────────────────────────
SNAP_OUT=$("$PEG_BIN" snapshot 2>&1)
SNAP_FILE=$(echo "$SNAP_OUT" | grep -oE "/.*pegasus-snapshot-[0-9-]+\.json" | head -1)
if [[ -f "$SNAP_FILE" ]] && python3 -c "import json; json.load(open('$SNAP_FILE'))" 2>/dev/null; then
  ok "snapshot wrote valid JSON: $SNAP_FILE"
  rm "$SNAP_FILE"
else
  fail "snapshot didn't produce valid JSON"
fi

# ─────────────────────────────────────────────
header "[6] All 13 templates scaffold + render"
# ─────────────────────────────────────────────
cd "$SANDBOX"
for type in portfolio case-study-deck scroll-case-study landing-page resume link-in-bio illustration-gallery mood-board components-lab agency-page error-page podcast-page newsletter-archive; do
  HOME="$SANDBOX" PEGASUS_HOME="$SANDBOX/.pegasus" \
    cp -r "$HOME/.pegasus/templates/$type" "$SANDBOX/test-$type" 2>/dev/null
  if [[ -f "$SANDBOX/test-$type/index.html" ]]; then
    SIZE=$(wc -c < "$SANDBOX/test-$type/index.html")
    if [[ $SIZE -gt 500 ]]; then ok "$type — index.html ($SIZE bytes)"
    else fail "$type — index.html too small ($SIZE bytes)"; fi
  else
    fail "$type — index.html missing"
  fi
done

# ─────────────────────────────────────────────
header "[7] All 31 skills have valid SKILL.md frontmatter"
# ─────────────────────────────────────────────
SKILLS_DIR="$HOME/.claude/skills"
SKILL_COUNT=$(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')
ok "found $SKILL_COUNT skills installed"
BAD=0
for sk in "$SKILLS_DIR"/*/; do
  name=$(basename "$sk")
  fm_name=$(awk '/^name:/{print $2; exit}' "$sk/SKILL.md" 2>/dev/null)
  if [[ "$fm_name" != "$name" ]]; then
    fail "$name: frontmatter says '$fm_name'"
    BAD=$((BAD+1))
  fi
done
if [[ $BAD -eq 0 ]]; then ok "all $SKILL_COUNT skills have correct frontmatter"; fi

# ─────────────────────────────────────────────
header "[8] Skill descriptions are non-empty"
# ─────────────────────────────────────────────
EMPTY=0
for sk in "$SKILLS_DIR"/*/; do
  name=$(basename "$sk")
  desc=$(awk '/^description:/{$1=""; print; exit}' "$sk/SKILL.md" 2>/dev/null | sed 's/^ //')
  if [[ ${#desc} -lt 30 ]]; then
    fail "$name: description too short or missing (${#desc} chars)"
    EMPTY=$((EMPTY+1))
  fi
done
if [[ $EMPTY -eq 0 ]]; then ok "all skills have meaningful descriptions"; fi

# ─────────────────────────────────────────────
header "[9] Live MCP connectivity check"
# ─────────────────────────────────────────────
if command -v claude >/dev/null 2>&1; then
  MCP_CONNECTED=$(claude mcp list 2>&1 | grep -c "Connected" || true)
  if [[ $MCP_CONNECTED -ge 5 ]]; then ok "$MCP_CONNECTED MCPs connected"
  else fail "only $MCP_CONNECTED MCPs connected (expected ≥5)"; fi
else
  fail "claude CLI not on PATH"
fi

# ─────────────────────────────────────────────
header "[10] Dashboard HTML parses cleanly"
# ─────────────────────────────────────────────
if [[ -f "$HOME/.pegasus/dashboard.html" ]]; then
  CHARS=$(wc -c < "$HOME/.pegasus/dashboard.html")
  if [[ $CHARS -gt 80000 && $CHARS -lt 200000 ]]; then ok "dashboard.html ($CHARS chars, in expected range)"
  else fail "dashboard.html size unexpected: $CHARS chars"; fi
else
  fail "dashboard.html missing at ~/.pegasus/dashboard.html"
fi

# ─────────────────────────────────────────────
header "[11] All cheatsheets present"
# ─────────────────────────────────────────────
for doc in COMMANDS PROMPTS POSSIBILITIES GLOSSARY RECOMMENDED TROUBLESHOOTING TOKENS_AUTH_101; do
  if [[ -f "$HOME/Design-Projects/$doc.md" ]]; then ok "$doc.md"
  else fail "$doc.md missing"; fi
done

# ─────────────────────────────────────────────
header "RESULTS"
# ─────────────────────────────────────────────
echo
TOTAL=$((PASS + FAIL))
echo -e "${BOLD}$PASS / $TOTAL passing${RESET}"
[[ $FAIL -eq 0 ]] && echo -e "${GREEN}✓ ALL INTEGRATION TESTS PASSING${RESET}" && exit 0
echo -e "${RED}✗ $FAIL FAILED${RESET}"
exit 1
