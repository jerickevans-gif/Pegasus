# CLAUDE.md — Mood board

A single-page mood board to anchor a project's visual direction before any UI work begins.

## How to use

1. Drop reference images into `./refs/` and reference them in the image grid `<div>`s.
2. Edit the palette swatches — change the `style="background:#hex"` and the label.
3. Edit the typography pairings.
4. Fill in the Notes section with texture, motion, voice, and counter-references.

## Working with me

- "Pull 8 reference images from this Are.na channel: [URL]" — I'll use Playwright + image scraping.
- "Suggest a palette for this direction: [3 words]" — I'll generate hex codes + swatches.
- "Pair this serif with a sans" — I'll suggest 3 Google Font combos.
- "Generate counter-references" — I'll list things to avoid.

## When the mood board is approved

Use it as a system prompt for the next phase: "Build the [portfolio/landing/deck] using this mood board's palette, typography, and tone."
