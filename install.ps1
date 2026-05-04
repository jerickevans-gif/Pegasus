# Pegasus — Windows installer (one-shot mode)
# Run in PowerShell (as Administrator):
#   irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.ps1 | iex
# Pass --custom for the question-by-question flow.

$ErrorActionPreference = "Continue"

$Custom = ($args -contains "--custom")

function Write-Header($t) {
    Write-Host ""
    Write-Host $t -ForegroundColor Cyan
    Write-Host ("─" * 42) -ForegroundColor DarkGray
}
function Write-Ok($t)   { Write-Host "✓ $t" -ForegroundColor Green }
function Write-Warn($t) { Write-Host "! $t" -ForegroundColor Yellow }
function Have($cmd)     { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Ask($prompt) {
    if (-not $Custom) { return $true }
    $r = Read-Host "$prompt [Y/n]"
    if ([string]::IsNullOrWhiteSpace($r)) { return $true }
    return $r -match '^[Yy]'
}

$pegasusRaw = "https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main"
$pegasusHome = Join-Path $HOME ".pegasus"
$projectsDir = Join-Path $HOME "Design-Projects"

function Download-To($url, $dest) {
    if (-not (Test-Path $dest)) {
        try { Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing; Write-Ok "Wrote $(Split-Path $dest -Leaf)" }
        catch { Write-Warn "Couldn't download $(Split-Path $dest -Leaf)" }
    } else { Write-Ok "$(Split-Path $dest -Leaf) already there." }
}

Clear-Host
Write-Host @"
   ____
  |  _ \ ___  __ _  __ _ ___ _   _ ___
  | |_) / _ \/ _` |/ _` / __| | | / __|
  |  __/  __/ (_| | (_| \__ \ |_| \__ \
  |_|   \___|\__, |\__,_|___/\__,_|___/
             |___/
       Designer's coding launchpad
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "About 3-5 minutes. Skip what you have. Then opens VS Code + the dashboard."
Write-Host ""
if ($Custom) { if (-not (Ask "Ready to begin?")) { Write-Host "Cancelled."; exit 0 } }

# 1. winget
Write-Header "1 / 9  winget"
if (Have winget) { Write-Ok "winget is available." }
else { Write-Warn "winget not found. Install 'App Installer' from Microsoft Store, then re-run."; exit 1 }

# 2. Git
Write-Header "2 / 9  Git"
if (Have git) { Write-Ok "Git already installed." }
else { winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements | Out-Null; Write-Ok "Git installed." }

# 3. Node.js
Write-Header "3 / 9  Node.js"
if (Have node) { Write-Ok "Node already installed." }
else { winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements | Out-Null; Write-Ok "Node installed (restart PowerShell if not on PATH)." }

# 4. VS Code
Write-Header "4 / 9  Visual Studio Code"
if (Have code) { Write-Ok "VS Code already installed." }
else { winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements | Out-Null; Write-Ok "VS Code installed." }

# 5. Coding agents + designer CLIs
Write-Header "5 / 9  Coding agents + designer CLIs"
if (Have claude) { Write-Ok "Claude Code already installed." }
else {
    try { Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression; Write-Ok "Claude Code installed." }
    catch { npm install -g @anthropic-ai/claude-code | Out-Null; Write-Ok "Claude Code installed via npm." }
}
if (Have opencode) { Write-Ok "OpenCode already installed." }
else { try { npm install -g opencode-ai | Out-Null; Write-Ok "OpenCode installed." } catch { Write-Warn "OpenCode install failed." } }

foreach ($pkg in @("Gyan.FFmpeg", "ImageMagick.ImageMagick")) {
    try { winget install --id $pkg -e --silent --accept-package-agreements --accept-source-agreements | Out-Null; Write-Ok "$pkg installed." }
    catch { Write-Warn "Couldn't install $pkg" }
}
if (Have surge) { Write-Ok "Surge CLI already installed." }
else { try { npm install -g surge | Out-Null; Write-Ok "Surge installed." } catch { Write-Warn "Couldn't install Surge CLI" } }

# Vector / SVG / image processing toolchain
foreach ($npmpkg in @("svgo","serve","@lhci/cli","pa11y","wrangler")) {
    try { npm install -g $npmpkg | Out-Null; Write-Ok "$npmpkg installed." }
    catch { Write-Warn "Couldn't install $npmpkg" }
}
# Bun
if (Have bun) { Write-Ok "Bun already installed." }
else { try { Invoke-RestMethod bun.sh/install.ps1 | Invoke-Expression; Write-Ok "Bun installed." } catch { Write-Warn "Bun install skipped." } }
# uv (for spec-kit)
if (Have uv) { Write-Ok "uv already installed." }
else { try { Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression; Write-Ok "uv installed." } catch { Write-Warn "Couldn't install uv" } }
# spec-kit
if (Have specify) { Write-Ok "spec-kit (specify) already installed." }
else {
    if (Have uv) {
        try { uv tool install --from "git+https://github.com/github/spec-kit.git" specify-cli | Out-Null; Write-Ok "spec-kit installed." }
        catch { Write-Warn "Couldn't install spec-kit. Run later: uvx --from git+https://github.com/github/spec-kit.git specify init <name>" }
    } else { Write-Warn "Skipped spec-kit (needs uv)." }
}

# 6. VS Code extensions
Write-Header "6 / 9  VS Code extensions"
$extensions = @(
    "anthropic.claude-code", "sst-dev.opencode",
    "MermaidChart.vscode-mermaid-chart", "GitHub.vscode-github-actions",
    "ms-vscode.live-server", "ms-python.python",
    "esbenp.prettier-vscode", "bradlc.vscode-tailwindcss",
    "naumovs.color-highlight", "kisstkondoros.vscode-gutter-preview",
    "formulahendry.auto-rename-tag", "PKief.material-icon-theme",
    "figma.figma-vscode-extension", "ecmel.vscode-html-css",
    "adpyke.codesnap"
)
if (Have code) {
    foreach ($ext in $extensions) {
        try { code --install-extension $ext --force | Out-Null; Write-Ok $ext }
        catch { Write-Warn "Could not install $ext" }
    }
} else { Write-Warn "VS Code 'code' command not on PATH yet — restart PowerShell, then re-run." }

# 7. Design folder + cheatsheets + templates + helper
Write-Header "7 / 9  Your design folder + templates"
if (-not (Test-Path $projectsDir)) { New-Item -ItemType Directory -Path $projectsDir | Out-Null }
Write-Ok "Design folder: $projectsDir"

Download-To "$pegasusRaw/config/CLAUDE.md"        (Join-Path $projectsDir "CLAUDE.md")
Download-To "$pegasusRaw/docs/COMMANDS.md"        (Join-Path $projectsDir "COMMANDS.md")
Download-To "$pegasusRaw/docs/PROMPTS.md"         (Join-Path $projectsDir "PROMPTS.md")
Download-To "$pegasusRaw/docs/POSSIBILITIES.md"   (Join-Path $projectsDir "POSSIBILITIES.md")
Download-To "$pegasusRaw/docs/GLOSSARY.md"        (Join-Path $projectsDir "GLOSSARY.md")
Download-To "$pegasusRaw/docs/RECOMMENDED.md"     (Join-Path $projectsDir "RECOMMENDED.md")
Download-To "$pegasusRaw/docs/TROUBLESHOOTING.md" (Join-Path $projectsDir "TROUBLESHOOTING.md")

if (-not (Test-Path "$pegasusHome/templates")) { New-Item -ItemType Directory -Path "$pegasusHome/templates" -Force | Out-Null }
foreach ($type in @("portfolio","case-study-deck","scroll-case-study","landing-page","resume","link-in-bio","illustration-gallery")) {
    $td = Join-Path "$pegasusHome/templates" $type
    if (-not (Test-Path $td)) { New-Item -ItemType Directory -Path $td -Force | Out-Null }
    foreach ($f in @("index.html","CLAUDE.md","styles.css")) {
        Download-To "$pegasusRaw/templates/$type/$f" (Join-Path $td $f)
    }
}

# Pegasus helper command (PowerShell wrapper)
$binDir = "$HOME/.pegasus/bin"
if (-not (Test-Path $binDir)) { New-Item -ItemType Directory -Path $binDir -Force | Out-Null }
$peg = Join-Path $binDir "pegasus.ps1"
Download-To "$pegasusRaw/bin/pegasus.ps1" $peg
if (Test-Path $peg) {
    # Add to PATH for current session
    $env:Path = "$binDir;$env:Path"
    # Persist to user PATH
    [Environment]::SetEnvironmentVariable("Path", "$binDir;$([Environment]::GetEnvironmentVariable('Path', 'User'))", "User")
    Write-Ok "Pegasus helper installed at $peg (added to PATH)"
}

# 8. Claude config + skills
Write-Header "8 / 9  Claude config + skills"
$claudeDir = Join-Path $HOME ".claude"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir | Out-Null }
$claudeSettings = Join-Path $claudeDir "settings.json"
if (Test-Path $claudeSettings) { Write-Ok "Existing ~/.claude/settings.json — leaving it alone." }
else { Download-To "$pegasusRaw/config/claude-settings.json" $claudeSettings }

foreach ($skill in @("ux-ui-audit","job-finder","vector-workflow")) {
    $skillDir = Join-Path $claudeDir "skills/$skill"
    if (-not (Test-Path $skillDir)) { New-Item -ItemType Directory -Path $skillDir -Force | Out-Null }
    Download-To "$pegasusRaw/skills/$skill/SKILL.md" (Join-Path $skillDir "SKILL.md")
    if ($skill -eq "ux-ui-audit") {
        Download-To "$pegasusRaw/skills/$skill/checklist.md" (Join-Path $skillDir "checklist.md")
        Download-To "$pegasusRaw/skills/$skill/report-template.md" (Join-Path $skillDir "report-template.md")
    }
}

# 9. Connect design tools
Write-Header "9 / 9  Design tool bridges"
Write-Host "Wiring up MCP bridges automatically. You'll log in on first use of each."
try { Invoke-RestMethod "$pegasusRaw/connect.ps1" | Invoke-Expression } catch { Write-Warn "Couldn't run connect.ps1" }

# Welcome page + dashboard for offline use
Download-To "$pegasusRaw/welcome.html"   "$pegasusHome/welcome.html"
Download-To "$pegasusRaw/dashboard.html" "$pegasusHome/dashboard.html"

# Done
Write-Header "All done"
Write-Host "You're set up." -ForegroundColor Green
Write-Host ""
Write-Host "Try this right now:"
Write-Host "  pegasus new portfolio my-site    # creates a working portfolio + opens VS Code"
Write-Host "  pegasus dashboard                # visual launcher in your browser"
Write-Host "  pegasus tour                     # 5-minute walkthrough"
Write-Host "  pegasus help                     # all commands"
Write-Host ""

# Auto-launch
Start-Process "$pegasusHome/welcome.html"
if (Have code) { code $projectsDir (Join-Path $projectsDir "COMMANDS.md") }
