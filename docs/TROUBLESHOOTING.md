# Troubleshooting

The five most common issues, and what to do about each.

## "command not found: pegasus"

The `pegasus` helper isn't on your PATH yet. Two fixes:

**On macOS:**
```bash
ls -la /usr/local/bin/pegasus  # is the file there?
ls -la ~/.local/bin/pegasus    # or here?
```

If it's in `~/.local/bin`, add this line to `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then run `source ~/.zshrc` (or open a new terminal).

**Quick re-install:**
```bash
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash
```

---

## "command not found: claude" (or `opencode`, `vercel`, `code`)

The agent or CLI didn't get installed. Run:

```bash
pegasus doctor
```

That tells you exactly what's missing. To fix specific things:

- **Claude Code:** `curl -fsSL https://claude.ai/install.sh | bash`
- **OpenCode:** `npm install -g opencode-ai`
- **Vercel:** `npm install -g vercel`
- **VS Code `code` command:** open VS Code → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"

---

## VS Code extensions didn't install

The installer needs the `code` CLI on your PATH. If it wasn't there at install time, the extension step silently fails.

After fixing the `code` command (above), re-run only the extensions step:

```bash
for ext in anthropic.claude-code sst-dev.opencode MermaidChart.vscode-mermaid-chart \
           GitHub.vscode-github-actions ms-vscode.live-server ms-python.python \
           esbenp.prettier-vscode bradlc.vscode-tailwindcss naumovs.color-highlight \
           kisstkondoros.vscode-gutter-preview formulahendry.auto-rename-tag \
           PKief.material-icon-theme figma.figma-vscode-extension ecmel.vscode-html-css \
           adpyke.codesnap; do
  code --install-extension "$ext"
done
```

---

## "claude can't see my Figma files"

You installed the Figma MCP but didn't enable Dev Mode in the Figma desktop app. Required steps:

1. Install Figma desktop (not the web version): <https://www.figma.com/downloads/>
2. Open Figma. Click the **Figma logo** (top-left) → **Preferences**.
3. Toggle ON **"Enable Dev Mode MCP Server"**.
4. Restart `claude` if it was already running.

Test it: open any Figma file, copy its URL, and tell Claude:
> "Read this Figma file and tell me what you see: [paste URL]"

---

## The install hangs at "Installing Homebrew"

Homebrew install can take 10+ minutes on a fresh machine. Don't kill it. If you must, the recovery is:

```bash
# resume Homebrew install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# then re-run Pegasus
curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash
```

---

## "I want to undo something Claude did"

If you used `pegasus new`, your project was git-initialized with a commit at the start. Roll back:

```bash
cd ~/Design-Projects/<project>
git status              # see what's changed
git checkout -- .       # discard ALL changes since last commit
# or, more carefully:
git diff                # see what changed
git checkout -- file.html  # undo just one file
```

If you committed something and want to back up:
```bash
git log --oneline       # see your commits
git reset --hard HEAD~1 # rewind one commit (DESTRUCTIVE — make sure)
```

---

## "Claude is being too cautious / asking too many questions"

That's the safe default. To make Claude move faster:

1. Read [Claude Code's permissions docs](https://docs.claude.com/en/docs/claude-code/iam) — there's a "bypassPermissions" mode.
2. Edit `~/.claude/settings.json` and add:
   ```json
   {
     "permissions": { "defaultMode": "bypassPermissions" }
   }
   ```
3. Restart Claude.

**Important:** this mode lets Claude run commands without asking. Only enable it if you understand what that means and trust your prompts.

---

## "OpenCode and Claude Code are showing different things"

They're different agents. Some differences are normal:
- They use different default models (configurable).
- Their slash commands differ (`/help` works in both, others don't).
- Their MCP server configs are read from different files.

Skills installed at `~/.claude/skills/` work in **both**. So `pegasus jobs` runs the same skill regardless of which agent you use.

---

## When to ask for help

If `pegasus doctor` shows everything green and you're still stuck:

1. Search [the Claude Code docs](https://docs.claude.com/en/docs/claude-code).
2. Open an issue at <https://github.com/jerickevans-gif/Pegasus/issues> with:
   - Your OS + version (`sw_vers` on Mac)
   - The exact command you ran
   - The exact error message (no screenshots — paste the text)
   - The output of `pegasus doctor`
