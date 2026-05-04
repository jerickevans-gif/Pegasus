# Pegasus

> A one-command setup that turns your laptop into an AI-powered design studio. Built for designers, not developers.

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Works with Claude Code](https://img.shields.io/badge/Claude_Code-✓-orange.svg)](https://claude.com/claude-code)
[![Works with OpenCode](https://img.shields.io/badge/OpenCode-✓-blue.svg)](https://opencode.ai)
[![No telemetry](https://img.shields.io/badge/telemetry-none-success.svg)](#privacy)
[![No paid services](https://img.shields.io/badge/paid_services-zero-success.svg)](#what-you-get)

Designers who want to use Claude Code or OpenCode to ship portfolios, case-study decks, interview presentations, and prototypes — without spending a weekend configuring a machine.

**Run one command. Walk away.** Come back to a configured laptop with a visual dashboard, working starter projects, 31 AI skills auto-loaded, 13 templates, 10 cross-pollinating workflow recipes, 16 MCP bridges, and a `pegasus` helper command that wraps every common workflow.

## Two tracks, one setup

🎨 **UX Design** — portfolio sites, case studies, mood boards, illustration galleries, slide decks, components labs.
💼 **Job Search** — resume tailoring, cover letters, interview prep, salary negotiation, BuiltIn + LinkedIn job pulls.
⊕ **Both** — cross-pollinating workflows that bridge the two.

Pick a track in the visual dashboard. Pegasus filters templates, skills, MCPs, and prompts to your current focus.

## Quick start

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.ps1 | iex
```

The installer is **one-shot** by default: no questions after "Ready?", everything installs in 3–5 minutes. Pass `--custom` if you want the question-by-question flow.

When it finishes, a visual dashboard auto-opens in your browser and VS Code launches with the cheatsheet.

## Then run

```bash
pegasus new portfolio my-site    # working portfolio + opens VS Code
cd ~/Design-Projects/my-site
claude                            # talk to the agent
pegasus deploy                    # ship to free hosting
```

That's the whole loop. Make → edit → preview → ship → repeat.

## What you get

### Apps and CLIs
- **VS Code** with 15 designer-friendly extensions (Tailwind, Live Preview, Color Highlight, Image Preview, Mermaid, GitHub Actions, CodeSnap, Python, Figma, Material Icons, more)
- **Claude Code** + **OpenCode** — both AI coding agents, your choice
- **Surge CLI** — one-command deploys
- **Bun, Node, npm, Git, Homebrew/winget** — the foundations
- **ffmpeg, ImageMagick, SVGO, potrace** — image and vector toolchain
- **Lighthouse, Pa11y, Wrangler** — performance, accessibility, Cloudflare

### Templates — 13 (`pegasus new <type> <name>`)
- **portfolio** — single-page with hero, project grid, about, contact
- **case-study-deck** — reveal.js slide deck for interviews
- **scroll-case-study** — long-form scrollable case study
- **landing-page** — coming-soon page with email capture
- **resume** — printable single-page CV
- **link-in-bio** — Linktree replacement on your domain
- **illustration-gallery** — masonry grid for paintings, vector art
- **mood-board, components-lab, agency-page, error-page, podcast-page, newsletter-archive** — see the dashboard for the rest

### Skills — 31 (auto-loaded by Claude and OpenCode)
- **Design:** ux-ui-audit (17-section audit), vector-workflow (Procreate → web), portfolio-case-study, content-writer
- **Job search:** job-finder (BuiltIn + LinkedIn ranked), resume-tailor, cover-letter-generator, interview-prep, salary-negotiation-prep, career-ops-* (research, outreach, evaluate, triage, tailor-resume)
- Plus 16 more — see the **Skills** section in the dashboard for the full list with descriptions.

### Visual dashboard
- **Two-track filter** (🎨 UX Design / 💼 Job Search / ⊕ Both) for templates, skills, MCPs, prompts.
- **Workflow recipes** with a "📋 Copy all prompts" button on every card.
- **Profile system** that skills reference for personalized output. JSON-Schema-validated.
- **Job Results** local database — paste/drop the markdown table Claude returns, see ranked cards.
- **Dark mode toggle** (system / light / dark).
- **Pulse widget**, Cmd-K palette, keyboard shortcuts.
- **PWA installable** with offline service worker.

### Bridges (MCP servers — `connect.sh` installs them)
- **Figma** (read designs into Claude)
- **Playwright** (browser automation)
- **Webflow, Notion, Linear, Stripe, Cloudflare**
- **GitHub, Context7** (live docs)
- **Adobe / Procreate / Framer** — workflow guides (no MCPs exist for these yet)
- **Google** (Gmail/Drive/Calendar via claude.ai connectors)

### A `~/Design-Projects/` folder containing
- A starter `CLAUDE.md` so Claude knows it's working with a designer
- **COMMANDS.md** — every command worth knowing
- **PROMPTS.md** — copy-paste prompts grouped by use case
- **POSSIBILITIES.md** — directory of what's possible
- **GLOSSARY.md** — every dev word in plain English
- **RECOMMENDED.md** — curated MIT-licensed external repos
- **TROUBLESHOOTING.md** — five most common issues + fixes

## The pegasus command

After install, you have one helper that wraps the most common flows:

| Command | What it does |
|---|---|
| `pegasus new <type> <name>` | Create a project from a template, git init, open VS Code |
| `pegasus deploy` | Deploy current folder (Surge or GitHub Pages) |
| `pegasus dashboard` | Open the visual dashboard in your browser |
| `pegasus tour` | 5-minute guided walkthrough |
| `pegasus jobs` | Run the job-finder skill |
| `pegasus signin` | Open all the sign-in pages (GitHub, Surge, Figma, Adobe, Webflow, Google) |
| `pegasus clone <url> <name>` | Clone any GitHub repo as a starter project |
| `pegasus doctor` | Diagnose what's installed / missing |
| `pegasus update` | Refresh templates + skills from GitHub |
| `pegasus help` | Full command list |

## The companion commands

After the main install, two more one-liners give you extras:

```bash
# Connect every design tool (Figma, Playwright, Webflow, Notion, GitHub, Linear, Stripe, etc.)
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/connect.sh | bash

# Install standalone desktop apps (Claude desktop, CLIs for use outside VS Code)
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/desktop-apps.sh | bash
```

## Works with both agents

Whether a designer uses **Claude Code in VS Code** or **OpenCode in VS Code**, Pegasus works for both. Skills install to `~/.claude/skills/` which both agents read.

## Power user: faster Claude Code

By default Claude asks before each action. To skip those prompts (advanced — read the trade-offs), see [Claude Code's permissions docs](https://docs.claude.com/en/docs/claude-code/iam) for the `bypassPermissions` setting.

## Privacy

Pegasus has no telemetry, no analytics, no remote logging. Everything runs on your machine and only fetches from GitHub when you explicitly run `pegasus update`.

## License

MIT. Fork it, remix it, share it.
