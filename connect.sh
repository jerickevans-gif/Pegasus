#!/usr/bin/env bash
# Connect Pegasus to your design tools.
# Sets up MCP bridges so Claude Code (and OpenCode) can read your Figma files,
# control a real browser, edit your Webflow site, and reach your Google account.
#
# Run with:
#   curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.sh | bash

set -euo pipefail

BOLD=$(printf '\033[1m'); GREEN=$(printf '\033[32m'); YELLOW=$(printf '\033[33m'); BLUE=$(printf '\033[34m'); RESET=$(printf '\033[0m')
say()    { printf "%s%s%s\n" "$BLUE" "$1" "$RESET"; }
ok()     { printf "%s✓ %s%s\n" "$GREEN" "$1" "$RESET"; }
warn()   { printf "%s! %s%s\n" "$YELLOW" "$1" "$RESET"; }
header() { printf "\n%s%s%s\n" "$BOLD" "── $1 ──" "$RESET"; }

ask_yes_no() {
  local prompt="$1" reply
  printf "%s%s [Y/n] %s" "$BOLD" "$prompt" "$RESET"
  read -r reply </dev/tty || reply="y"
  reply=${reply:-y}
  [[ "$reply" =~ ^[Yy]$ ]]
}

have() { command -v "$1" >/dev/null 2>&1; }

# ---------- prereqs ----------
if ! have claude; then
  warn "Claude Code CLI is not installed. Run install.sh first, then re-run this."
  exit 1
fi

