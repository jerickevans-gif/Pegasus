# Changelog

All notable changes to Pegasus.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) · [Semantic Versioning](https://semver.org/).

## [1.1.0] — 2026-05-04

### Added
- **Dark mode toggle** — system → light → dark cycle in the persistent mode-pill (top-right). Inline init script sets `.dark` class before first paint (no flash). Auto-updates when system pref changes while in "system" mode.
- **`pegasus profile validate [file]`** — JSON Schema validation. Auto-runs on `profile import`. `profile.schema.json` defines all 12 known fields with formats (email, uri).
- **`pegasus voice check`** — read-only status of brew, whisper-cli, uv, kokoro-onnx, python3, model cache. Tells you what's missing without doing installs.
- **`pegasus test --all`** — runs the full dev suite (6 test files, 225 checks, ~50s).
- **`scripts/test-all.sh`** orchestrator for contributors.
- **`scripts/install-hooks.sh`** — installs a git pre-commit hook that runs the two fast suites when relevant files are staged.
- **`scripts/e2e-jobfinder.js`** — 16-check pipeline test (profile → click → mock Claude markdown → parse → render → persist).
- **`scripts/visual-regression.js`** — opt-in Playwright screenshot diff at 3 viewports (375 / 768 / 1280px). Skipped gracefully if deps missing.
- **GitHub Actions CI** — runs the 4 fast suites on macOS + Ubuntu on every push/PR.

### Changed
- Workflow recipes now have a **"Copy all prompts"** button on every card AND in the modal. Joined format: `Step N:\n<prompt>\n\n---\n\n…`
- Disabled "Find me jobs" button now shows `0/4 ready` inline; flips to `Ready ✓` when complete.
- Onboarding bar exposes a `↺ Show setup checklist` link after dismissal so it can come back.
- Click on "Find me jobs" → smooth-scrolls to Job Results section + pulses the empty drop zone with an emerald ring.
- Mobile sticky-nav has a CSS mask gradient so users see overflowing pills.
- Search input has an explicit × clear button next to the `/` shortcut.
- Drop overlay copy mentions both `jobs-today-*.md` AND `pegasus-snapshot.json` (handler accepted both, copy was misleading).
- `og-image.png` (1200×630, 501KB) replaces SVG OG meta. Generated via `qlmanage` to bypass ImageMagick font crash.
- Service worker cache `pegasus-v8-2026-05-04`.

### Fixed
- v1.0.7 hotfix: `'Couldn\\'t find...'` bad escape sequence killed all JS after parser. Switched to double-quotes.
- Vestigial `THEME_KEY` block referenced a non-existent `themeSwitcher` element. Removed; new theme toggle supersedes it.
- `pegasus test` arg dispatch was missing `shift`; flags were swallowed before reaching `cmd_test`.
- Wrapped `scrollIntoView` in try/catch so JSDOM tests don't throw on a method JSDOM doesn't implement.

### Docs
- `docs/demo-shotlist.md` — frame-by-frame 60s storyboard for a README demo video. (Headless agent can't drive a screen recorder; this enables a human collaborator to shoot it in one sitting.)

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
