# Your Design-Projects folder

This is where your code work lives. Pegasus put a few things here for you on install:

## Cheatsheets (open any time)

- **[COMMANDS.md](COMMANDS.md)** — every command worth knowing
- **[PROMPTS.md](PROMPTS.md)** — copy-paste prompts grouped by use case
- **[POSSIBILITIES.md](POSSIBILITIES.md)** — directory of what's possible
- **[GLOSSARY.md](GLOSSARY.md)** — every dev word in plain English
- **[RECOMMENDED.md](RECOMMENDED.md)** — curated MIT-licensed external repos
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** — fixes for the most common issues
- **[CLAUDE.md](CLAUDE.md)** — context that Claude reads every time you start a session here

## How to make your first project

```bash
pegasus new portfolio my-site    # creates ~/Design-Projects/my-site + opens VS Code
cd my-site
claude                            # talk to the agent
```

See `COMMANDS.md` for the full list.

## How this folder is organized

After you've used Pegasus for a while, this folder will look something like:

```
~/Design-Projects/
├── COMMANDS.md          ← cheatsheets (do not delete)
├── PROMPTS.md
├── POSSIBILITIES.md
├── GLOSSARY.md
├── RECOMMENDED.md
├── TROUBLESHOOTING.md
├── CLAUDE.md
│
├── my-portfolio/        ← your projects (one folder each)
├── client-deck/
├── client-landing/
└── ...
```

You can delete or rename any project folder freely. The cheatsheets at the top will be re-fetched if you run `pegasus update`.

## Want to start over?

```bash
pegasus uninstall      # removes Pegasus tools and templates
                       # leaves your project folders untouched
```
