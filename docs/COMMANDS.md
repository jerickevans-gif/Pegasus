# Commands cheatsheet

Everything you need at the terminal. Skim it once, then come back when you forget something.

---

## Claude Code (CLI)

Run from inside any project folder. Claude reads the folder and any `CLAUDE.md` you've added.

| Command | What it does |
|---|---|
| `claude` | Start an interactive Claude session in the current folder |
| `claude "build me a one-page portfolio"` | One-shot: give Claude a task and let it run |
| `claude /init` | Have Claude write a `CLAUDE.md` for the current project |
| `claude /clear` | Clear the conversation but keep the project context |
| `claude /resume` | Resume your last conversation |
| `claude /memory` | View or edit Claude's saved memory about you |
| `claude /agents` | Manage subagents (specialized helpers) |
| `claude /mcp` | Manage MCP servers (Figma, Context7, etc.) |
| `claude /help` | Full list of slash commands |
| `claude --model opus` | Force a specific model |
| `claude /config` | Open settings |
| `Esc` (twice) | Stop Claude mid-task |
| `Ctrl+C` | Quit |

### Inside a Claude session

| You type | What happens |
|---|---|
| `@filename` | Attach a specific file to your message |
| `/init` | Generate a CLAUDE.md for this project |
| `/compact` | Summarize the conversation to free up context |
| `!ls` | Run a shell command without leaving Claude |
| Drag image into terminal | Attach an image (works on macOS Terminal/iTerm) |

---

## OpenCode (CLI)

Same idea — run from a project folder.

| Command | What it does |
|---|---|
| `opencode` | Start the OpenCode TUI in the current folder |
| `opencode run "task here"` | One-shot run |
| `opencode auth` | Configure your model provider (Anthropic, OpenAI, etc.) |
| `opencode models` | List available models |
| `opencode --help` | Show all flags |

### Inside an OpenCode session

| You type | What happens |
|---|---|
| `Tab` | Switch focus between editor pane and chat |
| `/help` | Show shortcuts |
| `/new` | Start a fresh conversation |
| `/quit` | Exit |

---

## Project housekeeping

```bash
cd ~/Design-Projects                 # Go to your design folder
mkdir my-portfolio && cd my-portfolio  # Make + enter a new project
code .                               # Open this folder in VS Code
claude                               # Start Claude here
git init && git add . && git commit -m "first"   # Save a snapshot
```

### Previewing your work

```bash
npx serve .                  # Quick static preview at http://localhost:3000
python3 -m http.server 8000  # Built into macOS
```

Or right-click an HTML file in VS Code → **"Show Preview"** (Live Preview extension).

---

## Publishing your portfolio

```bash
# 1) Push your project to GitHub
gh repo create my-portfolio --public --source=. --push

# 2) Easiest free hosting (no config):
npx surge .       # surge.sh — free static hosting, no card needed
npx netlify-cli deploy --prod   # netlify.com alternative
```

---

## VS Code commands you'll use a lot

Open the command palette with `⌘⇧P` (macOS) or `Ctrl+Shift+P` (Windows).

| Command | What it does |
|---|---|
| `Live Preview: Start Server` | Live-reload preview for HTML |
| `Claude Code: Open` | Open the Claude side panel |
| `OpenCode: Open` | Open the OpenCode side panel |
| `Mermaid Chart: Preview Diagram` | Preview a Mermaid diagram |
| `Format Document` | Auto-format with Prettier |
| `Git: Clone` | Pull down a repo |
| `Toggle Terminal` (Ctrl+`) | Show/hide the integrated terminal |

---

See also: [PROMPTS.md](PROMPTS.md) for things to actually say to Claude/OpenCode, and [POSSIBILITIES.md](POSSIBILITIES.md) for ideas of what to build.
