# CLAUDE.md — Illustration gallery

A masonry-grid gallery for showcasing illustration, painting, lettering, or any visual art. Designed for vector-heavy and Procreate-heavy creators.

## How to add art

1. Drop image files into `./art/` (create the folder).
2. For each piece, use a `<figure>` block in `index.html`:
   ```html
   <figure class="mb-4 break-inside-avoid">
     <div class="aspect-[4/5] bg-stone-300 rounded overflow-hidden">
       <img src="art/painting-title.jpg" alt="..." loading="lazy" class="w-full h-full object-cover" />
     </div>
     <figcaption class="text-xs text-stone-500 mt-1 px-1">Title · 2026</figcaption>
   </figure>
   ```
3. Vary the `aspect-` ratio per piece (`aspect-square`, `aspect-[3/4]`, `aspect-[4/5]`, etc.) — that's what makes a masonry grid feel curated.

## Working with Claude on this

- Use the **vector-workflow** skill: "I have these Procreate exports in ./art/ — clean them up for the web and add them to the gallery."
- For lots of art at once: "convert everything in ./art/raw/ to WebP at 1600px wide max, save to ./art/, and add `<figure>` blocks for each."
- For a single hero piece, ask: "make this one full-bleed, breaking out of the grid."

## Deploy

`pegasus deploy` ships it.
