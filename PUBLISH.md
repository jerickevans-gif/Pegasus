# How to publish this repo to GitHub

You created the repo locally. Here's how to push it to your `jerickevans-gif` GitHub account so other designers can install it.

## Option A — using the GitHub website (easiest)

1. Go to <https://github.com/new> while signed in as `jerickevans-gif`.
2. **Repository name:** `Pegasus` (or whatever name you prefer — just remember to update the `curl` URLs in `README.md`, `install.sh`, and `install.ps1` to match).
3. **Visibility:** Public.
4. **Do NOT** add a README, .gitignore, or license — we already have them.
5. Click **Create repository**.
6. On the next page GitHub shows commands. Use the "push an existing repository" block. From the project folder in Terminal:

```bash
cd ~/Downloads/Pegasus
git init
git add .
git commit -m "Initial setup"
git branch -M main
git remote add origin https://github.com/jerickevans-gif/Pegasus.git
git push -u origin main
```

## Option B — using the `gh` CLI (one command)

If you have the [GitHub CLI](https://cli.github.com/) installed and signed in:

```bash
cd ~/Downloads/Pegasus
git init && git add . && git commit -m "Initial setup"
gh repo create jerickevans-gif/Pegasus --public --source=. --push
```

## After publishing

1. Visit `https://github.com/jerickevans-gif/Pegasus` to confirm everything's there.
2. Test the one-line install on a fresh machine (or just yourself) by pasting the curl/iwr command from the README.
3. If you renamed the repo, update the URLs inside:
   - `README.md` (curl/irm one-liners)
   - `install.sh` (the `CLAUDE_MD_URL` line near the bottom)
   - `install.ps1` (the `$claudeMdUrl` line near the bottom)

## Telling other designers to use it

Send them the README's "Quick start" section. The one-line curl on macOS or `irm` on Windows is all they need.
