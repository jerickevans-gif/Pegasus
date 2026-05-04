# Connect Pegasus to your design tools (Windows).
# Run in PowerShell:
#   irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.ps1 | iex

$ErrorActionPreference = "Stop"
function Write-Header($t) { Write-Host ""; Write-Host "── $t ──" -ForegroundColor Cyan }
function Write-Ok($t)     { Write-Host "✓ $t" -ForegroundColor Green }
function Write-Warn($t)   { Write-Host "! $t" -ForegroundColor Yellow }
function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Ask($p)    { $r = Read-Host "$p [Y/n]"; if ([string]::IsNullOrWhiteSpace($r)) { return $true }; return $r -match '^[Yy]' }

if (-not (Have claude)) {
    Write-Warn "Claude Code CLI is not installed. Run install.ps1 first, then re-run this."
    exit 1
}

Clear-Host
Write-Host @"
   ____
  |  _ \ ___  __ _  __ _ ___ _   _ ___
  | |_) / _ \/ _` |/ _` / __| | | / __|
  |  __/  __/ (_| | (_| \__ \ |_| \__ \
  |_|   \___|\__, |\__,_|___/\__,_|___/
             |___/
       Connect — bridge Pegasus to your design tools
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "I'll walk through each tool and ask if you use it. For each yes, I'll install"
Write-Host "the bridge (an MCP server) so Claude Code can talk to that tool."
Write-Host ""

# 1. Figma
Write-Header "1. Figma"
Write-Host "Lets Claude read Figma files and turn designs into code."
Write-Host "Requires the Figma desktop app (free from figma.com)."
if (Ask "Connect Figma?") {
    if (Have winget -and -not (Test-Path "$env:LOCALAPPDATA\Figma\Figma.exe")) {
        if (Ask "Install Figma desktop now via winget?") {
            try { winget install --id Figma.Figma -e --silent --accept-package-agreements --accept-source-agreements; Write-Ok "Figma installed." }
            catch { Write-Warn "Could not install. Get it from https://www.figma.com/downloads/" }
        }
    }
    try { claude mcp add --transport sse figma http://127.0.0.1:3845/sse; Write-Ok "Figma MCP added." }
    catch { Write-Warn "Add manually: claude mcp add --transport sse figma http://127.0.0.1:3845/sse" }
    Write-Host ""
    Write-Host "Final step (do this once in Figma):" -ForegroundColor White
    Write-Host "  1. Open Figma desktop and sign in."
    Write-Host "  2. Open any file. Click Figma logo → Preferences."
    Write-Host "  3. Toggle ON: 'Enable Dev Mode MCP Server'."
} else { Write-Warn "Skipped Figma." }

# 2. Playwright
Write-Header "2. Playwright (browser automation)"
Write-Host "Lets Claude open a browser, click around, take screenshots, scrape content."
if (Ask "Connect Playwright?") {
    try { claude mcp add playwright npx -- '@playwright/mcp@latest'; Write-Ok "Playwright MCP added." }
    catch { Write-Warn "Add manually: claude mcp add playwright npx -- @playwright/mcp@latest" }
    try { npx -y playwright install chromium | Out-Null; Write-Ok "Chromium installed." }
    catch { Write-Warn "Run 'npx playwright install' manually." }
} else { Write-Warn "Skipped Playwright." }

# 3. Webflow
Write-Header "3. Webflow"
Write-Host "Lets Claude read and edit your Webflow sites."
if (Ask "Do you use Webflow?") {
    try { claude mcp add --transport sse webflow https://mcp.webflow.com/sse; Write-Ok "Webflow MCP added." }
    catch { Write-Warn "Add manually: claude mcp add --transport sse webflow https://mcp.webflow.com/sse" }
    Write-Host "Next time you ask Claude to do something with Webflow, it'll print a login link."
} else { Write-Warn "Skipped Webflow." }

# 4. Framer
Write-Header "4. Framer"
Write-Host "Framer doesn't have an official MCP server yet."
if (Ask "Do you use Framer?") {
    Write-Host ""
    Write-Host "Workarounds:"
    Write-Host "  • Paste public Framer URLs into Claude — it can fetch them."
    Write-Host "  • Export your Framer site as code and let Claude work on the export."
    Write-Host "  • Use the Playwright MCP (above) to drive Framer's web editor."
}

# 5. Google
Write-Header "5. Google (Gmail, Drive, Calendar)"
Write-Host "Two paths:"
Write-Host "  A) Claude desktop app or claude.ai — easiest. One-click connectors."
Write-Host "  B) Claude Code in VS Code — community MCPs."
if (Ask "Connect Google?") {
    Write-Host ""
    Write-Host "For Claude desktop / claude.ai (recommended):" -ForegroundColor White
    Write-Host "  1. Open https://claude.ai/settings/connectors"
    Write-Host "  2. Click 'Connect' next to Google Drive, Gmail, or Calendar."
    Write-Host "  3. Sign in and grant access."
    Write-Host ""
    Write-Host "For Claude Code (advanced):"
    Write-Host "  claude mcp add gdrive npx -- '@modelcontextprotocol/server-gdrive'"
    Write-Host "  claude mcp add gmail npx -- '@gongrzhe/server-gmail-autoauth-mcp'"
    if (Ask "Open the claude.ai connectors page now?") {
        Start-Process "https://claude.ai/settings/connectors"
    }
} else { Write-Warn "Skipped Google." }

# 6. Context7
Write-Header "6. Context7 (current library docs)"
Write-Host "Gives Claude live access to up-to-date docs. Strongly recommended."
if (Ask "Add Context7?") {
    try { claude mcp add --transport http context7 https://mcp.context7.com/mcp; Write-Ok "Context7 MCP added." }
    catch { Write-Warn "Add manually: claude mcp add --transport http context7 https://mcp.context7.com/mcp" }
} else { Write-Warn "Skipped Context7." }

# 7. GitHub
Write-Header "7. GitHub"
Write-Host "Lets Claude create repos, open PRs, manage issues."
if (Ask "Connect GitHub?") {
    try { claude mcp add github npx -- '@modelcontextprotocol/server-github'; Write-Ok "GitHub MCP added." }
    catch { Write-Warn "Add manually: claude mcp add github npx -- @modelcontextprotocol/server-github" }
    Write-Host "Set up auth: create a fine-grained PAT at https://github.com/settings/tokens?type=beta"
    Write-Host "Then: setx GITHUB_PERSONAL_ACCESS_TOKEN <your_token>"
} else { Write-Warn "Skipped GitHub." }

# 8. Notion
Write-Header "8. Notion (optional)"
Write-Host "Pull case study content from Notion into slides/sites."
if (Ask "Do you use Notion?") {
    try { claude mcp add --transport http notion https://mcp.notion.com/mcp; Write-Ok "Notion MCP added." }
    catch { Write-Warn "Add manually: claude mcp add --transport http notion https://mcp.notion.com/mcp" }
    Write-Host "First time you use it, Claude will print an OAuth link."
} else { Write-Warn "Skipped Notion." }

# 9. Other
Write-Header "9. Other tools"
Write-Host "Pegasus can connect to lots more — Notion, Slack, Airtable, GitHub..."
Write-Host "Full list: https://docs.claude.com/en/docs/claude-code/mcp"
Write-Host "Pattern: claude mcp add <name> <command...>"

Write-Header "Done"
Write-Host "Your installed MCP servers:"
try { claude mcp list } catch { Write-Warn "Run 'claude mcp list' to see them." }
Write-Host ""
Write-Ok "You're connected."
Write-Host "Open VS Code, start Claude (`claude`), and try a Figma URL or Webflow request."
