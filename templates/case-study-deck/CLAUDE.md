# CLAUDE.md — Case study deck

A presentation deck built with [reveal.js](https://revealjs.com), loaded from a CDN. No build step.

## How it works

- One file: `index.html`. Each `<section>` is a slide.
- Arrow keys navigate. `F` for fullscreen. `S` for speaker view (notes + timer).
- Theme is "white" with my Pegasus tweaks (Crimson Pro headings, Inter body).

## Working with me on this

- When I ask to add a slide, drop a new `<section>` in the right place.
- When I share a Figma file, use the Figma MCP to read it and rebuild matching slides.
- Image placeholders go inline as `<img src="...">`. Save images to `./images/`.
- For animations between slides, change `transition: 'fade'` to `slide`, `convex`, `concave`, or `zoom`.

## Preview

Right-click `index.html` in VS Code → **Show Preview**, or `npx serve .`.

## Export to PDF

In Chrome: open the deck, append `?print-pdf` to the URL, then File → Print → Save as PDF.

## Deploy

`pegasus deploy` ships it live. Share the URL with the interviewer afterward so they can revisit it.
