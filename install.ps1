# Designer Dev Setup — Windows installer
# Run in PowerShell (as Administrator):
#   irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

function Write-Header($text) {
    Write-Host ""
    Write-Host $text -ForegroundColor Cyan
    Write-Host ("─" * 42) -ForegroundColor DarkGray
}
function Write-Ok($text)   { Write-Host "✓ $text" -ForegroundColor Green }
function Write-Warn($text) { Write-Host "! $text" -ForegroundColor Yellow }
function Have($cmd)        { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

function Ask($prompt) {
    $r = Read-Host "$prompt [Y/n]"
    if ([string]::IsNullOrWhiteSpace($r)) { return $true }
    return $r -match '^[Yy]'
}

# ---------- welcome ----------
Clear-Host
Write-Host @"
  ____            _                          ____
 |  _ \  ___  ___(_) __ _ _ __   ___ _ __   |  _ \  _____   __
 | | | |/ _ \/ __| |/ _` | '_ \ / _ \ '__|  | | | |/ _ \ \ / /
 | |_| |  __/\__ \ | (_| | | | |  __/ |     | |_| |  __/\ V /
 |____/ \___||___/_|\__, |_| |_|\___|_|     |____/ \___| \_/
                    |___/
       Setup — turn your laptop into a design+code studio
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "This script will set up your machine for designing with code."
Write-Host "It will install or skip:"
Write-Host "  • winget (Windows package manager — usually preinstalled)"
Write-Host "  • Git, Node.js"
Write-Host "  • Visual Studio Code"
Write-Host "  • Claude Code (Anthropic CLI)"
Write-Host "  • OpenCode (open-source alternative)"
Write-Host "  • A curated set of VS Code extensions for designers"
Write-Host "  • A Design-Projects folder with a starter CLAUDE.md"
Write-Host ""

if (-not (Ask "Ready to begin?")) { Write-Host "Skipped. Re-run any time."; exit 0 }

# ---------- 1. winget ----------
Write-Header "1 / 8  winget"
if (Have winget) {
    Write-Ok "winget is available."
} else {
    Write-Warn "winget not found. Install 'App Installer' from the Microsoft Store, then re-run this script."
    exit 1
}

# ---------- 2. Git ----------
Write-Header "2 / 8  Git"
if (Have git) {
    Write-Ok "Git already installed: $(git --version)"
} else {
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    Write-Ok "Git installed."
}

# ---------- 3. Node.js ----------
Write-Header "3 / 8  Node.js"
if (Have node) {
    Write-Ok "Node already installed: $(node --version)"
} else {
    winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
    Write-Ok "Node installed. (Restart PowerShell if 'node' is not on PATH.)"
}

# ---------- 4. VS Code ----------
Write-Header "4 / 8  Visual Studio Code"
if (Have code) {
    Write-Ok "VS Code already installed."
} else {
    winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements
    Write-Ok "VS Code installed."
}

# ---------- 5. Claude Code ----------
Write-Header "5 / 8  Claude Code"
if (Have claude) {
    Write-Ok "Claude Code already installed."
} else {
    try {
        irm https://claude.ai/install.ps1 | iex
        Write-Ok "Claude Code installed."
    } catch {
        Write-Warn "Claude installer failed; trying npm fallback..."
        npm install -g @anthropic-ai/claude-code
        Write-Ok "Claude Code installed via npm."
    }
}

# ---------- 6a. Designer extras ----------
Write-Header "6a / 8  Designer extras (Vercel, ffmpeg, ImageMagick)"
foreach ($pkg in @("Gyan.FFmpeg", "ImageMagick.ImageMagick")) {
    try { winget install --id $pkg -e --silent --accept-package-agreements --accept-source-agreements; Write-Ok "$pkg installed." }
    catch { Write-Warn "Couldn't install $pkg" }
}
if (Have vercel) { Write-Ok "Vercel CLI already installed." }
else {
    try { npm install -g vercel | Out-Null; Write-Ok "Vercel CLI installed." }
    catch { Write-Warn "Couldn't install Vercel CLI" }
}

# ---------- 6. OpenCode ----------
Write-Header "6 / 8  OpenCode"
if (Have opencode) {
    Write-Ok "OpenCode already installed."
} elseif (Ask "Install OpenCode (open-source AI coding agent) too?") {
    try {
        npm install -g opencode-ai
        Write-Ok "OpenCode installed."
    } catch {
        Write-Warn "OpenCode install failed; see https://opencode.ai for manual install."
    }
} else {
    Write-Warn "Skipped OpenCode."
}

# ---------- 7. VS Code extensions + Design-Projects folder ----------
Write-Header "7 / 8  Extensions and your design folder"

$extensions = @(
    # Requested core
    "anthropic.claude-code",                # Claude Code for VS Code
    "sst-dev.opencode",                     # OpenCode for VS Code
    "MermaidChart.vscode-mermaid-chart",    # Mermaid Chart
    "GitHub.vscode-github-actions",         # GitHub Actions
    "ms-vscode.live-server",                # Live Preview (Microsoft)
    "ms-python.python",                     # Python
    # Designer-friendly extras
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "naumovs.color-highlight",
    "kisstkondoros.vscode-gutter-preview",
    "formulahendry.auto-rename-tag",
    "PKief.material-icon-theme",
    "figma.figma-vscode-extension",
    "ecmel.vscode-html-css",
    "adpyke.codesnap"                       # Beautiful code screenshots
)

if (Have code) {
    foreach ($ext in $extensions) {
        Write-Host "Installing extension: $ext"
        try {
            code --install-extension $ext --force | Out-Null
            Write-Ok $ext
        } catch {
            Write-Warn "Could not install $ext"
        }
    }
} else {
    Write-Warn "VS Code 'code' command not on PATH yet. Restart PowerShell, then re-run."
}

$projectsDir = Join-Path $HOME "Design-Projects"
if (Test-Path $projectsDir) {
    Write-Ok "Design-Projects folder already exists at $projectsDir"
} else {
    New-Item -ItemType Directory -Path $projectsDir | Out-Null
    Write-Ok "Created $projectsDir"
}

$pegasusRaw = "https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main"
function Download-To($url, $dest) {
    if (-not (Test-Path $dest)) {
        try { Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing; Write-Ok "Wrote $(Split-Path $dest -Leaf)" }
        catch { Write-Warn "Couldn't download $(Split-Path $dest -Leaf)" }
    } else { Write-Ok "$(Split-Path $dest -Leaf) already exists, skipped." }
}
Download-To "$pegasusRaw/config/CLAUDE.md"      (Join-Path $projectsDir "CLAUDE.md")
Download-To "$pegasusRaw/docs/COMMANDS.md"      (Join-Path $projectsDir "COMMANDS.md")
Download-To "$pegasusRaw/docs/PROMPTS.md"       (Join-Path $projectsDir "PROMPTS.md")
Download-To "$pegasusRaw/docs/POSSIBILITIES.md" (Join-Path $projectsDir "POSSIBILITIES.md")

# ---------- 8. Apply Claude config + offer connect ----------
Write-Header "8 / 8  Claude config & design tool bridges"

$claudeDir = Join-Path $HOME ".claude"
$claudeSettings = Join-Path $claudeDir "settings.json"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir | Out-Null }
if (Test-Path $claudeSettings) {
    Write-Warn "You already have ~/.claude/settings.json — skipping (won't overwrite)."
    Write-Host "  See: $pegasusRaw/config/claude-settings.json for recommended base."
} else {
    try { Invoke-WebRequest -Uri "$pegasusRaw/config/claude-settings.json" -OutFile $claudeSettings -UseBasicParsing; Write-Ok "Applied Pegasus base settings to ~/.claude/settings.json" }
    catch { Write-Warn "Couldn't download base settings. Skipped." }
}

# Install Pegasus skills (works in Claude Code AND OpenCode)
Write-Host "Installing the ux-ui-audit skill..."
$skillDir = Join-Path $claudeDir "skills/ux-ui-audit"
if (-not (Test-Path $skillDir)) { New-Item -ItemType Directory -Path $skillDir -Force | Out-Null }
foreach ($f in @("SKILL.md", "checklist.md", "report-template.md")) {
    $dest = Join-Path $skillDir $f
    if (Test-Path $dest) { Write-Ok "Skill file $f already present, skipped." }
    else {
        try { Invoke-WebRequest -Uri "$pegasusRaw/skills/ux-ui-audit/$f" -OutFile $dest -UseBasicParsing; Write-Ok "Installed: skills/ux-ui-audit/$f" }
        catch { Write-Warn "Couldn't install $f" }
    }
}

Write-Host ""
Write-Host "Connect Pegasus to your design tools (Figma, Webflow, Playwright, etc.)?" -ForegroundColor White
Write-Host "Walks you through enabling each one, with prompts to skip the ones you don't use."
if (Ask "Run the connect script now?") {
    irm "$pegasusRaw/connect.ps1" | iex
} else {
    Write-Host "Skipped. Run it any time with:"
    Write-Host "  irm $pegasusRaw/connect.ps1 | iex"
}

# ---------- done ----------
Write-Header "All done"
Write-Host "You're set up." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open your projects folder:    code `"$projectsDir`""
Write-Host "  2. Read the cheatsheet:           start `"$projectsDir\COMMANDS.md`""
Write-Host "  3. Create your first project:    cd `"$projectsDir`"; mkdir hello; cd hello"
Write-Host "  4. Start Claude Code:             claude"
Write-Host "  5. Try one of the prompts in:    $projectsDir\PROMPTS.md"
Write-Host ""
Write-Host "Other Pegasus commands:"
Write-Host "  Install standalone desktop apps:  irm $pegasusRaw/desktop-apps.ps1 | iex"
Write-Host "  Connect more design tools later:  irm $pegasusRaw/connect.ps1 | iex"
Write-Host ""
Write-Host "Tip: when Claude asks you to log in, follow the link it prints."
