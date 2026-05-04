# Glossary — what these words actually mean

Code people use a lot of jargon. Here's plain-language translations of the words you'll bump into using Pegasus.

## The basics

**Terminal / Shell** — the black-and-white text window where you type commands. On macOS it's called "Terminal" or "iTerm". On Windows it's "PowerShell" or "Windows Terminal". Inside VS Code there's a built-in one (View → Terminal, or `Ctrl-\``).

**Command** — a line of text you type and press Enter. The terminal runs it and shows the result. Examples: `ls` (list files), `cd folder` (change directory), `git status`.

**Directory / Folder** — same thing. Devs say "directory", normal people say "folder".

**`cd`** — "change directory". `cd ~/Design-Projects` puts you inside that folder.

**`ls`** — "list" what's inside the current folder.

**`~`** — shorthand for your home folder. `~/Design-Projects` is the same as `/Users/yourname/Design-Projects` on Mac.

**Path** — the address of a file. Like `~/Design-Projects/my-site/index.html`.

## Project tools

**Repo / Repository** — a project folder that's tracked by Git (so you can see history and undo changes).

**Git** — the system that remembers every change you make. Like infinite undo with notes.

**Commit** — a saved snapshot of your project at a moment in time. Each commit has a message like "added contact form".

**GitHub** — the website where you put a repo so you can share it or back it up. Pegasus is itself on GitHub.

**Branch** — a parallel timeline of changes. You almost never need this for a portfolio.

**Push / Pull** — push = upload your commits to GitHub. Pull = download what's on GitHub down to your machine.

## Web stuff

**HTML** — the structure of a webpage (headings, paragraphs, images).

**CSS** — the styling (colors, fonts, spacing, layout).

**JavaScript / JS** — the logic (clicks, animations, interactivity).

**Tailwind CSS** — a way of writing CSS where you put utility classes directly in your HTML (`class="text-2xl font-bold"`). All Pegasus templates use it because it's fast to iterate.

**CDN** — "Content Delivery Network". A trick where you load a library (like Tailwind) from someone else's server with a `<script>` tag, instead of installing it. Pegasus templates use CDNs so there's no setup.

**Build step** — when your code has to be processed before browsers can read it (e.g. React, TypeScript). Pegasus templates skip this — your `index.html` works directly.

**Local server** — a tiny web server running on your laptop so you can preview pages at `http://localhost:3000`. `npx serve .` starts one.

**Deploy** — make your site available on the public internet. `pegasus deploy` does this with Vercel.

## AI agent stuff

**Claude Code** — Anthropic's terminal coding agent. Type `claude` in any folder, then describe what you want.

**OpenCode** — open-source equivalent of Claude Code. Type `opencode`. Same idea, different model providers.

**MCP (Model Context Protocol)** — the plug system that lets agents like Claude talk to tools like Figma, Webflow, GitHub. `pegasus connect` (i.e. `connect.sh`) sets these up.

**Skill** — a structured "instruction sheet" for an agent. Pegasus ships the `ux-ui-audit` skill — when you say "do a UX audit on this," the agent loads it automatically.

**Slash command** — inside a Claude session, a command that starts with `/` (e.g. `/clear`, `/init`).

**Prompt** — what you type to the agent. Good prompts state the goal, not the implementation.

## VS Code stuff

**Extension** — a plugin for VS Code. Pegasus auto-installs ~14 of them (Tailwind, Live Preview, CodeSnap, etc.).

**Command Palette** — `⌘⇧P` (Mac) / `Ctrl+Shift+P` (Windows). The "I want to do X but don't know how" menu.

**Live Preview / Live Server** — extensions that auto-reload your page in the browser whenever you save.

## When you don't know a word

Two good moves:

1. Type it into Claude: "Explain what `git rebase` does, like I'm new to coding."
2. Look it up at [MDN](https://developer.mozilla.org) (web stuff) or [Git docs](https://git-scm.com/doc).

Also: it's totally fine to ignore a word until it actually matters. Most code work involves maybe 30 of these terms. The rest are noise.
