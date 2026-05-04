# Auto-mode workflows

Pre-built recipes that chain Pegasus's skills together for end-to-end results. Each recipe is a sequence of prompts you paste into Claude (or OpenCode) one at a time. Claude picks the right skill from the description.

These cross-pollinate skills from both tracks — design and job search — because real workflows do too.

---

## 🎨 DESIGN WORKFLOWS

### W1 · Figma → Live Portfolio (one afternoon)

Ships a working portfolio at a public URL from a Figma design.

```
1. "Use the Figma MCP to read this file: <FIGMA_URL>. Summarize what you see."
2. "Use the content-writer skill to write a hero tagline + about paragraph
    based on the Figma file's positioning. Three versions."
3. "Build the design as HTML/Tailwind. Match colors and type from Figma."
4. "Use the ux-ui-audit skill to audit what you built. Fix Critical + High items."
5. "Deploy with `pegasus deploy` (Surge)."
```

### W2 · Procreate Art → Showcase Page

Takes raw illustration exports and ships a beautiful gallery.

```
1. "I have these Procreate exports in ./art/. Use the vector-workflow skill
    to convert each to WebP at 1600px wide, lazy-loaded."
2. "Generate `pegasus new illustration-gallery <name>` and drop the converted
    art into it. Vary the aspect ratios per piece for a curated feel."
3. "Use content-writer to caption each piece in 3-5 words."
4. "Audit accessibility with ux-ui-audit (focus on alt text, keyboard nav)."
5. "Deploy."
```

### W3 · Design System Spec → Components Lab

Turns a verbal description into a copy-pasteable component library.

```
1. "I want a design system with these tokens: [paste]. Use the spec-kit
    `specify` command to write a structured spec first."
2. "Now generate `pegasus new components-lab <name>` using the spec."
3. "Add buttons (4 variants), cards (3 variants), forms (5 inputs),
    hero blocks (2 variants). Each with a live preview + snippet."
4. "Audit with ux-ui-audit, focus on focus rings + contrast."
5. "Deploy."
```

### W4 · Case Study Quick Drop

Goes from project debrief to portfolio-ready case study in 30 minutes.

```
1. "Use the portfolio-case-study skill — I'm starting a case study about
    [project]. Run the intake."
2. "Use scroll-case-study template. Slot the intake answers into the
    appropriate sections."
3. "Use content-writer to refine each section. Apply the Tight version."
4. "Use ux-ui-audit on the resulting page."
5. "Deploy. Add the URL to my main portfolio's project grid."
```

---

## 💼 JOB SEARCH WORKFLOWS

### W5 · From Job Posting to Sent Application

End-to-end pipeline: pasted JD → tailored resume → cover letter → outreach.

```
1. "Use career-ops-research on [Company]. Get me the brief."
2. "Use career-ops-evaluate on this JD: [paste]. Should I apply?"
3. (If yes) "Use career-ops-tailor-resume to make an ATS-optimized version
    targeting this JD."
4. "Use cover-letter-generator from my tailored resume + the JD."
5. "Use career-ops-outreach to draft a LinkedIn message to [hiring manager]
    based on what we learned in step 1."
6. "Save everything to ~/Design-Projects/applications/<Company>-<YYYYMMDD>/"
```

### W6 · Weekly Pipeline Triage

Run every Monday morning.

```
1. "Use the job-finder skill to pull jobs from BuiltIn and LinkedIn matching
    my profile. Save the shortlist to ~/Design-Projects/this-week.md."
2. "Use career-ops-triage to score every job on the shortlist by fit.
    Rank from highest to lowest."
3. "Pick the top 5. For each, use career-ops-evaluate."
4. "Tell me which 1-3 to actually apply to this week."
```

### W7 · Interview Sprint (24h before)

Goes from "I have an interview tomorrow" to "I know what I'm going to say."

```
1. "Use career-ops-research on [Company]. Latest news, culture, recent hires."
2. "Use the interview-prep skill — interview is at [Company] for [Role]
    on [Date]. Use the brief from step 1."
3. "Use interview-prep-generator to build STAR stories from my resume bullets
    relevant to the role's requirements."
4. "Switch to rehearsal mode. Ask me each likely question one at a time and
    critique my answers."
5. "If they have a design challenge, use the brief from step 1 to predict
    what they'll ask."
```

### W8 · Offer → Counter-Offer

Triggered when an offer arrives.

```
1. "Use salary-negotiation-prep — I have an offer from [Company] for [Role].
    The numbers are [base/equity/bonus/perks]. My target is [X]."
2. "Generate market-rate research with sources."
3. "Draft my counter-offer email. Three versions: gentle / firm / aggressive."
4. "Walk me through the likely back-and-forth."
```

---

## 🔁 CROSS-POLLINATING WORKFLOWS

### W9 · Portfolio → Job Application (the bridge)

Shows your portfolio to its best advantage in an application.

```
1. "Use career-ops-evaluate on this JD: [paste]."
2. "Look at my portfolio at <URL>. Pick the 3 projects most relevant to
    this JD. For each, write the 30-second pitch."
3. "Use cover-letter-generator. Tell it which projects to anchor on."
4. "Use the portfolio-case-study skill to extend the most relevant project
    into a deeper case study (if it's still light)."
5. "Use career-ops-tailor-resume so my work history reflects the same
    framing as the cover letter and case study."
```

### W10 · Case Study → Interview Talking Points

Repurposes case study material as interview material.

```
1. "Read the case study at ~/Design-Projects/<project>/index.html."
2. "Use interview-prep-generator to extract 5 STAR stories from it."
3. "Use content-writer to make each STAR story feel conversational, not
    rehearsed. 90 seconds spoken each."
4. "Save to ~/Design-Projects/interview-stories/<project>.md."
```

---

## How to use these

- **Don't paste a whole workflow at once.** Run step 1, see the result, then step 2.
- **Edit recipes in this file** as you discover what works for you. They're starting points, not gospel.
- **Combine recipes.** "Run W1, then W7 with the result" is a totally valid prompt.
- **Save your favorites.** When a recipe works well for you, copy it into a `~/Design-Projects/my-workflows.md` and refine over time.

## Adding a new workflow

```
### W## · <Name>

<one-line goal>

```
1. "Use <skill> to <do thing>."
2. "Now use <skill> to <next thing>."
3. ...
```
```
