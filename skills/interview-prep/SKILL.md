---
name: interview-prep
description: Prepare a designer for a specific interview — generate likely questions tailored to the company + role, draft strong answers anchored on the user's resume, suggest portfolio pieces to walk through, and rehearse with feedback. Use when the user mentions an upcoming interview, recruiter screen, design challenge, or portfolio review.
---

# Interview Prep

Take a designer from "I have an interview Tuesday" to "I know exactly what I'm going to say."

## When to use this skill

- The user mentions: "interview", "recruiter screen", "portfolio review", "design challenge", "case study presentation".
- The user pastes a job description and asks for help getting ready.
- The user asks to be quizzed or rehearsed.

## Inputs you need

Ask once, in a single message:

1. **Company + role.** Or paste the job description.
2. **Format.** Recruiter screen, hiring manager, portfolio walk-through, take-home challenge, panel?
3. **Date.** So you can size the prep — 24h vs 1 week changes the depth.
4. **Resume location** — default to `~/Design-Projects/resume/` if it exists.
5. **Portfolio URL** — optional but helps tailor which pieces to walk through.

## What to deliver

Save everything to `~/Design-Projects/interview-<company>-<YYYYMMDD>.md` AND show in chat.

### Section 1 — Company brief (10 lines max)
- What the company does in one sentence
- Their main product, market position, recent news from the past 30 days
- Their design culture (visual style, public team posts, hiring blog)
- Likely interviewer profile (use the role title to infer — design manager, peer designer, PM, eng)

### Section 2 — 8 likely questions, ranked by probability

For each, format:
```
Q: <the question>
Why they ask: <one line>
Strong answer (anchored on user's resume):
  <2-3 sentence answer in the user's voice>
Hooks to mention from your portfolio: <which projects to bring up>
```

Cover the four standard categories: behavioral, craft, process, "why this company".

### Section 3 — Portfolio walk-through plan
- Pick 3 pieces from the user's portfolio. For each:
  - Why it's relevant to this role
  - The 30-second pitch
  - The deeper 3-minute version
  - The 2 hardest questions an interviewer might ask, with answers ready

### Section 4 — Design challenge prep (if format includes one)
- Likely brief (based on what this company does)
- Constraints to ask about up front
- Time budget for each phase
- The "showing your thinking" moves to make explicit

### Section 5 — Logistics
- Timezone of the interview
- Tools you'll need (Zoom, Figma file shared in advance, etc.)
- What to wear in screen
- How to follow up after

## Rehearsal mode

If the user says "rehearse with me" or "quiz me":
1. Pick one question at random from Section 2.
2. Wait for their answer.
3. Critique in this format:
   - **Strong:** <one line on what worked>
   - **Watch out:** <one line on what to tighten>
   - **Suggested rewrite:** <one paragraph in their voice>
4. Move to next question.

## Hard rules

- Never invent facts about the user's experience. Only use what's in their resume + portfolio.
- Never invent specific people at the company unless they're publicly known and verifiable.
- If the user pastes a JD, **read the entire JD** before generating questions — surface specific keywords from it in your answers.
- Use the **Playwright MCP** (if available) to look up recent press / Glassdoor signals on the company. Cite what you find.
- Always end with a 3-line tl;dr the user can re-read 20 minutes before the interview starts.
