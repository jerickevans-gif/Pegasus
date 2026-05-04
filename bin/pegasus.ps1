# Pegasus helper command (Windows)
# Usage: pegasus <subcommand> [args...]

param([string]$cmd = "help", [string]$arg1, [string]$arg2)

$ErrorActionPreference = "Continue"
$pegasusHome = if ($env:PEGASUS_HOME) { $env:PEGASUS_HOME } else { Join-Path $HOME ".pegasus" }
$templatesDir = Join-Path $pegasusHome "templates"
$projectsDir = Join-Path $HOME "Design-Projects"
$raw = "https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main"

function Write-Ok($t)   { Write-Host "✓ $t" -ForegroundColor Green }
function Write-Warn($t) { Write-Host "! $t" -ForegroundColor Yellow }
function Write-Err($t)  { Write-Host "✗ $t" -ForegroundColor Red }
function Have($c) { return [bool](Get-Command $c -ErrorAction SilentlyContinue) }

function Cmd-Help {
    Write-Host @"
Pegasus — designer's coding launchpad

  pegasus new <type> <name>     create a new project (opens VS Code)
        types: portfolio, case-study-deck, scroll-case-study,
               landing-page, resume, link-in-bio, illustration-gallery
  pegasus deploy                deploy current folder (Surge or GitHub Pages)
  pegasus dashboard             open the visual dashboard
  pegasus tour                  5-minute walkthrough
  pegasus jobs                  run the job-finder skill
  pegasus signin                open browser tabs to log into all services
  pegasus clone <url> <name>    clone any GitHub repo as a starter
  pegasus doctor                diagnose what's installed
  pegasus update                refresh templates + skills
  pegasus help                  this help
"@
}

function Cmd-New($type, $name) {
    if (-not $type -or -not $name) { Write-Warn "Usage: pegasus new <type> <name>"; return }
    $src = Join-Path $templatesDir $type
    if (-not (Test-Path $src)) { Write-Err "No template '$type'. Try: pegasus update"; return }
    if (-not (Test-Path $projectsDir)) { New-Item -ItemType Directory -Path $projectsDir | Out-Null }
    $dest = Join-Path $projectsDir $name
    if (Test-Path $dest) { Write-Err "$dest already exists."; return }
    Copy-Item -Recurse $src $dest
    Push-Location $dest
    git init -q | Out-Null
    git add . 2>$null | Out-Null
    git commit -q -m "Initial $type from Pegasus" 2>$null | Out-Null
    Pop-Location
    Write-Ok "Created $dest"
    if (Have code) { code $dest }
}

function Cmd-Deploy {
    Write-Host "Pick a deploy target — both are free, neither needs a credit card:"
    Write-Host "  1) Surge.sh — fastest, no GitHub required"
    Write-Host "  2) GitHub Pages — uses your GitHub account"
    $choice = Read-Host "Choose 1 or 2 (Enter for Surge)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }
    if ($choice -eq "1") {
        if (-not (Have surge)) { Write-Err "Surge not installed. npm install -g surge"; return }
        surge .
    } elseif ($choice -eq "2") {
        if (-not (Have gh)) { Write-Err "GitHub CLI not installed. winget install GitHub.cli"; return }
        $repo = (Get-Item -Path ".").Name
        git init -q 2>$null | Out-Null
        git add . 2>$null | Out-Null
        git commit -q -m "Deploy via Pegasus" 2>$null | Out-Null
        gh repo create $repo --public --source=. --push
        gh repo edit --enable-pages --pages-branch main
        $user = gh api user --jq '.login'
        Write-Ok "Deployed. URL: https://$user.github.io/$repo"
    } else { Write-Err "Unknown choice." }
}

function Cmd-Dashboard {
    $dash = Join-Path $pegasusHome "dashboard.html"
    if (-not (Test-Path $dash)) {
        if (-not (Test-Path $pegasusHome)) { New-Item -ItemType Directory -Path $pegasusHome | Out-Null }
        try { Invoke-WebRequest "$raw/dashboard.html" -OutFile $dash -UseBasicParsing; Write-Ok "Downloaded dashboard." } catch { Write-Err "Couldn't download."; return }
    }
    Start-Process $dash
}

function Cmd-Tour {
    Write-Host @"
Pegasus — 5-minute tour

1. Make your first project
   pegasus new portfolio my-site

2. Edit with Claude or OpenCode
   cd ~\Design-Projects\my-site; claude

3. Preview
   In VS Code right-click index.html → Show Preview, or: npx serve .

4. Ship
   pegasus deploy

5. Find jobs (later)
   pegasus jobs

6. Help
   pegasus dashboard      # visual launcher
   pegasus doctor         # diagnose
"@
}

