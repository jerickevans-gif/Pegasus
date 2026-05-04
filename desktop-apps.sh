#!/usr/bin/env bash
# Install the standalone "outside VS Code" tools:
#   • Claude desktop app (chat / brainstorming, not coding)
#   • Claude Code CLI (run from any terminal)
#   • OpenCode CLI (run from any terminal — there's no separate desktop OpenCode app today)
#
# Run with:
#   curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/desktop-apps.sh | bash

set -euo pipefail

BOLD=$(printf '\033[1m'); GREEN=$(printf '\033[32m'); YELLOW=$(printf '\033[33m'); BLUE=$(printf '\033[34m'); RESET=$(printf '\033[0m')
say()  { printf "%s%s%s\n" "$BLUE" "$1" "$RESET"; }
ok()   { printf "%s✓ %s%s\n" "$GREEN" "$1" "$RESET"; }
warn() { printf "%s! %s%s\n" "$YELLOW" "$1" "$RESET"; }
have() { command -v "$1" >/dev/null 2>&1; }

OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="mac" ;;
  Linux)  PLATFORM="linux" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

echo
say "${BOLD}Designer Dev Setup — desktop / standalone apps${RESET}"
echo "This installs the apps you can use OUTSIDE of VS Code:"
echo "  • Claude desktop app (chat — for brainstorming, writing, research)"
echo "  • Claude Code CLI (run \`claude\` from any terminal)"
echo "  • OpenCode CLI (run \`opencode\` from any terminal)"
echo

# -------- Claude desktop app --------
say "Installing Claude desktop app..."
if [[ "$PLATFORM" == "mac" ]]; then
  if [[ -d "/Applications/Claude.app" ]]; then
    ok "Claude desktop app already installed."
  elif have brew; then
    brew install --cask claude && ok "Claude desktop app installed."
  else
    warn "Homebrew not found. Download manually: https://claude.ai/download"
  fi
else
  warn "On Linux, download Claude desktop manually: https://claude.ai/download"
fi

# -------- Claude Code CLI --------
say "Ensuring Claude Code CLI is installed..."
if have claude; then
  ok "Claude Code CLI already installed: $(claude --version 2>/dev/null || echo present)"
else
  curl -fsSL https://claude.ai/install.sh | bash || npm install -g @anthropic-ai/claude-code
  ok "Claude Code CLI installed."
fi

# -------- OpenCode CLI --------
say "Ensuring OpenCode CLI is installed..."
if have opencode; then
  ok "OpenCode CLI already installed."
else
  curl -fsSL https://opencode.ai/install | bash || npm install -g opencode-ai
  ok "OpenCode CLI installed."
fi

echo
ok "${BOLD}Done.${RESET}"
cat <<EOF

How to use them:

  ${BOLD}Claude desktop app${RESET}
    Open it from your Applications folder (macOS) or Start menu (Windows).
    Best for: brainstorming, writing copy, research — not editing code files.

  ${BOLD}Claude Code CLI${RESET}
    Open Terminal, ${BOLD}cd${RESET} into any project folder, type ${BOLD}claude${RESET}.
    Best for: coding outside VS Code, scripting, working on a remote server.

  ${BOLD}OpenCode CLI${RESET}
    Open Terminal, ${BOLD}cd${RESET} into any project folder, type ${BOLD}opencode${RESET}.
    Best for: same as above, but with the open-source agent and any model provider.

  Note: there's no separate "OpenCode desktop app" today — the CLI/TUI IS the
  standalone version. The VS Code extension just wraps it for editor use.
EOF
