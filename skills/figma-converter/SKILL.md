---
name: figma-converter
description: Convert a Figma file or frame URL into clean, production-ready HTML/Tailwind that matches the design 1:1. Uses the Figma MCP server (set up by Pegasus) to read the actual file, then writes minimal markup with the right tokens, fonts, and responsive breakpoints. Use when the user pastes a figma.com URL or asks to "convert this design", "build this Figma file", "rebuild from Figma".
---

# Figma → Code Converter

Take a Figma URL and ship a working HTML page that matches.

## When to use

- The user pastes a `figma.com/design/...` or `figma.com/file/...` URL
- The user says "rebuild this from Figma", "convert the design", "make it match the Figma"
- The user wants Code Connect–style output where the markup mirrors their design system

## Prerequisites

- The Figma MCP server is reachable (tested via `claude mcp list | grep figma` → ✓ Connected)
- Figma desktop app is running with **Dev Mode MCP Server** enabled (Preferences → toggle ON)
- The user has the file open in Figma desktop (the MCP reads the active session)

If any of the above is missing, **stop and tell the user explicitly** — don't make up output.

## How to convert

### 1. Read the Figma file
Use the Figma MCP's tools:
- `get_design_context` for the node you're converting (pass the URL's node-id)
- `get_metadata` if you need parent/sibling structure
- `get_screenshot` for visual confirmation
- `get_variable_defs` for design tokens (colors, type scales, spacing)

### 2. Map design tokens to Tailwind
- **Colors** → CSS custom properties at `:root` (e.g. `--brand: #...`) + Tailwind arbitrary values OR a `tailwind.config` extension
- **Type scale** → match Figma's text styles to Tailwind text-{size} classes; use `font-serif` / `font-sans` aliases
- **Spacing** → favor Tailwind's stock scale (4/8/12/16/24/32/48/64); only use arbitrary values when the design demands it
- **Radii, shadows** → same approach: stock first, arbitrary only when needed

### 3. Write the markup
- Use semantic HTML (`<header>`, `<main>`, `<section>`, `<article>`, `<footer>`)
- Tailwind classes inline (no separate CSS unless needed for animations/print)
- Responsive: build mobile-first, add `md:` and `lg:` breakpoints to match Figma's breakpoint frames
- Images: include `alt` attributes from the Figma layer name (or ask the user); use `loading="lazy"` for non-critical
- For fonts not in Google Fonts, ask the user how to handle (download, swap, use system fallback)

### 4. Show a preview
After writing, **always**:
- If a Live Preview server is running, refresh it
- Otherwise tell the user: "Right-click `index.html` → Show Preview, or `npx serve .`"
- Compare to the Figma screenshot. Note any pixel-level differences.

### 5. Confirm with the user
End with: "Built and previewed. Drift from Figma I'm aware of: [list]. Want me to fix any of these, or move on?"

## Hard rules

- **Never invent design details** the Figma file doesn't have. If Figma says `#0a0a0a` and 14px, use those exact values — don't "improve" them.
- **Don't generate placeholder content** unless the Figma frame literally has lorem ipsum. If text is missing, ask.
- **One source of truth.** If the user later edits the Figma file, re-run this skill rather than hand-editing the HTML.
- **Mobile breakpoints are required.** Don't ship a desktop-only conversion unless the Figma file is desktop-only and the user confirms.
- **Accessibility minimums:** every interactive element gets a focus state; every image has alt text; tab order matches visual order.

## When the Figma file uses Code Connect

Some teams have mapped Figma components to real codebase components via Figma's Code Connect. If `get_code_connect_map` returns mappings, **prefer the mapped component** over rebuilding the markup from scratch.

## Companion skills to chain after

- `content-writer` — refine any copy that came from the Figma file
- `ux-ui-audit` — audit your output against the 17-section checklist
- `vector-workflow` — if the Figma file has SVG icons that need optimization
