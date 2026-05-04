# Tokens, CLIs, and Auth — designer's edition

> A plain-language explainer for everything you'll be asked to "log in to," "paste a token from," or "authenticate with" while using Pegasus. No prior dev experience assumed.

## The three things that get tangled

When someone says "you need to authenticate" they usually mean one of three things — and which one decides what you actually do.

| Thing | What it is | What it looks like |
|---|---|---|
| **Password login** | Username + password in a browser, like signing into Instagram | A web page asks for email + password |
| **OAuth / "Connect this account"** | You click a button, get bounced to the service, click "Allow," and it sets up a trust link | "Sign in with GitHub" / "Allow Pegasus to access your Webflow" |
| **API token / API key** | A long string of letters + numbers that proves *you specifically* are the one calling | `gho_abcdef1234567890` or `sk_live_abc...` |

You'll see all three in Pegasus. Most things use OAuth (one click). A few use tokens (you copy + paste a string). None use raw passwords.

---

## What's a CLI?

**CLI = Command Line Interface.** A program you run by typing its name in the terminal instead of clicking an icon. Examples Pegasus installs:

- `claude` — Claude Code
- `opencode` — OpenCode
- `gh` — GitHub
- `surge` — free static hosting
- `pegasus` — Pegasus itself
- `vercel`, `wrangler`, `npm`, `git` — all CLIs

When you see something like `gh auth login` in our docs, that means: "open a terminal, type `gh auth login`, hit Enter." The terminal in VS Code (View → Terminal, or `Ctrl-\``) is the easiest place.

**Why CLIs?** They're scriptable, automatable, and don't require a slow GUI. Once you're comfortable with 5–10 commands, you'll move way faster than clicking through web dashboards.

---

## The three sign-ins you'll actually do

### 1. GitHub (OAuth, easy)

```bash
gh auth login
```

Pick "GitHub.com" → "HTTPS" → "Login with a web browser" → press Enter → paste the one-time code → authorize. Done. No tokens to store; `gh` remembers it.

You'll need this for: pushing your portfolio repo, opening PRs, using GitHub Pages.

### 2. Surge (email-only, easiest)

```bash
surge
```

Surge prompts for an email + password the first time. Pick whatever — there's no card, no plan, no upsell. It just works. After that, every `surge` or `pegasus deploy` is one command.

### 3. Figma desktop + Dev Mode MCP (one-time toggle, no token)

1. Open Figma desktop (the app, not the website).
2. Click the **Figma logo** (top-left) → **Preferences** → toggle ON **"Enable Dev Mode MCP Server"**.
3. Done. Claude/OpenCode can now read whatever file you have open in Figma.

No tokens. No login flow. Just a toggle.

---

## The three tokens you might need

### GitHub Personal Access Token (only for the GitHub MCP)

If you want Claude to *create* repos, *open* PRs, or *manage* issues — not just push code — you need a token.

1. Go to <https://github.com/settings/tokens?type=beta>
2. Click "Generate new token" → "Fine-grained personal access token"
3. Name it "Pegasus" or similar
4. Pick which repos it can touch (start narrow — just the repos you'll work in)
5. Permissions: Contents (read+write), Issues (read+write), Pull requests (read+write)
6. Click Generate. **You'll see the token ONCE.** Copy it immediately.
7. Add to your shell:

```bash
echo 'export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_paste_your_token_here' >> ~/.zshrc
source ~/.zshrc
```

**What's `~/.zshrc`?** A file your terminal reads every time you open it. `export FOO=bar` makes `FOO` available to any command. It's how you "remember" tokens permanently without re-typing.

### Anthropic API key (only if you go beyond Claude Code)

If you ever build a custom Claude-powered app outside Claude Code, you'll get an API key from <https://console.anthropic.com>. Same pattern: paste into `~/.zshrc`. Pegasus's Claude Code uses the Claude desktop login flow, not API keys, so most designers never touch this.

### Stripe API key (only if you sell things)

Same drill: from <https://dashboard.stripe.com/apikeys>, copy the secret key, add to `~/.zshrc`. Use the **test mode** key for development.

---

## How to spot the difference between a token and a password

- **Password**: 8–20 chars, you choose it, you might remember it.
- **Token**: 30+ chars of random letters/numbers, machine-generated, you'd never remember it. Examples:
  - `ghp_AbCdEfG1234567890aBcDeFgHiJ` (GitHub)
  - `sk_live_51HxYz...` (Stripe)
  - `sk-ant-api03-abc...` (Anthropic)

A token is a **password for one specific thing**. If it leaks, only that thing is at risk. If your account password leaks, everything is at risk.

---

## Token safety rules

1. **Never commit a token to a public repo.** GitHub auto-scans and revokes any token that gets pushed publicly. Embarrassing and annoying.
2. **Use `~/.zshrc` (or `~/.bashrc`)** for tokens you'll use across projects. They live in your home folder, not in git.
3. **Use `.env` files** for tokens specific to one project. Always add `.env` to `.gitignore` (Pegasus's templates already do).
4. **If a token leaks**: revoke it immediately on the service's site, then generate a new one.

---

## What's the difference between OAuth and an API token?

| | OAuth | API token |
|---|---|---|
| **Who's the user?** | You as a human | Code on your behalf |
| **How long does it last?** | Until you revoke or it expires (usually weeks/months) | Until you revoke (or expires per-token) |
| **What can it do?** | Whatever scopes you approved | Whatever scopes you set when generating |
| **How do you give it to a tool?** | Click "Connect" in the tool | Paste the string into a config file or env var |
| **Most common in Pegasus?** | Yes (Webflow, Notion, Linear, Stripe) | Used for GitHub MCP only |

---

## What's a "scope"?

When you grant access (OAuth or token), you pick what the tool can do. Common scopes:

- **read:repo** — can see your repos but not change them
- **write:repo** — can push code, create branches
- **read:user** — can see your name/email
- **issues:write** — can open + close issues

**Always pick the narrowest scopes possible.** If a tool only needs to read your repo, don't give it write access. If you're not sure, start with read-only and expand later if needed.

---

## What does `pegasus signin` actually do?

It runs:

1. `gh auth login` — opens browser to GitHub OAuth
2. Reminds you to enable Figma Dev Mode MCP
3. Opens claude.ai/connectors for Google (Gmail/Drive/Calendar)
4. Optionally installs Adobe Creative Cloud
5. Opens Webflow login page

That's it. No tokens to copy. The advanced token-based things (GitHub MCP, Stripe MCP) are opt-in later.

---

## When you're stuck

- "It says I need a token but the docs are confusing" — paste the docs into Claude and ask "explain this like I'm new to dev." Claude will translate.
- "I think I leaked a token" — revoke immediately on the service site, then `pegasus doctor` to verify nothing references it.
- "I don't know what env var name to use" — `pegasus doctor` shows the standard names; the service's docs tell you for sure.

---

## TL;DR — the 80/20

For most designers, this is the entire token reality:

1. **Sign into GitHub once** with `gh auth login` (browser-based, no tokens to handle).
2. **Sign into Surge once** with `surge` (email + password, free forever).
3. **Toggle Figma Dev Mode** in Figma desktop.
4. **Connect Google to claude.ai** if you want Gmail/Drive/Calendar access.

Everything else is optional. You can ship a portfolio + use Claude productively without ever touching an API token.
