#!/usr/bin/env bash
# Pegasus — macOS / Linux installer (one-shot mode)
# Run with:  curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash
#
# Default behavior: install everything, no prompts, ~3-5 minutes.
# Use --custom to run the older Q&A flow.

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

CUSTOM=0
for arg in "$@"; do
  case "$arg" in
    --custom) CUSTOM=1 ;;
  esac
done

ask_yes_no() {
  if [[ "$CUSTOM" -eq 0 ]]; then return 0; fi  # one-shot mode = always yes
  local prompt="$1" reply
  printf "%s%s [Y/n] %s" "$BOLD" "$prompt" "$RESET"
  read -r reply </dev/tty || reply="y"
  reply=${reply:-y}
  [[ "$reply" =~ ^[Yy]$ ]]
}

have() { command -v "$1" >/dev/null 2>&1; }

PEGASUS_RAW="https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main"
PROJECTS_DIR="$HOME/Design-Projects"
PEGASUS_HOME="$HOME/.pegasus"

# ---------- detect OS ----------
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="mac" ;;
  Linux)  PLATFORM="linux" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

# ---------- welcome ----------
clear || true
cat <<'BANNER'
   ____
  |  _ \ ___  __ _  __ _ ___ _   _ ___
  | |_) / _ \/ _` |/ _` / __| | | / __|
  |  __/  __/ (_| | (_| \__ \ |_| \__ \
  |_|   \___|\__, |\__,_|___/\__,_|___/
             |___/
       Designer's coding launchpad
BANNER

echo
say "This will set up your machine for designing with code."
echo "About 3-5 minutes. Skip anything you already have. Then opens VS Code."
echo
echo "Installs:"
echo "  • Homebrew (macOS) / build essentials (Linux)"
echo "  • Git, Node.js"
echo "  • Visual Studio Code + 15 extensions"
echo "  • Claude Code, OpenCode, Surge (free hosting), ffmpeg, ImageMagick"
echo "  • Pegasus base config + ux-ui-audit skill"
echo "  • Project templates (portfolio, case-study deck, landing page)"
echo "  • Bridges to Figma, Playwright, Webflow, Notion, GitHub, Context7"
echo "  • A ~/Design-Projects folder + cheatsheets"
echo "  • The 'pegasus' helper command"
echo
if [[ "$CUSTOM" -eq 1 ]]; then
  ask_yes_no "Ready to begin?" || { echo "Cancelled."; exit 0; }
fi

# ---------- 0. PRE-FLIGHT (network, disk, perms) ----------
header "0 / 9  Pre-flight check"
PREFLIGHT_OK=1
if curl -fsSL --max-time 5 https://github.com >/dev/null 2>&1; then ok "Internet reachable"
else warn "Can't reach github.com — check Wi-Fi / VPN"; PREFLIGHT_OK=0; fi

AVAIL_KB=$(df -k "$HOME" | awk 'NR==2{print $4}')
AVAIL_GB=$((AVAIL_KB / 1024 / 1024))
if [[ $AVAIL_GB -ge 2 ]]; then ok "Disk space: ${AVAIL_GB}GB free"
else warn "Only ${AVAIL_GB}GB free — need ~2GB"; PREFLIGHT_OK=0; fi

if touch "$HOME/.pegasus-write-test" 2>/dev/null && rm "$HOME/.pegasus-write-test"; then ok "Write permission to \$HOME"
else warn "Can't write to \$HOME"; PREFLIGHT_OK=0; fi

if [[ "$PREFLIGHT_OK" -eq 0 ]]; then
  echo; warn "Pre-flight failed. Fix issues above and re-run install.sh."
  exit 1
fi

# ---------- 1. Homebrew (macOS) ----------
if [[ "$PLATFORM" == "mac" ]]; then
  header "1 / 9  Homebrew"
  if have brew; then
    ok "Homebrew already installed."
  else
    say "Installing Homebrew (you may be prompted for your password)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
  header "1 / 9  Package manager"
  if have apt-get; then
    PKG_INSTALL="sudo apt-get install -y"
    CASK_INSTALL=""
    sudo apt-get update -y >/dev/null 2>&1
    ok "apt-get ready."
  elif have dnf; then
    PKG_INSTALL="sudo dnf install -y"
    CASK_INSTALL=""
    ok "dnf ready."
  else
    warn "No supported package manager. Install git/node/vscode manually then re-run."
    exit 1
  fi
fi

# ---------- 2. Git ----------
header "2 / 9  Git"
if have git; then
  ok "Git already installed: $(git --version)"
else
  say "Installing Git..."; $PKG_INSTALL git >/dev/null 2>&1 && ok "Git installed."
fi

# ---------- 3. Node.js ----------
header "3 / 9  Node.js"
if have node; then
  ok "Node already installed: $(node --version)"
else
  say "Installing Node.js (LTS)..."
  if [[ "$PLATFORM" == "mac" ]]; then
    brew install node >/dev/null 2>&1
  else
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - >/dev/null 2>&1
    sudo apt-get install -y nodejs >/dev/null 2>&1
  fi
  ok "Node installed: $(node --version 2>/dev/null || echo present)"
fi

# ---------- 4. VS Code ----------
header "4 / 9  Visual Studio Code"
if have cursor; then ok "Cursor IDE detected (alternative to VS Code, also supported by Pegasus)."; fi
if have code; then
  ok "VS Code already installed."
else
  say "Installing VS Code..."
  if [[ "$PLATFORM" == "mac" ]]; then
    $CASK_INSTALL visual-studio-code >/dev/null 2>&1
    if ! have code && [[ -d "/Applications/Visual Studio Code.app" ]]; then
      ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code 2>/dev/null || true
    fi
  else
    have snap && sudo snap install code --classic >/dev/null 2>&1 || warn "Install VS Code from https://code.visualstudio.com/ then re-run."
  fi
  ok "VS Code installed."
fi

# ---------- 5. Claude Code, OpenCode, designer CLIs ----------
header "5 / 9  Coding agents + designer CLIs"
if have claude; then
  ok "Claude Code already installed."
else
  say "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash >/dev/null 2>&1 || npm install -g @anthropic-ai/claude-code >/dev/null 2>&1
  ok "Claude Code installed."
fi
if have opencode; then
  ok "OpenCode already installed."
else
  say "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash >/dev/null 2>&1 || npm install -g opencode-ai >/dev/null 2>&1
  ok "OpenCode installed."
fi
if [[ "$PLATFORM" == "mac" ]]; then
  for pkg in ffmpeg imagemagick; do
    if brew list "$pkg" >/dev/null 2>&1; then ok "$pkg already installed."
    else say "Installing $pkg..."; brew install "$pkg" >/dev/null 2>&1 && ok "$pkg installed." || warn "Couldn't install $pkg"
    fi
  done
else
  for pkg in ffmpeg imagemagick; do
    have "$pkg" && ok "$pkg already installed." || ($PKG_INSTALL "$pkg" >/dev/null 2>&1 && ok "$pkg installed." || warn "Couldn't install $pkg")
  done
fi
if have surge; then ok "Surge CLI already installed."
else say "Installing Surge CLI (free static hosting, no account / card needed)..."; npm install -g surge >/dev/null 2>&1 && ok "Surge installed." || warn "Couldn't install Surge"
fi
# Vector / SVG / image processing toolchain
if [[ "$PLATFORM" == "mac" ]]; then
  for pkg in potrace; do
    if brew list "$pkg" >/dev/null 2>&1; then ok "$pkg already installed."
    else say "Installing $pkg..."; brew install "$pkg" >/dev/null 2>&1 && ok "$pkg installed." || warn "Couldn't install $pkg"
    fi
  done
else
  have potrace && ok "potrace already installed." || ($PKG_INSTALL potrace >/dev/null 2>&1 && ok "potrace installed." || warn "Couldn't install potrace")
fi
# npm-installed designer extras
for npmpkg in svgo serve @lhci/cli pa11y wrangler; do
  if npm ls -g "$npmpkg" --depth=0 >/dev/null 2>&1; then
    ok "$npmpkg already installed."
  else
    say "Installing $npmpkg (npm)..."
    npm install -g "$npmpkg" >/dev/null 2>&1 && ok "$npmpkg installed." || warn "Couldn't install $npmpkg"
  fi
done
# Bun (fast JS runtime — useful for templates that grow into bundled apps)
if have bun; then
  ok "Bun already installed."
else
  say "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash >/dev/null 2>&1 && ok "Bun installed." || warn "Couldn't install Bun (skip — non-critical)"
fi
# uv (Python package manager) — needed to install spec-kit
if have uv; then
  ok "uv already installed."
else
  say "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1 && ok "uv installed." || warn "Couldn't install uv"
fi
# spec-kit (Spec-Driven Development toolkit, github/spec-kit, 92k★)
if have specify; then
  ok "spec-kit (specify) already installed."
else
  say "Installing spec-kit (specify CLI)..."
  if have uv; then
    "$HOME/.cargo/bin/uv" tool install --from git+https://github.com/github/spec-kit.git specify-cli >/dev/null 2>&1 \
      || uv tool install --from git+https://github.com/github/spec-kit.git specify-cli >/dev/null 2>&1 \
      && ok "spec-kit installed." || warn "Couldn't install spec-kit (you can run it ad-hoc with: uvx --from git+https://github.com/github/spec-kit.git specify init <name>)"
  else
    warn "Skipped spec-kit (needs uv). Run later: uvx --from git+https://github.com/github/spec-kit.git specify init <name>"
  fi
fi

# ---------- 6. VS Code extensions ----------
header "6 / 9  VS Code extensions"
EXTENSIONS=(
  "anthropic.claude-code"
  "sst-dev.opencode"
  "MermaidChart.vscode-mermaid-chart"
  "GitHub.vscode-github-actions"
  "ms-vscode.live-server"
  "ms-python.python"
  "esbenp.prettier-vscode"
  "bradlc.vscode-tailwindcss"
  "naumovs.color-highlight"
  "kisstkondoros.vscode-gutter-preview"
  "formulahendry.auto-rename-tag"
  "PKief.material-icon-theme"
  "figma.figma-vscode-extension"
  "ecmel.vscode-html-css"
  "adpyke.codesnap"
)
if have code; then
  for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" --force >/dev/null 2>&1 && ok "$ext" || warn "Could not install $ext"
  done
else
  warn "VS Code 'code' command not on PATH. Open VS Code → Cmd+Shift+P → 'Install code command in PATH', then re-run."
fi

# ---------- 7. Design-Projects folder + cheatsheets + templates ----------
header "7 / 9  Your design folder + templates"
mkdir -p "$PROJECTS_DIR" && ok "Design folder: $PROJECTS_DIR"

download_to() {
  local url="$1" dest="$2"
  if [[ ! -f "$dest" ]]; then
    curl -fsSL "$url" -o "$dest" 2>/dev/null && ok "Wrote $(basename "$dest")" || warn "Couldn't download $(basename "$dest")"
  else ok "$(basename "$dest") already there."
  fi
}
download_to "$PEGASUS_RAW/config/CLAUDE.md"        "$PROJECTS_DIR/CLAUDE.md"
download_to "$PEGASUS_RAW/docs/COMMANDS.md"        "$PROJECTS_DIR/COMMANDS.md"
download_to "$PEGASUS_RAW/docs/PROMPTS.md"         "$PROJECTS_DIR/PROMPTS.md"
download_to "$PEGASUS_RAW/docs/POSSIBILITIES.md"   "$PROJECTS_DIR/POSSIBILITIES.md"
download_to "$PEGASUS_RAW/docs/GLOSSARY.md"        "$PROJECTS_DIR/GLOSSARY.md"
download_to "$PEGASUS_RAW/docs/RECOMMENDED.md"     "$PROJECTS_DIR/RECOMMENDED.md"
download_to "$PEGASUS_RAW/docs/TROUBLESHOOTING.md" "$PROJECTS_DIR/TROUBLESHOOTING.md"
download_to "$PEGASUS_RAW/docs/TOKENS_AUTH_101.md"  "$PROJECTS_DIR/TOKENS_AUTH_101.md"
download_to "$PEGASUS_RAW/config/PROJECTS_README.md" "$PROJECTS_DIR/README.md"

# Templates → ~/.pegasus/templates
mkdir -p "$PEGASUS_HOME/templates"
for type in portfolio case-study-deck scroll-case-study landing-page resume link-in-bio illustration-gallery mood-board components-lab agency-page error-page podcast-page newsletter-archive; do
  mkdir -p "$PEGASUS_HOME/templates/$type"
  for f in index.html CLAUDE.md styles.css .gitignore; do
    download_to "$PEGASUS_RAW/templates/$type/$f" "$PEGASUS_HOME/templates/$type/$f"
  done
done

# Pegasus helper command → /usr/local/bin or ~/.local/bin
say "Installing the 'pegasus' helper command..."
TMP_PEGASUS=$(mktemp)
if curl -fsSL "$PEGASUS_RAW/bin/pegasus" -o "$TMP_PEGASUS" 2>/dev/null; then
  chmod +x "$TMP_PEGASUS"
  if [[ -w /usr/local/bin ]]; then
    mv "$TMP_PEGASUS" /usr/local/bin/pegasus && ok "Installed: /usr/local/bin/pegasus"
  else
    mkdir -p "$HOME/.local/bin"
    mv "$TMP_PEGASUS" "$HOME/.local/bin/pegasus" && ok "Installed: ~/.local/bin/pegasus"
    case ":$PATH:" in
      *":$HOME/.local/bin:"*) ;;
      *) warn "Add ~/.local/bin to your PATH. Add this line to ~/.zshrc:"
         echo '         export PATH="$HOME/.local/bin:$PATH"' ;;
    esac
  fi
