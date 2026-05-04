#!/usr/bin/env bash
# Pegasus — Connect to your design + work tools.
#
# Default: installs every MCP bridge automatically. Auth happens on first use.
# Use --interactive to be prompted before each one.
#
# Run with:
#   curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.sh | bash -s -- --interactive

set -euo pipefail

INTERACTIVE=0
AUTO_FROM_INSTALLER=0
for arg in "$@"; do
  case "$arg" in
    --interactive) INTERACTIVE=1 ;;
    --auto)        AUTO_FROM_INSTALLER=1 ;;
  esac
done

BOLD=$(printf '\033[1m'); GREEN=$(printf '\033[32m'); YELLOW=$(printf '\033[33m'); BLUE=$(printf '\033[34m'); RESET=$(printf '\033[0m')
say()    { printf "%s%s%s\n" "$BLUE" "$1" "$RESET"; }
ok()     { printf "%s✓ %s%s\n" "$GREEN" "$1" "$RESET"; }
warn()   { printf "%s! %s%s\n" "$YELLOW" "$1" "$RESET"; }
header() { printf "\n%s%s%s\n" "$BOLD" "── $1 ──" "$RESET"; }
have()   { command -v "$1" >/dev/null 2>&1; }

ask_yes_no() {
  if [[ "$INTERACTIVE" -eq 0 ]]; then return 0; fi
  local prompt="$1" reply
  printf "%s%s [Y/n] %s" "$BOLD" "$prompt" "$RESET"
  read -r reply </dev/tty || reply="y"
  reply=${reply:-y}
  [[ "$reply" =~ ^[Yy]$ ]]
}

mcp_add_safe() {
  local name="$1"; shift
  if claude mcp list 2>/dev/null | grep -q "$name"; then
    ok "$name MCP already added."
  else
    if claude mcp add "$@" >/dev/null 2>&1; then
      ok "$name MCP added."
    else
      warn "Couldn't add $name. Try manually: claude mcp add $*"
    fi
  fi
}

if ! have claude; then
  warn "Claude Code CLI is not installed. Run install.sh first."
  exit 1
fi

