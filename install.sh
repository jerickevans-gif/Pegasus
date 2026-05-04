#!/usr/bin/env bash
# Designer Dev Setup — macOS / Linux installer
# Run with:  curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash

set -euo pipefail

# ---------- pretty printing ----------
BOLD=$(printf '\033[1m')
DIM=$(printf '\033[2m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
RESET=$(printf '\033[0m')

say()    { printf "%s%s%s\n" "$BLUE" "$1" "$RESET"; }
ok()     { printf "%s✓ %s%s\n" "$GREEN" "$1" "$RESET"; }
warn()   { printf "%s! %s%s\n" "$YELLOW" "$1" "$RESET"; }
header() { printf "\n%s%s%s\n%s%s%s\n\n" "$BOLD" "$1" "$RESET" "$DIM" "──────────────────────────────────────────" "$RESET"; }

ask_yes_no() {
  local prompt="$1"
  local reply
  printf "%s%s [Y/n] %s" "$BOLD" "$prompt" "$RESET"
  read -r reply </dev/tty || reply="y"
  reply=${reply:-y}
  [[ "$reply" =~ ^[Yy]$ ]]
}

have() { command -v "$1" >/dev/null 2>&1; }

# ---------- detect OS ----------
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="mac" ;;
  Linux)  PLATFORM="linux" ;;
  *) echo "Unsupported OS: $OS. This installer supports macOS and Linux."; exit 1 ;;
esac

