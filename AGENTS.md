# AGENTS.md

OpenCode reads `AGENTS.md` the way Claude Code reads `CLAUDE.md`. Both files describe how an AI agent should behave inside this project. This one mirrors `config/CLAUDE.md` so designers using either agent get the same context.

## About the user

I'm a designer using Pegasus. I think visually first, code second. When you help me:

- Explain in plain language. Skip jargon, or define it inline.
- Show me before you build big — sketch the structure or a small preview before going deep.
- Prefer small, runnable steps over big monolithic implementations.
- Never silently install or delete things. Tell me what you're about to add and wait for a yes.

## Default stack

When I don't specify, default to:

- HTML + CSS (Tailwind) + vanilla JavaScript for prototypes and landing pages
- Vite for richer dev environments
- Live Preview (VS Code extension) for static HTML previews
- React + Vite + Tailwind for fuller apps

If a project has a `package.json`, follow its conventions instead.

## Workflow preferences

- Keep new files inside the current project folder
- For each project, the home is `~/Design-Projects/<project-name>/`
- When I share a Figma URL, use the Figma MCP tools (if configured) to read the design
- After finishing a step, show me how to preview it in the browser before moving on

## Skills available

Pegasus installs three skills (both agents read them):
- `ux-ui-audit` — comprehensive 17-section UX audit
- `job-finder` — pulls + ranks jobs from BuiltIn and LinkedIn
- `vector-workflow` — Procreate / Adobe / SVG → web pipeline

Just describe what you need; the right skill activates.

## Tools available

- Standard local tools: bash, git, npm, code (VS Code)
- Figma MCP, Playwright MCP, Webflow MCP, Context7 MCP, GitHub MCP (when configured)
- Designer CLIs: `vercel`, `svgo`, `potrace`, `magick` (ImageMagick), `ffmpeg`, `lighthouse`, `pa11y`, `specify` (spec-kit)

## Pegasus helpers

The user has a `pegasus` command that wraps common flows:
- `pegasus new <type> <name>` — scaffold a project
- `pegasus deploy` — deploy to Vercel
- `pegasus dashboard` — open the visual launcher
- `pegasus signin` — open all sign-in pages

Reach for these when they fit instead of teaching the user the underlying commands.
