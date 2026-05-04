# Install the standalone "outside VS Code" tools:
#   • Claude desktop app
#   • Claude Code CLI
#   • OpenCode CLI
#
# Run in PowerShell:
#   irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/desktop-apps.ps1 | iex

$ErrorActionPreference = "Stop"
function Write-Ok($t)   { Write-Host "✓ $t" -ForegroundColor Green }
function Write-Warn($t) { Write-Host "! $t" -ForegroundColor Yellow }
function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

Write-Host "Designer Dev Setup — desktop / standalone apps" -ForegroundColor Cyan
Write-Host "Installs the apps you can use OUTSIDE of VS Code:"
Write-Host "  • Claude desktop app"
Write-Host "  • Claude Code CLI"
Write-Host "  • OpenCode CLI"
Write-Host ""

# Claude desktop app
Write-Host "Installing Claude desktop app..."
if (Have winget) {
    try {
        winget install --id Anthropic.Claude -e --silent --accept-package-agreements --accept-source-agreements
        Write-Ok "Claude desktop app installed."
    } catch {
        Write-Warn "winget install failed. Download manually: https://claude.ai/download"
    }
} else {
    Write-Warn "winget not found. Download Claude desktop manually: https://claude.ai/download"
}

# Claude Code CLI
Write-Host "Ensuring Claude Code CLI is installed..."
if (Have claude) {
    Write-Ok "Claude Code CLI already installed."
} else {
    try {
        irm https://claude.ai/install.ps1 | iex
        Write-Ok "Claude Code CLI installed."
    } catch {
        npm install -g @anthropic-ai/claude-code
        Write-Ok "Claude Code CLI installed via npm."
    }
}

# OpenCode CLI
Write-Host "Ensuring OpenCode CLI is installed..."
if (Have opencode) {
    Write-Ok "OpenCode CLI already installed."
} else {
    npm install -g opencode-ai
    Write-Ok "OpenCode CLI installed."
}

Write-Host ""
Write-Ok "Done."
Write-Host ""
Write-Host "How to use them:"
Write-Host "  Claude desktop app  - open from Start menu. Best for chat/brainstorming."
Write-Host "  Claude Code CLI     - open Terminal/PowerShell, cd into a folder, type `claude`."
Write-Host "  OpenCode CLI        - same idea, type `opencode`."
Write-Host ""
Write-Host "Note: there's no separate OpenCode desktop app today — the CLI/TUI IS the standalone version."