else
  warn "Couldn't download pegasus helper."
fi

# ---------- 8. Claude config + skill ----------
header "8 / 9  Claude config + ux-ui-audit skill"
CLAUDE_DIR="$HOME/.claude"; mkdir -p "$CLAUDE_DIR"
CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"
if [[ -f "$CLAUDE_SETTINGS" ]]; then
  ok "Existing ~/.claude/settings.json — leaving it alone."
else
  curl -fsSL "$PEGASUS_RAW/config/claude-settings.json" -o "$CLAUDE_SETTINGS" 2>/dev/null \
    && ok "Applied Pegasus base settings." || warn "Couldn't write base settings."
fi
# OpenCode parity — same MCPs Pegasus configures for Claude Code
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
OPENCODE_CONFIG="$OPENCODE_CONFIG_DIR/opencode.json"
mkdir -p "$OPENCODE_CONFIG_DIR"
if [[ -f "$OPENCODE_CONFIG" ]]; then
  ok "Existing OpenCode config — leaving it alone (delete to apply Pegasus defaults)."
else
  download_to "$PEGASUS_RAW/config/opencode.json" "$OPENCODE_CONFIG"
  ok "Wrote OpenCode config with ux-knowledge + context7 + playwright + figma MCPs."
fi

for skill in ux-ui-audit job-finder vector-workflow interview-prep content-writer \
             figma-converter weekly-review \
             portfolio-case-study \
             resume-tailor cover-letter-generator portfolio-case-study-writer interview-prep-generator salary-negotiation-prep \
             creative-portfolio-resume linkedin-profile-optimizer job-description-analyzer offer-comparison-analyzer resume-ats-optimizer \
             career-ops-evaluate career-ops-outreach career-ops-research career-ops-tailor-resume career-ops-triage \
             career-ops-scan career-ops-apply career-ops-compare career-ops-help \
             mp-to-prd mp-zoom-out mp-diagnose mp-git-guardrails; do
  SKILL_DIR="$CLAUDE_DIR/skills/$skill"; mkdir -p "$SKILL_DIR"
  download_to "$PEGASUS_RAW/skills/$skill/SKILL.md" "$SKILL_DIR/SKILL.md"
  # optional companions (only ux-ui-audit has them)
  for f in checklist.md report-template.md; do
    [[ "$skill" == "ux-ui-audit" ]] && download_to "$PEGASUS_RAW/skills/$skill/$f" "$SKILL_DIR/$f"
  done
