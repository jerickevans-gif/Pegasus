# What's possible

A directory of things designers actually do with Claude Code and OpenCode. Use it for inspiration when you don't know what to ask for.

---

## Build for yourself

### Personal sites
- **Portfolio site** — single page, scrollable, image-heavy
- **Multi-page portfolio** — separate page per project with deeper case studies
- **Resume site** — printable single-page CV that doubles as a web page
- **Link-in-bio page** — your own version of Linktree, hosted on your domain
- **Newsletter landing page** — opt-in form + recent posts

### Case study artifacts
- **HTML slide decks** (reveal.js, Sli.dev) — version-controlled, share via URL
- **Long-form scroll case studies** — narrative pages that scroll through the project
- **Interactive prototypes** — clickable mockups of design work
- **Video case studies** — animated walkthroughs you can record

### Presentations
- **Pitch decks** for client work or interviews
- **Process documentation** showing how you work
- **Workshop slides** for teaching
- **Speaker decks** for talks and meetups

### Internal tools
- **Mood board generator** — pull images from URLs into a grid
- **Color palette extractor** — drop an image, get the dominant colors
- **Type specimen pages** — preview a font in different sizes
- **Spec sheets** — auto-generated from a Figma export

---

## Adapt others' work

- **Clone a layout you admire** — point Claude at a URL and ask "make me one like this"
- **Convert a Figma file** — paste the URL, Claude reads it via Figma MCP and codes it
- **Port a static site** to a CMS-backed site (when you're ready for clients to edit content)
- **Modernize an old portfolio** — drop your old code in, ask Claude to refresh it

---

## Tools that pair well with code

| Tool | What you'd use it for |
|---|---|
| **[Vercel](https://vercel.com) / [Netlify](https://netlify.com)** | Deploy a portfolio in one command, free for personal use |
| **[GitHub Pages](https://pages.github.com)** | Free hosting for static sites under a `username.github.io` subdomain |
| **[Cloudflare Pages](https://pages.cloudflare.com)** | Free hosting with very fast global delivery |
| **[Tailwind CSS](https://tailwindcss.com)** | The styling language Claude knows best — fast to iterate |
| **[Framer Motion](https://www.framer.com/motion/)** / **[Motion One](https://motion.dev)** | Add animations |
| **[reveal.js](https://revealjs.com) / [Sli.dev](https://sli.dev)** | Build slide decks in HTML/Markdown |
| **[Figma MCP](https://www.figma.com/blog/introducing-figmas-dev-mode-mcp-server/)** | Have Claude read your Figma files directly |
| **[Astro](https://astro.build)** | If you outgrow plain HTML — great for portfolios with many pages |
| **[Notion API](https://developers.notion.com)** | Sync content from Notion into your site |

---

## Workflows

### "I designed this in Figma → I want it live by tomorrow"
1. In VS Code, `cd ~/Design-Projects && mkdir new-site && cd new-site`
2. `claude`
3. "Here's my Figma file: [URL]. Build it as HTML/Tailwind. Show me a preview."
4. Iterate on tweaks ("make the headline bigger", "swap the hero image for a video")
5. "Push to GitHub and deploy on Vercel."
6. Send the URL.

### "I have an interview Friday → I need a deck"
1. `cd ~/Design-Projects && mkdir interview-deck && cd interview-deck`
2. `claude`
3. Paste the prompt from [PROMPTS.md → Case study presentation](PROMPTS.md#case-study-presentation-for-interviews).
4. Iterate on slide content with Claude.
5. Drop your real images into the project.
6. Open in browser, hit fullscreen, present from a local URL.
7. Optional: deploy it so the interviewer can revisit after.

### "I want to update my portfolio every Sunday"
1. `code ~/Design-Projects/portfolio`
2. `claude`
3. "Here's a new project I want to add: [paste]. Add it to the grid and link it to a new case study page."
4. `git commit -am "added [project]"`
5. `git push` — Vercel/Netlify auto-deploys.

---

## Things you don't need to know how to do

Claude can handle these for you — just ask:
- Setting up a build tool (Vite, Webpack)
- Writing JavaScript event handlers
- Configuring a CSS preprocessor
- Picking a hosting service
- Setting up a custom domain
- Writing a `package.json`
- Understanding Git enough to ship changes
- Adding analytics
- Adding a dark mode
- Optimizing images
- Making a site responsive
- Adding accessibility features

---

## When to use Claude Code vs OpenCode vs the desktop apps

| Tool | Best for |
|---|---|
| **Claude Code in VS Code** | Most design + code work. Side-by-side with your files. |
| **Claude Code CLI** (terminal) | Quick one-off tasks, automating things, working on a server |
| **OpenCode in VS Code** | Same as above, when you'd rather use an open-source agent or a non-Anthropic model |
| **OpenCode CLI** (terminal) | Quick one-off tasks with the open-source flow |
| **Claude desktop app** | Brainstorming, writing, research that doesn't involve editing files |

---

## Going further

- Read [Anthropic's Claude Code docs](https://docs.claude.com/claude-code) for advanced features (subagents, MCP servers, hooks)
- Read [OpenCode's docs](https://opencode.ai) for plug-and-play model providers
- Browse [Awesome Figma MCP](https://github.com/figma/awesome-figma-mcp) for design-to-code workflows
- Join a community (the Anthropic Discord, the OpenCode GitHub discussions) — designers are sharing patterns there

See also: [COMMANDS.md](COMMANDS.md) and [PROMPTS.md](PROMPTS.md).
