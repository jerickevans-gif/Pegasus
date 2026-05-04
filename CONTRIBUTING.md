# Contributing to Pegasus

Pegasus is built **for designers, by designers using AI agents**. PRs welcome — especially:

- New templates (designer-tested, opinionated, single-file when possible)
- New skills (clear `description`, generalizable)
- Better docs (plainer language wins)
- Bug fixes and platform parity (Windows ↔ macOS)

## Before you open a PR

1. Open an issue first if it's a big change. Saves both of us time.
2. Run your changes locally — `bash -n install.sh` and `bash -n bin/pegasus` should pass.
3. If you're adding a template, include a `CLAUDE.md` and a `.gitignore`.
4. If you're adding a skill, follow the format in `skills/ux-ui-audit/SKILL.md`.
5. Keep external deps free + no-account-needed (we removed Vercel for that reason).

## Style

- Plain language over jargon.
- Short over long.
- Concrete over abstract.
- The `content-writer` skill knows the house voice — feed it your docs.

## License

MIT. By contributing, you agree your work is MIT too.
