# Changelog

All notable changes to Pegasus.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) · [Semantic Versioning](https://semver.org/).

## [0.4.0] — 2026-05-03

### Added — Tracks, profile, workflows, dashboard
- **Two-track dashboard** (🎨 UX Design / 💼 Job Search / ⊕ Both) with persistent track choice
- **Profile system** (`pegasus profile`, dashboard form, JSON export/import, sample "Jane Designer" demo)
- **Pegasus Pulse widget** — usage stats (copies, weekly, skills tried, day streak) + recently-used pills
- **Workflows section + 10 cross-pollinating recipes** (W1–W10) chaining skills end-to-end
- **`pegasus init` wizard** — interactive 2-min first-run setup
- **`pegasus test` + `pegasus bug`** — end-to-end install verification + diagnostics-prefilled bug report
- **Cmd-K palette** with fuzzy search across templates/workflows/commands/skills/MCPs/prompts
- **PWA installable** dashboard with offline service worker + manifest + favicon
- **Pegasus favicon** — winged horse silhouette SVG

### Added — Skills (16 total, all auto-loaded by Claude Code AND OpenCode)
- Built-in: ux-ui-audit, job-finder, vector-workflow, interview-prep, content-writer
- Vendored from MIT-licensed upstreams (with attribution in CREDITS.md):
  - portfolio-case-study (SonwaneyY)
  - resume-tailor, cover-letter-generator, portfolio-case-study-writer, interview-prep-generator, salary-negotiation-prep (Paramchoudhary)
  - career-ops-{evaluate, outreach, research, tailor-resume, triage} (andrew-shwetzer)

### Added — Templates (9 total)
- portfolio, case-study-deck, scroll-case-study, landing-page, resume, link-in-bio, illustration-gallery, mood-board, components-lab
- All ship with `.gitignore`, `CLAUDE.md`, ready to `pegasus deploy`

### Added — MCPs (default-on)
- ux-knowledge ⭐ (elsahafy/ux-mcp-server) — DEFAULT
- Figma ⭐ — DEFAULT
- Playwright, Context7
- Plus opt-in: Webflow, Notion, GitHub, Linear, Stripe, Cloudflare
- OpenCode parity: same MCPs configured at `~/.config/opencode/opencode.json`
- Project-scoped `.mcp.json` at repo root for ux-knowledge + Figma

### Added — Helper subcommands (~20)
- `new`, `deploy` (Surge or GH Pages), `dashboard`, `tour`, `jobs`, `signin`, `clone`, `join`, `doctor`, `update`, `self-update`, `uninstall`, `version`, `link`, `icons`, `colors`, `search`, `open`, `model`, `profile`, `init`, `test`, `bug`

### Changed
- **Default deploy** swapped from Vercel (paid tier risk) to **Surge.sh** (truly free, no card) with GitHub Pages as alternative
- **Installer** is one-shot by default (no per-step Y/n); pass `--custom` for the question flow
- **Auto-launches** browser welcome page + VS Code on completion
- README rewrite with badges + two-track explainer

### Documentation
- COMMANDS.md, PROMPTS.md, POSSIBILITIES.md, GLOSSARY.md, RECOMMENDED.md, TROUBLESHOOTING.md
- CONTRIBUTING.md, CODE_OF_CONDUCT.md, CREDITS.md, .github/ templates

### Privacy
- No telemetry, no analytics, no remote logging
- All Pulse stats stored in localStorage only — never leave the device

## [0.1.0] — initial release
- Bootstrap installer + 7 designer-friendly VS Code extensions
- Single starter portfolio template
- Initial CLAUDE.md template