clear || true
cat <<BANNER
   ____
  |  _ \ ___  __ _  __ _ ___ _   _ ___
  | |_) / _ \/ _` |/ _` / __| | | / __|
  |  __/  __/ (_| | (_| \__ \ |_| \__ \\
  |_|   \___|\__, |\__,_|___/\__,_|___/
             |___/
       Connect — bridge Pegasus to your design tools
BANNER

echo
say "I'll walk through each tool and ask if you use it. For each yes, I'll install"
say "the bridge (called an 'MCP server') so Claude Code can talk to that tool."
echo

# ---------- 1. Figma ----------
header "1. Figma"
echo "Lets Claude read your Figma files and turn designs into code."
echo "Requires the Figma desktop app (free download from figma.com)."
if ask_yes_no "Connect Figma?"; then
  if [[ ! -d "/Applications/Figma.app" ]] && [[ "$(uname -s)" == "Darwin" ]]; then
    warn "Figma desktop app not found in /Applications."
    if ask_yes_no "Install Figma desktop now via Homebrew?"; then
      have brew && brew install --cask figma && ok "Figma installed." \
        || warn "Could not install. Get it from https://www.figma.com/downloads/"
    fi
  fi
  echo "Adding Figma MCP server to Claude Code..."
  claude mcp add --transport sse figma http://127.0.0.1:3845/sse 2>/dev/null \
    && ok "Figma MCP added." \
    || warn "Could not add automatically. Run: claude mcp add --transport sse figma http://127.0.0.1:3845/sse"
  echo
  echo "${BOLD}Final step (do this once in Figma):${RESET}"
  echo "  1. Open the Figma desktop app and sign in."
  echo "  2. Open any file. Click the Figma logo (top-left) → Preferences."
  echo "  3. Toggle ON: 'Enable Dev Mode MCP Server'."
  echo "  4. Done — next time you run \`claude\`, paste a Figma URL and Claude can read it."
else
  warn "Skipped Figma."
fi

# ---------- 2. Playwright ----------
header "2. Playwright (browser automation)"
echo "Lets Claude open a real browser, click around, take screenshots, scrape content."
echo "Useful for: testing your portfolio in a browser, capturing references, automating."
if ask_yes_no "Connect Playwright?"; then
  echo "Adding Playwright MCP server..."
  claude mcp add playwright npx -- @playwright/mcp@latest 2>/dev/null \
    && ok "Playwright MCP added." \
    || warn "Could not add automatically. Run: claude mcp add playwright npx -- @playwright/mcp@latest"
  echo "Downloading Playwright browsers (one-time, ~200MB)..."
  npx -y playwright install chromium >/dev/null 2>&1 && ok "Chromium installed." || warn "Browser install failed; run 'npx playwright install' manually."
else
  warn "Skipped Playwright."
fi

# ---------- 3. Webflow ----------
header "3. Webflow"
echo "Lets Claude read and edit your Webflow sites — components, CMS, pages."
if ask_yes_no "Do you use Webflow?"; then
  echo "Adding Webflow MCP server..."
  claude mcp add --transport sse webflow https://mcp.webflow.com/sse 2>/dev/null \
    && ok "Webflow MCP added." \
    || warn "Could not add automatically. Run: claude mcp add --transport sse webflow https://mcp.webflow.com/sse"
  echo "${BOLD}Next step:${RESET} the first time you ask Claude to do something with Webflow,"
  echo "it'll print a login link. Open it and authorize Pegasus to use your Webflow account."
else
  warn "Skipped Webflow."
fi

# ---------- 4. Framer ----------
header "4. Framer"
echo "Framer doesn't have an official MCP server yet (as of this script's last update)."
if ask_yes_no "Do you use Framer?"; then
  echo
  echo "Workarounds you can use today:"
  echo "  • Paste public Framer URLs into Claude — it can fetch and analyze the page."
  echo "  • Export your Framer site as code and let Claude work on the export."
  echo "  • Use the Playwright MCP (above) to drive Framer's web editor for you."
  echo
  echo "When Framer ships an official MCP, we'll add a one-line install here."
fi

# ---------- 5. Google (Gmail / Drive / Calendar) ----------
header "5. Google (Gmail, Drive, Calendar)"
echo "Two paths depending on where you mostly use Claude:"
echo "  A) ${BOLD}Claude desktop app or claude.ai${RESET} — easiest. One-click connectors."
echo "  B) ${BOLD}Claude Code in VS Code${RESET} — uses community MCP servers (more setup)."
if ask_yes_no "Connect Google?"; then
  echo
  echo "${BOLD}For Claude desktop / claude.ai (recommended):${RESET}"
  echo "  1. Open https://claude.ai/settings/connectors"
  echo "  2. Click 'Connect' next to Google Drive, Gmail, or Google Calendar."
  echo "  3. Sign in with your Google account and grant access."
  echo "  4. Done — Claude can now read your Drive, Gmail, etc. when you ask."
  echo
  echo "${BOLD}For Claude Code in VS Code (advanced):${RESET}"
  echo "  Run one or more of these to wire up community MCPs:"
  echo "    claude mcp add gdrive npx -- @modelcontextprotocol/server-gdrive"
  echo "    claude mcp add gmail npx -- @gongrzhe/server-gmail-autoauth-mcp"
  echo "  Each will print an OAuth link the first time you use it."
  if ask_yes_no "Open the claude.ai connectors page in your browser now?"; then
    if have open; then open "https://claude.ai/settings/connectors"
    elif have xdg-open; then xdg-open "https://claude.ai/settings/connectors"
    else echo "Open this manually: https://claude.ai/settings/connectors"; fi
  fi
else
  warn "Skipped Google."
fi

# ---------- 6. Context7 (always-on docs) ----------
header "6. Context7 (current library docs)"
echo "Gives Claude live access to up-to-date docs for Tailwind, React, Astro,"
echo "and thousands of other libraries. Strongly recommended — no auth needed."
if ask_yes_no "Add Context7?"; then
  claude mcp add --transport http context7 https://mcp.context7.com/mcp 2>/dev/null \
    && ok "Context7 MCP added." \
    || warn "Add manually: claude mcp add --transport http context7 https://mcp.context7.com/mcp"
else
  warn "Skipped Context7."
fi

# ---------- 7. GitHub ----------
header "7. GitHub"
echo "Lets Claude create repos, open PRs, manage issues. Useful for portfolios."
if ask_yes_no "Connect GitHub?"; then
  claude mcp add github npx -- @modelcontextprotocol/server-github 2>/dev/null \
    && ok "GitHub MCP added." \
    || warn "Add manually: claude mcp add github npx -- @modelcontextprotocol/server-github"
  echo "${BOLD}Set up auth:${RESET} GitHub MCP needs a Personal Access Token."
  echo "  1. Go to https://github.com/settings/tokens?type=beta"
  echo "  2. Create a fine-grained token with repo + issues access."
  echo "  3. Run: export GITHUB_PERSONAL_ACCESS_TOKEN=<your_token>"
  echo "     (add it to your ~/.zshrc to persist)"
else
  warn "Skipped GitHub."
fi

# ---------- 8. Notion (optional) ----------
header "8. Notion (optional)"
echo "Pull case study content from Notion into your slides/sites."
if ask_yes_no "Do you use Notion?"; then
  claude mcp add --transport http notion https://mcp.notion.com/mcp 2>/dev/null \
    && ok "Notion MCP added." \
    || warn "Add manually: claude mcp add --transport http notion https://mcp.notion.com/mcp"
  echo "First time you use it, Claude will print an OAuth link to authorize."
else
  warn "Skipped Notion."
fi

# ---------- 9. Anything else ----------
header "9. Other tools"
echo "Pegasus can connect to lots more — Notion, Slack, Airtable, Stripe, GitHub..."
echo "See the full list at: https://docs.claude.com/en/docs/claude-code/mcp"
echo
echo "Quick-add pattern: claude mcp add <name> <command...>"
echo "Example: claude mcp add notion npx -- @notionhq/notion-mcp-server"

# ---------- summary ----------
header "Done"
echo "Your installed MCP servers:"
claude mcp list 2>/dev/null || warn "Run 'claude mcp list' to see them."
echo
ok "${BOLD}You're connected.${RESET}"
echo "Open VS Code, start Claude (\`claude\`), and try things like:"
echo "  • \"Pull the design from this Figma URL and build it: <url>\""
echo "  • \"Use Playwright to open my deployed site and screenshot the homepage.\""
echo "  • \"Update my Webflow site's hero copy to: ...\""