# ---------- welcome ----------
clear || true
cat <<'BANNER'
  ____            _                          ____
 |  _ \  ___  ___(_) __ _ _ __   ___ _ __   |  _ \  _____   __
 | | | |/ _ \/ __| |/ _` | '_ \ / _ \ '__|  | | | |/ _ \ \ / /
 | |_| |  __/\__ \ | (_| | | | |  __/ |     | |_| |  __/\ V /
 |____/ \___||___/_|\__, |_| |_|\___|_|     |____/ \___| \_/
                    |___/
       Setup — turn your laptop into a design+code studio
BANNER

echo
say "This script will set up your machine for designing with code."
echo "It will install or skip:"
echo "  • Homebrew (macOS) / build essentials (Linux)"
echo "  • Git, Node.js"
echo "  • Visual Studio Code"
echo "  • Claude Code (Anthropic CLI)"
echo "  • OpenCode (open-source alternative)"
echo "  • A curated set of VS Code extensions for designers"
echo "  • A ~/Design-Projects folder with a starter CLAUDE.md"
echo

if ! ask_yes_no "Ready to begin?"; then
  echo "Skipped. Re-run any time."
  exit 0
fi

# ---------- 1. Homebrew (macOS) ----------
if [[ "$PLATFORM" == "mac" ]]; then
  header "1 / 8  Homebrew"
  if have brew; then
    ok "Homebrew already installed."
  else
    say "Installing Homebrew (you may be prompted for your password)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # add to PATH for current session (Apple Silicon vs Intel)
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    ok "Homebrew installed."
  fi
  PKG_INSTALL="brew install"
  CASK_INSTALL="brew install --cask"
else
  header "1 / 8  Package manager"
  if have apt-get; then
    PKG_INSTALL="sudo apt-get install -y"
    CASK_INSTALL=""
    sudo apt-get update -y
    ok "apt-get ready."
  elif have dnf; then
    PKG_INSTALL="sudo dnf install -y"
    CASK_INSTALL=""
    ok "dnf ready."
  else
    warn "No supported package manager found. Install git/node/vscode manually, then re-run."
    exit 1
  fi
fi

# ---------- 2. Git ----------
header "2 / 8  Git"
if have git; then
  ok "Git already installed: $(git --version)"
else
  say "Installing Git..."
  $PKG_INSTALL git
  ok "Git installed."
fi

# ---------- 3. Node.js ----------
header "3 / 8  Node.js"
if have node; then
  ok "Node already installed: $(node --version)"
else
  say "Installing Node.js (LTS)..."
  if [[ "$PLATFORM" == "mac" ]]; then
    brew install node
  else
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
  ok "Node installed: $(node --version)"
fi

# ---------- 4. VS Code ----------
header "4 / 8  Visual Studio Code"
if have code; then
  ok "VS Code already installed."
else
  say "Installing VS Code..."
  if [[ "$PLATFORM" == "mac" ]]; then
    $CASK_INSTALL visual-studio-code
    # ensure 'code' CLI is on PATH
    if ! have code && [[ -d "/Applications/Visual Studio Code.app" ]]; then
      ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code 2>/dev/null || true
    fi
  else
    if have snap; then
      sudo snap install code --classic
    else
      warn "Install VS Code from https://code.visualstudio.com/ then re-run."
    fi
  fi
  ok "VS Code installed."
fi

# ---------- 5. Claude Code ----------
header "5 / 8  Claude Code"
if have claude; then
  ok "Claude Code already installed: $(claude --version 2>/dev/null || echo present)"
else
  say "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || npm install -g @anthropic-ai/claude-code
  ok "Claude Code installed."
fi

# ---------- 6a. Designer-friendly extra CLI tools ----------
header "6a / 8  Designer extras (Vercel, ffmpeg, ImageMagick)"
if [[ "$PLATFORM" == "mac" ]]; then
  for pkg in ffmpeg imagemagick; do
    if brew list "$pkg" >/dev/null 2>&1; then
      ok "$pkg already installed."
    else
      say "Installing $pkg..."; brew install "$pkg" >/dev/null 2>&1 && ok "$pkg installed." || warn "Couldn't install $pkg"
    fi
  done
else
  for pkg in ffmpeg imagemagick; do
    have "$pkg" && ok "$pkg already installed." || ($PKG_INSTALL "$pkg" >/dev/null 2>&1 && ok "$pkg installed." || warn "Couldn't install $pkg")
  done
fi
if have vercel; then
  ok "Vercel CLI already installed."
else
  say "Installing Vercel CLI..."; npm install -g vercel >/dev/null 2>&1 && ok "Vercel CLI installed." || warn "Couldn't install Vercel CLI"
fi

# ---------- 6. OpenCode ----------
header "6 / 8  OpenCode"
if have opencode; then
  ok "OpenCode already installed."
else
  if ask_yes_no "Install OpenCode (open-source AI coding agent) too?"; then
    say "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash || npm install -g opencode-ai
    ok "OpenCode installed."
  else
    warn "Skipped OpenCode."
  fi
fi

# ---------- 7. VS Code extensions + Design-Projects folder ----------
header "7 / 8  Extensions and your design folder"

EXTENSIONS=(
  # Requested core
  "anthropic.claude-code"               # Claude Code for VS Code
  "sst-dev.opencode"                    # OpenCode for VS Code
  "MermaidChart.vscode-mermaid-chart"   # Mermaid Chart
  "GitHub.vscode-github-actions"        # GitHub Actions
  "ms-vscode.live-server"               # Live Preview (Microsoft)
  "ms-python.python"                    # Python
  # Designer-friendly extras
  "esbenp.prettier-vscode"              # Prettier formatter
  "bradlc.vscode-tailwindcss"           # Tailwind CSS IntelliSense
  "naumovs.color-highlight"             # Highlight color codes
  "kisstkondoros.vscode-gutter-preview" # Image preview in gutter
  "formulahendry.auto-rename-tag"       # Auto-rename paired HTML tags
  "PKief.material-icon-theme"           # Pretty file icons
  "figma.figma-vscode-extension"        # Figma in VS Code
  "ecmel.vscode-html-css"               # HTML/CSS support
  "adpyke.codesnap"                     # Beautiful code screenshots
)

if have code; then
  for ext in "${EXTENSIONS[@]}"; do
    say "Installing extension: $ext"
    code --install-extension "$ext" --force >/dev/null 2>&1 && ok "$ext" || warn "Could not install $ext"
  done
else
  warn "VS Code 'code' command not on PATH — open VS Code, run 'Shell Command: Install code command in PATH', then re-run."
fi

# ---------- create Design-Projects folder ----------
PROJECTS_DIR="$HOME/Design-Projects"
if [[ -d "$PROJECTS_DIR" ]]; then
  ok "Design-Projects folder already exists at $PROJECTS_DIR"
else
  mkdir -p "$PROJECTS_DIR"
  ok "Created $PROJECTS_DIR"
fi

# Drop the starter CLAUDE.md and the cheatsheet docs into the projects folder
PEGASUS_RAW="https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main"
download_to() {
  local url="$1" dest="$2"
  if [[ ! -f "$dest" ]]; then
    curl -fsSL "$url" -o "$dest" 2>/dev/null && ok "Wrote $(basename "$dest")" || warn "Couldn't download $(basename "$dest")"
  else
    ok "$(basename "$dest") already exists, skipped."
  fi
}
download_to "$PEGASUS_RAW/config/CLAUDE.md"     "$PROJECTS_DIR/CLAUDE.md"
download_to "$PEGASUS_RAW/docs/COMMANDS.md"     "$PROJECTS_DIR/COMMANDS.md"
download_to "$PEGASUS_RAW/docs/PROMPTS.md"      "$PROJECTS_DIR/PROMPTS.md"
download_to "$PEGASUS_RAW/docs/POSSIBILITIES.md" "$PROJECTS_DIR/POSSIBILITIES.md"

# ---------- 8. Apply Claude Code base settings + offer connect.sh ----------
header "8 / 8  Claude config & design tool bridges"

CLAUDE_DIR="$HOME/.claude"
CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"
mkdir -p "$CLAUDE_DIR"
if [[ -f "$CLAUDE_SETTINGS" ]]; then
  warn "You already have ~/.claude/settings.json — skipping (won't overwrite)."
  echo "  To use Pegasus's recommended base settings, see:"
  echo "  $PEGASUS_RAW/config/claude-settings.json"
else
  if curl -fsSL "$PEGASUS_RAW/config/claude-settings.json" -o "$CLAUDE_SETTINGS" 2>/dev/null; then
    ok "Applied Pegasus base settings to ~/.claude/settings.json"
  else
    warn "Couldn't download base settings. Skipped."
  fi
fi

# Install Pegasus skills (also picked up by OpenCode automatically)
say "Installing the ux-ui-audit skill (works in both Claude Code and OpenCode)..."
SKILL_DIR="$CLAUDE_DIR/skills/ux-ui-audit"
mkdir -p "$SKILL_DIR"
for f in SKILL.md checklist.md report-template.md; do
  if [[ -f "$SKILL_DIR/$f" ]]; then
    ok "Skill file $f already present, skipped."
  else
    curl -fsSL "$PEGASUS_RAW/skills/ux-ui-audit/$f" -o "$SKILL_DIR/$f" 2>/dev/null && ok "Installed: skills/ux-ui-audit/$f" || warn "Couldn't install $f"
  fi
done

echo
say "${BOLD}Connect Pegasus to your design tools (Figma, Webflow, Playwright, etc.)?${RESET}"
echo "This walks you through enabling each one, with prompts to skip the ones you don't use."
if ask_yes_no "Run the connect script now?"; then
  curl -fsSL "$PEGASUS_RAW/connect.sh" | bash
else
  echo "Skipped. Run it any time with:"
  echo "  ${BOLD}curl -fsSL $PEGASUS_RAW/connect.sh | bash${RESET}"
fi

# ---------- done ----------
header "All done"
cat <<EOF
${GREEN}${BOLD}You're set up.${RESET}

Next steps:
  1. Open your projects folder:    ${BOLD}code "$PROJECTS_DIR"${RESET}
  2. Read the cheatsheet:           ${BOLD}open "$PROJECTS_DIR/COMMANDS.md"${RESET}
  3. Create your first project:    ${BOLD}cd "$PROJECTS_DIR" && mkdir hello && cd hello${RESET}
  4. Start Claude Code:             ${BOLD}claude${RESET}
  5. Try one of the prompts in:    ${BOLD}$PROJECTS_DIR/PROMPTS.md${RESET}

Other Pegasus commands:
  • Install standalone desktop apps:  ${BOLD}curl -fsSL $PEGASUS_RAW/desktop-apps.sh | bash${RESET}
  • Connect more design tools later:  ${BOLD}curl -fsSL $PEGASUS_RAW/connect.sh | bash${RESET}

Tip: when Claude asks you to log in, follow the link it prints in the terminal.
EOF
