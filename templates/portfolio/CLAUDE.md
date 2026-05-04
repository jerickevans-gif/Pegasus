# CLAUDE.md — Portfolio project

This is a static portfolio site built with HTML and Tailwind CSS (via CDN — no build step).

## Stack

- Single `index.html` with Tailwind classes
- Google Fonts: **Crimson Pro** (serif) for headings, **Inter** (sans) for body
- Optional `styles.css` for anything Tailwind can't express
- No JavaScript framework. No bundler. It just works in any browser.

## How to work with me on this

- When I ask to add a project, drop it into the grid in `<section id="work">` as a new `<article>`.
- When I ask for a new page, create it in this folder (e.g. `about.html`) and link to it from the nav.
- Default to small, runnable changes — let me preview after each.
- For images, save them to `./images/` (create the folder if needed) and reference relative paths like `images/project-1.jpg`.
- When I share a Figma URL, use the Figma MCP tools to read the design and adjust the layout to match.

## Preview

In VS Code: right-click `index.html` → **Show Preview** (Live Preview extension).
Or in the terminal: `npx serve .`

## Deploy

`pegasus deploy` from this folder ships it to Vercel.
