---
name: vector-workflow
description: Take vector art, SVGs, illustrations, and bitmap art (PNG/JPG from Procreate, Photoshop, Illustrator, Affinity Designer, etc.) and prep them for the web — converting bitmaps to clean vectors, optimizing SVGs, animating, and embedding into the user's project. Use this when the user mentions Procreate, illustrator art, vector logos, SVG files, hand-drawn art, or "this image needs to be on my site."
---

# Vector Workflow

Bridge the gap between an illustrator's source files and clean, performant web output.

## When to use this skill

- The user has a **Procreate** painting, sketch, or logo to put on the web
- The user has a **PNG/JPG** of a logo or icon and wants a vector version
- The user shares an **SVG** file and wants it cleaned, optimized, or animated
- The user wants to **trace** a bitmap into editable vectors
- The user wants to add **Lottie** animation (After Effects → JSON)

## Decision tree

```
Source file?
├── Already an SVG  → optimize with svgo, embed inline, animate if asked
├── Bitmap (PNG/JPG/Procreate export)
│   ├── Logo / clean shapes → trace to SVG with potrace, optimize, embed
│   ├── Photo / illustration → keep as bitmap, convert to WebP, lazy-load
│   └── Icon → trace, optimize, generate sprite or React component
├── Procreate file (.procreate)  → ask user to export to PNG (max resolution),
│                                  then treat as bitmap above
├── Adobe AI / EPS               → ask user to export to SVG from Illustrator
│                                  ("File → Export → Export As → SVG"),
│                                  then optimize
└── After Effects animation      → ask user to export via Bodymovin to Lottie JSON,
                                   then embed with lottie-web
```

## The toolchain (Pegasus pre-installs all of these)

- **`svgo`** — SVG optimizer. Strips bloat, rounds numbers, removes editor metadata.
- **`potrace`** — bitmap → vector. Best for high-contrast logos, line art.
- **`magick`** (ImageMagick) — bitmap conversion, resize, format swap.
- **`ffmpeg`** — video encoding (for animations the user shipped as MP4).
- **`lottie-web`** — vendored as a script tag for Lottie JSON animations.

## Workflows

### A. Procreate logo → web SVG

```bash
# 1. Export from Procreate as PNG (max resolution, transparent background)
#    Procreate: Actions → Share → PNG → AirDrop or save to project folder

# 2. Convert to grayscale BMP (potrace input)
magick logo.png -threshold 50% logo.bmp

# 3. Trace to SVG
potrace logo.bmp --svg --output logo.svg

# 4. Optimize
svgo logo.svg --output logo.min.svg

# 5. Inline in HTML
#    <img src="logo.min.svg" alt="..."> or paste the <svg>...</svg> directly
```

After step 4, **show the user a preview** (open it, screenshot, or use the Image Preview VS Code extension).

### B. Procreate illustration → web image

If the artwork has soft edges, gradients, or texture, **don't trace it** — keep it as a bitmap.

```bash
# Convert to WebP (smaller, modern format) at multiple sizes
for size in 400 800 1600; do
  magick illustration.png -resize ${size}x -quality 85 illustration-${size}.webp
done
```

Then in HTML use a responsive `<picture>`:

```html
<picture>
  <source srcset="illustration-400.webp 400w, illustration-800.webp 800w, illustration-1600.webp 1600w" type="image/webp" />
  <img src="illustration-800.webp" alt="..." loading="lazy" />
</picture>
```

### C. Existing SVG cleanup

Most exported SVGs from Figma / Illustrator / Sketch carry editor cruft (huge `<defs>`, named layers, embedded fonts).

```bash
svgo input.svg --output clean.svg
```

For a folder of SVGs:
```bash
svgo -f ./icons/ -o ./icons-clean/
```

### D. Animation pipeline

**Lottie (preferred for complex motion)**:
1. Designer animates in After Effects.
2. Exports JSON via the [Bodymovin / LottieFiles](https://lottiefiles.com/plugins/after-effects) plugin.
3. Drop the JSON in `./animations/`.
4. Embed:
   ```html
   <script src="https://cdn.jsdelivr.net/npm/lottie-web@5.12.2/build/player/lottie_light.min.js"></script>
   <div id="anim"></div>
   <script>
     lottie.loadAnimation({ container: document.getElementById('anim'), path: 'animations/hero.json', autoplay: true, loop: true });
   </script>
   ```

**CSS animation (preferred for simple motion)**:
- For SVGs: animate `stroke-dashoffset` for line drawing, `transform` for movement, `opacity` for fades.
- Always wrap in `@media (prefers-reduced-motion: reduce) { ... }` to disable for users who need it.

## Hard rules

- **Always preview the result** before declaring "done" — open the file or screenshot it.
- **Never strip the user's signature / watermark** during optimization without asking.
- **Always offer the bitmap fallback** if a trace looks wrong (potrace struggles with anti-aliased edges).
- **Keep the source file** in the project repo (`./art/source/`) so the designer can re-export later.
- For logos that will be reused, **inline the SVG** in HTML rather than `<img src>` — lets you style with CSS.

## Procreate / Adobe / Affinity bridge

There's no MCP server for these tools today (as of when this skill was written). The reliable bridge is:

1. Designer creates in their tool of choice.
2. Exports to a web-friendly format (PNG, SVG, MP4, JSON).
3. Drops the file into the project folder.
4. Asks Claude to handle conversion + embedding using this skill.

Tell the user this explicitly when they ask "can you read my Procreate file?" — the answer is "Procreate doesn't expose an API, but if you export and drop the file, I can do everything from there."
