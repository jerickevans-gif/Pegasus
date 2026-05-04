# Recommended external repos

Curated GitHub projects designers using Pegasus might want to grab. All MIT-licensed unless noted. Star counts as of when this list was compiled.

Use `pegasus clone <url> <local-name>` to pull any of these into `~/Design-Projects/`.

---

## Job search & career

### yuhonas/awesome-job-seeking · meta-list
> A curated awesome list of job seeking resources.

The umbrella starting point. Browse this on GitHub to discover dozens of additional tools, sites, and guides for the job hunt.

→ <https://github.com/yuhonas/awesome-job-seeking> (no license stated — link only, don't redistribute)

### santifer/career-ops · 42k★ · MIT
> AI-powered job search system built on Claude Code. 14 skill modes, dashboard, PDF generation, batch processing.

The most comprehensive job-search-via-Claude system out there. Significant overlap with Pegasus's `pegasus jobs` command — but goes much deeper (application tracking, ATS optimization, outreach drafting).

```bash
pegasus clone https://github.com/santifer/career-ops job-search
```

### Paramchoudhary/ResumeSkills · 406★ · MIT
> Claude Code skills for resume writing, ATS optimization, interview prep, strategic job search.

A bundle of skills you can drop into `~/.claude/skills/`. Complements Pegasus's `job-finder` skill.

```bash
pegasus clone https://github.com/Paramchoudhary/ResumeSkills resume-skills
# Then copy the skills you want into ~/.claude/skills/
```

### andrew-shwetzer/career-ops-plugin · 268★ · MIT
> Claude Cowork plugin for job seekers. 9 AI skills: evaluate job postings, generate ATS-optimized resumes, scan company career portals, track applications, draft outreach.

```bash
pegasus clone https://github.com/andrew-shwetzer/career-ops-plugin career-ops-plugin
```

### Gsync/jobsync · 548★ · MIT
> Self-hosted, open-source job application tracker with AI-powered career assistant.

If you want a full app (Next.js + Shadcn UI) for managing your search, not just a CLI/skill setup.

```bash
pegasus clone https://github.com/Gsync/jobsync jobsync-tracker
```

### rendercv/rendercv · 16k★ · MIT
> Resume builder for academics and engineers. Generates PDF from YAML.

For those who want a structured, version-controlled resume in a cleaner format than HTML/print.

```bash
pegasus clone https://github.com/rendercv/rendercv rendercv
```

### xitanggg/open-resume · 8.5k★ · AGPL-3.0
> Powerful open-source resume builder + parser at open-resume.com.

**Note:** AGPL license — use the hosted version at <https://open-resume.com> rather than self-hosting unless you understand AGPL implications.

---

## Workflow toolkits

### mattpocock/skills · 57k★ · MIT
> Skills for Real Engineers. Straight from his .claude directory.

A massive bundle of battle-tested Claude Code skills: `to-prd` (turn ideas into PRDs — useful for case study briefs), `git-guardrails-claude-code` (prevent Claude from breaking git), `setup-pre-commit`, `tdd`, `triage`, `zoom-out`, and a `write-a-skill` meta-skill for building your own.

```bash
pegasus clone https://github.com/mattpocock/skills mp-skills
# Then symlink or copy skills you want into ~/.claude/skills/
ln -s ~/Design-Projects/mp-skills/skills/engineering/to-prd ~/.claude/skills/to-prd
```

→ <https://github.com/mattpocock/skills>

### github/spec-kit · 92k★ · MIT
> Toolkit to help you get started with Spec-Driven Development.

GitHub's official toolkit for writing specs that AI agents (Claude Code, OpenCode, Cursor) follow when building. **Auto-installed by Pegasus** if `uv` is available — gives you the `specify` command system-wide.

```bash
# Pegasus already installed it. Use it like:
specify init my-project
# Then describe what you want and let the AI agent build to the spec.
```

→ <https://github.com/github/spec-kit>
→ Docs: <https://github.github.com/spec-kit/>

---

## Portfolio & case study templates

### erlandv/case · 44★ · MIT
> Case-study-first portfolio theme for Astro. For professionals who want to showcase thinking, decisions, and impact.

Closer to a "thinking person's portfolio" than the typical project grid.

```bash
pegasus clone https://github.com/erlandv/case my-case-portfolio
```

### aker-dev/microfolio · MIT
> Modern static portfolio generator based on SvelteKit 2 and Tailwind CSS 4.

For designers comfortable with a build step who want SvelteKit ergonomics.

```bash
pegasus clone https://github.com/aker-dev/microfolio my-microfolio
```

---

## Design system + token references

Look for these as you grow:

- **shadcn/ui** — component library Claude knows extremely well
- **radix-ui/primitives** — unstyled accessible primitives
- **tailwindlabs/headlessui** — same idea, Tailwind-flavored

---

## Figma asset libraries

### github/annotation-toolkit · 298★ · CC-BY-4.0
> Figma asset library packed with components to organize your design canvas, diagram UI anatomy, and annotate accessibility details.

GitHub's official annotation toolkit. Use it inside Figma to mark up screens with accessibility notes, hierarchy diagrams, and component structure — much easier to communicate to a code agent.

→ <https://github.com/github/annotation-toolkit>
→ Open in Figma directly via the README's link, then duplicate to your team.

---

## Curated asset / inspiration lists

### calebapril/Designer-Tools-and-Assets-for-Developers · MIT
> A curated compilation of design and UI assets — stock photos, web templates, CSS frameworks, UI libraries, tools, and other resources.

Browse this on GitHub when you need an asset and don't know where to look.

→ <https://github.com/calebapril/Designer-Tools-and-Assets-for-Developers>

---

## How to add a new external repo

1. Find the repo. Check that the license is MIT, Apache 2.0, BSD, or CC0.
2. Run `pegasus clone <url> <local-name>`.
3. Read the project's README to understand what it actually does.
4. If you decide to redistribute or build on it, **keep the license file** and add attribution in your own README.

## Want it bundled into Pegasus directly?

Open an issue at <https://github.com/jerickevans-gif/Pegasus/issues> with the repo URL and the use case. Good candidates:
- MIT or Apache 2.0
- 100+ stars
- Maintained in the last 6 months
- Solves a clearly designer-relevant problem