if [[ "$AUTO_FROM_INSTALLER" -eq 0 ]]; then
  clear || true
  cat <<'BANNER'
   ____
  |  _ \ ___  __ _  __ _ ___ _   _ ___
  | |_) / _ \/ _` |/ _` / __| | | / __|
  |  __/  __/ (_| | (_| \__ \ |_| \__ \
  |_|   \___|\__, |\__,_|___/\__,_|___/
             |___/
       Connect — bridge to all your design + work tools
BANNER
  echo
  if [[ "$INTERACTIVE" -eq 1 ]]; then
    say "Interactive mode: I'll ask before each tool."
  else
    say "Auto mode: installing every bridge. Auth happens on first use."
    say "Pass --interactive if you'd rather pick one-by-one."
  fi
  echo
fi

# 0. Pegasus DEFAULTS — always installed, no opt-out
header "Pegasus defaults — UX Knowledge + Figma (always on)"

# UX Knowledge MCP
echo "${BOLD}1) UX Knowledge${RESET} — 28 UX resources, 23 analysis tools, WCAG, Nielsen heuristics, design systems."
mcp_add_safe ux-knowledge ux-knowledge npx -- @elsahafy/ux-mcp-server

# Figma MCP (also default)
echo "${BOLD}2) Figma${RESET} — read Figma files directly into Claude, turn designs into code."
if [[ "$(uname -s)" == "Darwin" ]] && [[ ! -d "/Applications/Figma.app" ]]; then
  if have brew; then
    say "Installing Figma desktop (required for Figma MCP)..."
    brew install --cask figma >/dev/null 2>&1 && ok "Figma desktop installed." || warn "Get Figma from https://www.figma.com/downloads/"
  fi
fi
mcp_add_safe figma --transport sse figma http://127.0.0.1:3845/sse
echo "${BOLD}One-time step in Figma:${RESET} Figma desktop → Preferences → toggle ON 'Enable Dev Mode MCP Server'."

# 2. Playwright
header "Playwright (browser automation)"
echo "Open a browser, click around, screenshot, scrape. Powers the job-finder skill."
if ask_yes_no "Connect Playwright?"; then
  mcp_add_safe playwright playwright npx -- @playwright/mcp@latest
  npx -y playwright install chromium >/dev/null 2>&1 && ok "Chromium installed." || warn "Run 'npx playwright install' manually."
fi

# 3. Webflow
header "Webflow"
echo "Read and edit Webflow sites — components, CMS, pages."
if ask_yes_no "Connect Webflow?"; then
  mcp_add_safe webflow --transport sse webflow https://mcp.webflow.com/sse
fi

# 4. Framer
header "Framer (note)"
echo "Framer doesn't have an official MCP yet. Use the Playwright MCP to drive Framer's"
echo "web editor, or paste public Framer URLs into Claude — it can fetch them directly."

# 5. Adobe Creative Cloud
header "Adobe Creative Cloud"
echo "Adobe doesn't expose an MCP. Reliable bridge:"
echo "  1. Make the work in your Adobe app."
echo "  2. Export to a web format (SVG from AI, PNG from PS, Lottie JSON from AE)."
echo "  3. Drop the file in your project folder."
echo "  4. Ask Claude: \"use the vector-workflow skill to embed this.\""
if ask_yes_no "Install Adobe Creative Cloud desktop app?"; then
  if [[ "$(uname -s)" == "Darwin" ]]; then
    have brew && brew install --cask adobe-creative-cloud >/dev/null 2>&1 && ok "Adobe CC installed." || warn "Download manually: https://creativecloud.adobe.com/apps/download/creative-cloud"
  else
    warn "On Linux, Adobe CC isn't supported. Web apps only at https://creativecloud.adobe.com"
  fi
fi

# 6. Procreate
header "Procreate (iPad — note)"
echo "Procreate has no API or MCP. Workflow:"
echo "  1. Procreate: Actions (wrench) → Share → PNG (max resolution)."
echo "  2. AirDrop to your Mac → into your project folder."
echo "  3. Ask Claude: \"use the vector-workflow skill to convert and embed.\""
echo "Pegasus pre-installs ${BOLD}potrace${RESET} (bitmap → vector) and ${BOLD}svgo${RESET} (SVG optimizer)."

# 7. Context7
header "Context7 (current library docs)"
echo "Live docs for Tailwind, React, Astro — keeps Claude's library knowledge fresh."
if ask_yes_no "Add Context7?"; then
  mcp_add_safe context7 --transport http context7 https://mcp.context7.com/mcp
fi

# 8. GitHub
header "GitHub"
echo "Create repos, open PRs, manage issues."
if ask_yes_no "Connect GitHub?"; then
  mcp_add_safe github github npx -- @modelcontextprotocol/server-github
  echo "${BOLD}Auth:${RESET} create a fine-grained token at https://github.com/settings/tokens?type=beta"
  echo "Then add to ~/.zshrc: export GITHUB_PERSONAL_ACCESS_TOKEN=<token>"
fi

# 9. Notion
header "Notion"
echo "Pull case study content from Notion into slides/sites."
if ask_yes_no "Connect Notion?"; then
  mcp_add_safe notion --transport http notion https://mcp.notion.com/mcp
fi

# 10. Linear
header "Linear (project tracking)"
if ask_yes_no "Connect Linear?"; then
  mcp_add_safe linear --transport sse linear https://mcp.linear.app/sse
fi

# 11. Stripe
header "Stripe (only if you sell)"
if ask_yes_no "Connect Stripe?"; then
  mcp_add_safe stripe stripe npx -- @stripe/mcp --tools=all
fi

# 12. Cloudflare
header "Cloudflare (DNS + Pages alternative to Vercel)"
if ask_yes_no "Connect Cloudflare?"; then
  mcp_add_safe cloudflare --transport sse cloudflare https://observability.mcp.cloudflare.com/sse
fi

# 13. Google
header "Google (Gmail · Drive · Calendar)"
echo "Easiest path: claude.ai connectors (works in Claude desktop + web)."
if ask_yes_no "Open the Google connectors page in your browser?"; then
  if have open; then open "https://claude.ai/settings/connectors"
  elif have xdg-open; then xdg-open "https://claude.ai/settings/connectors"
  else echo "Open: https://claude.ai/settings/connectors"; fi
fi

# Summary
header "Connected"
echo "Your installed MCP servers:"
claude mcp list 2>/dev/null | sed 's/^/  /' || warn "Run 'claude mcp list' to see them."

echo
ok "${BOLD}Done.${RESET}"
echo
echo "Try one of these inside any project (run \`claude\` first):"
echo "  \"Pull this Figma design and turn it into HTML: <url>\""
echo "  \"Use Playwright to screenshot the homepage of [URL]\""
echo "  \"Update my Webflow hero copy to: ...\""
echo "  \"Use the job-finder skill to find me design jobs\""
echo "  \"Use the vector-workflow skill to clean up these Procreate exports\""
