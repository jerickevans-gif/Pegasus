# Pegasus

A one-command setup that turns your laptop into a coding-ready studio for designers. Run one line in your terminal and walk away — when it's done, you'll have VS Code, Claude Code, OpenCode, the right extensions, the right CLI tools, and a `Design-Projects` folder ready to go.

Built for designers who want to use AI coding tools to bring their work to life — portfolio sites, interactive case studies, presentation decks, prototype demos — without spending a weekend on machine setup.

## Quick start

### macOS

Open the **Terminal** app (Spotlight → "Terminal") and paste:

```bash
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash
```

### Windows

Open **PowerShell** as Administrator (right-click Start → "Terminal (Admin)") and paste:

```powershell
irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.ps1 | iex
```

The installer will:

1. Ask before installing anything
2. Install missing tools (skip whatever you already have)
3. Install Visual Studio Code with the recommended extensions
4. Install Claude Code, OpenCode, and useful CLIs (Vercel, ffmpeg, ImageMagick)
5. Apply Pegasus's recommended Claude Code base settings
6. Create `~/Design-Projects/` and drop the cheatsheet docs inside
7. Offer to walk you through connecting your design tools (Figma, Webflow, etc.)

When it's done, open your new folder in VS Code and run `claude` in the terminal — you're ready to design with code.

## What gets installed

**CLIs and apps:**
- **[Visual Studio Code](https://code.visualstudio.com/)** — your code editor
- **[Claude Code](https://claude.com/claude-code)** — Anthropic's CLI agent
- **[OpenCode](https://opencode.ai/)** — open-source AI coding agent
- **Node.js**, **Git**, and **Homebrew/winget** as foundations
- **[Vercel CLI](https://vercel.com/cli)** — deploy a portfolio in one command
- **ffmpeg + ImageMagick** — video and image processing for case studies

**VS Code extensions:**
- Claude Code for VS Code
- OpenCode for VS Code
- Mermaid Chart
- GitHub Actions
- Live Preview (Microsoft)
- Python
- CodeSnap (beautiful code screenshots)
- Plus designer extras: Tailwind CSS, Color Highlight, Image Preview, Prettier, Material Icon Theme, Figma for VS Code, Auto Rename Tag, HTML/CSS support

**A `~/Design-Projects/` folder with:**
- A starter [`CLAUDE.md`](config/CLAUDE.md) so Claude knows you're a designer
- A copy of the cheatsheets below

**A bundled skill** (works in both Claude Code and OpenCode):
- [`ux-ui-audit`](skills/ux-ui-audit/) — comprehensive 17-section audit covering accessibility, responsive breakpoints, performance, content design, and more. Just say "do a UX audit on this" and the agent picks it up automatically.

## The other Pegasus commands

After the main install, two more one-liners give you extras:

### Connect your design tools

Walks you through enabling Figma, Playwright, Webflow, Notion, GitHub, Context7, and Google connectors via MCP servers.

```bash
# macOS
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.sh | bash

# Windows
irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.ps1 | iex
```

### Install the standalone desktop / terminal apps

Adds the Claude desktop app (chat) plus the Claude Code and OpenCode CLIs for use in any terminal — outside VS Code.

```bash
# macOS
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/desktop-apps.sh | bash

# Windows
irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/desktop-apps.ps1 | iex
```

## Cheatsheets (in your Design-Projects folder after install)

- **[COMMANDS.md](docs/COMMANDS.md)** — every Claude Code, OpenCode, and VS Code command worth knowing
- **[PROMPTS.md](docs/PROMPTS.md)** — copy-paste prompts for portfolios, case studies, and presentations
- **[POSSIBILITIES.md](docs/POSSIBILITIES.md)** — directory of what's possible, organized by use case

## Power user: faster Claude Code

By default, Claude Code asks "Allow this?" before each action. If you're an experienced user and want to skip those prompts, see [Claude Code's permissions documentation](https://docs.claude.com/en/docs/claude-code/iam) for how to edit `~/.claude/settings.json` to set `permissions.defaultMode` to `bypassPermissions`. **Only do this once you understand what Claude can do** — it can delete files, run shell commands, and read anything on your machine without asking.

## After install: first project

```bash
cd ~/Design-Projects
mkdir my-first-project && cd my-first-project
claude
```

Tell Claude what you want to build. Examples (more in [PROMPTS.md](docs/PROMPTS.md)):

- "Make a one-page portfolio site with my work organized into 3 sections"
- "Convert this Figma file into a working HTML/CSS prototype: <paste Figma URL>"
- "Build me a slide deck for a design case study using reveal.js"

## License

MIT — fork it, remix it, share it. See [LICENSE](LICENSE).