function Cmd-Jobs {
    if (-not (Have claude)) { Write-Err "Claude Code not installed."; return }
    claude "Use the job-finder skill to pull and rank current design jobs from BuiltIn.com and LinkedIn against my profile."
}

function Cmd-Signin {
    Write-Host "Opening sign-in pages..." -ForegroundColor Cyan
    if (Have gh) { gh auth login } else { Start-Process "https://github.com/login" }
    if (Have surge) { Write-Host "Surge will prompt for email on first deploy." } else { Start-Process "https://surge.sh" }
    Start-Process "https://www.figma.com/downloads/"
    Start-Process "https://claude.ai/settings/connectors"
    Write-Ok "Opened sign-in tabs."
}

function Cmd-Clone($url, $name) {
    if (-not $url -or -not $name) {
        Write-Warn "Usage: pegasus clone <github-url> <local-name>"
        Write-Host "Examples:"
        Write-Host "  pegasus clone https://github.com/santifer/career-ops job-search"
        Write-Host "  pegasus clone https://github.com/erlandv/case my-case-portfolio"
        return
    }
    if (-not (Test-Path $projectsDir)) { New-Item -ItemType Directory -Path $projectsDir | Out-Null }
    $dest = Join-Path $projectsDir $name
    if (Test-Path $dest) { Write-Err "$dest already exists."; return }
    Write-Warn "Cloning external code from $url"
    git clone --depth 1 $url $dest
    Remove-Item -Recurse -Force (Join-Path $dest ".git")
    Push-Location $dest; git init -q; git add . 2>$null | Out-Null; Pop-Location
    Write-Ok "Cloned to $dest"
    if (Have code) { code $dest }
}

function Cmd-Doctor {
    Write-Host "Pegasus doctor — checking your setup..."
    foreach ($pair in @(
        "git|Git", "node|Node.js", "npm|npm", "code|VS Code CLI",
        "claude|Claude Code", "opencode|OpenCode", "surge|Surge",
        "gh|GitHub CLI", "ffmpeg|ffmpeg", "magick|ImageMagick",
        "specify|spec-kit (specify)", "uv|uv", "bun|Bun", "pegasus|Pegasus helper"
    )) {
        $parts = $pair -split "\|"
        if (Have $parts[0]) { Write-Ok $parts[1] } else { Write-Err "$($parts[1]) (not on PATH)" }
    }
    if (Test-Path $projectsDir) { Write-Ok "Design-Projects exists" } else { Write-Warn "Design-Projects missing" }
    if (Test-Path $templatesDir) { Write-Ok "Templates installed" } else { Write-Warn "No templates — run: pegasus update" }
    if (Have claude) { Write-Host "Claude MCP servers:"; claude mcp list }
}

function Cmd-Update {
    foreach ($type in @("portfolio","case-study-deck","scroll-case-study","landing-page","resume","link-in-bio","illustration-gallery")) {
        $td = Join-Path $templatesDir $type
        if (-not (Test-Path $td)) { New-Item -ItemType Directory -Path $td -Force | Out-Null }
        foreach ($f in @("index.html","CLAUDE.md","styles.css")) {
            try { Invoke-WebRequest "$raw/templates/$type/$f" -OutFile (Join-Path $td $f) -UseBasicParsing } catch {}
        }
    }
    Write-Ok "Templates updated."
    foreach ($skill in @("ux-ui-audit","job-finder","vector-workflow")) {
        $sd = Join-Path $HOME ".claude/skills/$skill"
        if (-not (Test-Path $sd)) { New-Item -ItemType Directory -Path $sd -Force | Out-Null }
        try { Invoke-WebRequest "$raw/skills/$skill/SKILL.md" -OutFile (Join-Path $sd "SKILL.md") -UseBasicParsing } catch {}
    }
    Write-Ok "Skills updated."
}

switch ($cmd) {
    "new"        { Cmd-New $arg1 $arg2 }
    "deploy"     { Cmd-Deploy }
    "dashboard"  { Cmd-Dashboard }
    "tour"       { Cmd-Tour }
    "jobs"       { Cmd-Jobs }
    "signin"     { Cmd-Signin }
    "clone"      { Cmd-Clone $arg1 $arg2 }
    "doctor"     { Cmd-Doctor }
    "update"     { Cmd-Update }
    "help"       { Cmd-Help }
    default      { Write-Err "Unknown command: $cmd"; Cmd-Help }
}
