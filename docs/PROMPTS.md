# Suggestive prompts

Copy, paste, and tweak. These prompts are written for Claude Code, but most work in OpenCode too. Each section starts with a "first prompt" you can drop in cold and goes from there.

---

## Portfolio website

### First prompt — start a portfolio from scratch

> Build me a single-page portfolio site at `/`. I'm a [graphic designer / product designer / illustrator]. I want sections for: hero with my name and one-line tagline, a project grid with 6 placeholder cards, an about section, and a contact link. Use Tailwind. Use a clean editorial typography style — large serif headlines, generous whitespace. Make it responsive. When you're done, start a Live Preview server and tell me the URL.

### Iterate on the design

- "The headline feels too small. Make it 1.5× bigger and tighten the line-height."
- "Swap the project grid to a horizontal-scrolling row on mobile."
- "Add a dark mode toggle in the top-right corner that respects the system preference by default."
- "Use [hex code] as the primary color and find a complementary accent."

### Add real content

- "Replace the 6 placeholder cards with these projects: [paste a list]. For each, leave a `<!-- TODO: image -->` placeholder so I can drop in artwork later."
- "I'll paste in some project descriptions. Format them as case study cards with title, role, year, and a 2-sentence summary."
- "Wire up a contact form that opens an email draft to me when submitted (mailto: link)."

### From a Figma design

> Here's the Figma file for my portfolio: [paste figma.com URL]. Use the Figma MCP tools to read the design and turn it into HTML/Tailwind that matches as closely as possible. Use my actual fonts and colors from the design. Show me a preview when you're done.

### Publish it

- "Initialize a git repo, push it to GitHub as `my-portfolio` under my account, and walk me through deploying it to Vercel."
- "Set up a custom domain — I bought `myname.com`. Tell me exactly what DNS records to add."

---

## Case study presentation (for interviews)

### First prompt — turn a case study into a slide deck

> I have a design case study about [project name + 1-line description]. Build me a slide deck as a single HTML file using [reveal.js / Sli.dev]. I want around 10 slides: cover, problem, research, ideation, design decisions (3 slides), final result, impact, thanks. Make it look like a polished design portfolio — minimalist, big imagery, sans-serif. Drop a `<!-- TODO: image -->` placeholder on each slide. Start a Live Preview when done.

### Iterate

- "Add a slide between 'research' and 'ideation' for user personas."
- "Make the impact slide show 3 large stats side-by-side with subtle animation when the slide enters."
- "Switch the type to [font name from Google Fonts]."
- "I want the deck to auto-advance during a video recording — set a 15-second timer per slide and let me override with the arrow keys."

### Export

- "Add a print stylesheet so I can export this to a PDF that prints one slide per page."
- "Make a mode where I can hit 'P' to toggle a presenter view with my notes alongside each slide."

### Adapt for a different audience

- "Take this same content and remix it for a 5-minute lightning talk at a meetup — fewer words on screen, more impact per slide."
- "Now make a long-form scroll-page version of the same case study (no slides, just a tall scrollable narrative)."

---

## Showcase reel / product demo

### First prompt — interactive prototype

> Build me an interactive prototype of [the thing you want to show]. Use vanilla HTML/CSS/JS — no framework. I want someone to be able to click through it like a working app, even though the buttons are fake. Three screens: [list them]. When you're done, start a Live Preview.

### Animate it

- "Add subtle micro-interactions: hover states on buttons, a 200ms fade between screens, a soft spring animation when cards enter view."
- "Use the [Motion One / GSAP / Framer Motion] library if it makes things smoother."

### Record it

- "Help me record this demo. Suggest the best free screen recorder for macOS, the optimal resolution for posting on Twitter/LinkedIn, and a script I should follow while recording."

---

## Presentations of design systems

### First prompt — a living style guide

> Build me a single-page style guide that documents my design system. Sections: typography (show all heading levels and body sizes), color palette (with hex codes I can click to copy), spacing scale, button states, form components. Use the system itself to render the page — i.e. if I update a CSS variable, the whole page reflects it. Tailwind is fine but expose the tokens as CSS vars too.

### Extend

- "Add a 'components' section showing my card component in 4 variants with the code shown beneath each."
- "Make every code block copy-to-clipboard on click."

---

## Smaller useful prompts

### Image / asset wrangling

- "Resize all images in `./images/` to max 1600px wide, convert to WebP, and update the HTML to point at the new files."
- "Generate placeholder SVGs for my 6 project cards — abstract shapes in my brand colors [paste hex codes]."

### Accessibility check

- "Audit this page for accessibility. Show me a list of issues ranked by severity, then fix the easy ones automatically."

### Performance

- "This site loads slowly. Find what's making it heavy and tell me the 3 highest-impact things to fix."

### When stuck

- "Explain what's happening in this file [drop file in chat] like I'm new to JavaScript."
- "I tried to do X and got error Y. Walk me through what happened and how to avoid it next time."

---

## Prompt patterns that work

1. **State the goal, not the steps.** Say "I want a portfolio that scrolls horizontally on mobile" — not "add `overflow-x: scroll`".
2. **Ask for a preview at the end.** "Start a Live Preview when done" saves a step.
3. **Use placeholders for things you'll fill in later.** `<!-- TODO: image -->`, `[YOUR NAME]`, etc.
4. **Iterate in small steps.** One change per prompt is faster than five.
5. **Save what works.** Add winning patterns to your project's `CLAUDE.md` so Claude does it automatically next time.

---

See also: [COMMANDS.md](COMMANDS.md) for the keystrokes, and [POSSIBILITIES.md](POSSIBILITIES.md) for more ideas of what to build.