done

# ---------- 9. Connect design tools ----------
header "9 / 9  Design tool bridges (Figma, Playwright, Webflow, Notion, GitHub, Context7)"
say "Wiring up MCP bridges automatically. You'll log in on first use of each."
curl -fsSL "$PEGASUS_RAW/connect.sh" | bash -s -- --auto || warn "Couldn't run connect.sh — re-run manually with: curl -fsSL $PEGASUS_RAW/connect.sh | bash"

# Download the welcome page + dashboard for offline use
download_to "$PEGASUS_RAW/welcome.html"          "$PEGASUS_HOME/welcome.html"
download_to "$PEGASUS_RAW/dashboard.html"        "$PEGASUS_HOME/dashboard.html"
download_to "$PEGASUS_RAW/favicon.svg"           "$PEGASUS_HOME/favicon.svg"
download_to "$PEGASUS_RAW/manifest.webmanifest"  "$PEGASUS_HOME/manifest.webmanifest"
download_to "$PEGASUS_RAW/sw.js"                 "$PEGASUS_HOME/sw.js"

# ---------- finish ----------
header "All done"
cat <<EOF
${GREEN}${BOLD}You're set up.${RESET}

Try this right now:
  ${BOLD}pegasus new portfolio my-site${RESET}    # creates a working portfolio + opens VS Code
  ${BOLD}pegasus dashboard${RESET}                # visual launcher in your browser
  ${BOLD}pegasus tour${RESET}                     # 5-minute walkthrough
  ${BOLD}pegasus help${RESET}                     # all commands

Cheatsheets are in ${BOLD}$PROJECTS_DIR${RESET}:
  COMMANDS.md · PROMPTS.md · POSSIBILITIES.md · GLOSSARY.md · TROUBLESHOOTING.md · RECOMMENDED.md
EOF

# Auto-launch: visual dashboard in browser, then VS Code with cheatsheet
if have open; then open "$PEGASUS_HOME/welcome.html" 2>/dev/null || true
elif have xdg-open; then xdg-open "$PEGASUS_HOME/welcome.html" 2>/dev/null || true
fi
if have code; then
  echo
  say "Opening VS Code with your projects folder + the cheatsheet..."
  code "$PROJECTS_DIR" "$PROJECTS_DIR/COMMANDS.md" 2>/dev/null || true
fi

# macOS notification
if [[ "$PLATFORM" == "mac" ]] && have osascript; then
  osascript -e 'display notification "You are set up. Try: pegasus new portfolio my-site" with title "Pegasus"' 2>/dev/null || true
fi
