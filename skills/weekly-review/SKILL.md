---
name: weekly-review
description: Run a weekly check-in on the user's design + job-search progress. Reviews recent activity in ~/Design-Projects/, surfaces stalled threads, drafts a weekly recap, and proposes 3 things to focus on next week. Use when the user says "weekly review", "what should I do this week", "Sunday review", or asks for a check-in.
---

# Weekly Review

Run every Sunday (or whenever). Pulls signal from the user's project folder + Pulse data + recent commits, then proposes the 3 highest-value moves for the week ahead.

## When to use

- User says: "weekly review", "Sunday review", "check in with me", "what should I do this week"
- It's been more than 7 days since the user did a review (check `~/Design-Projects/.last-review` if it exists)

## Process

### 1. Pull signal (no questions yet)

Read each of these and summarize internally:

- **`~/Design-Projects/`** — list every subfolder. For each, run `git log --since='1 week ago' --oneline` and note activity.
- **`~/.pegasus/profile.json`** — current focus, top skills.
- **localStorage Pulse** (if you can ask the user to paste it) or `~/.pegasus/pulse.json` if they exported it.
- **Open application folders** in `~/Design-Projects/applications/` (if any) — which jobs are still pending?
- **The user's current track** (`localStorage.pegasus.track`) — design vs job search.

### 2. Show the recap (one screen, scannable)

```
# Weekly Review · <date>

## What you shipped this week
- <project>: <one-line of what changed>
- ...

## What stalled
- <project>: last commit <N days ago>, looks paused
- <application>: still no response — follow up?

## Pulse
- N copies this week (vs M last week)
- Skills used: <list>
- Day streak: <N>

## Next week's 3
1. <Highest-value action>
2. <Second>
3. <Third>

## Something to celebrate
<one specific win>
```

### 3. Save the recap

Write to `~/Design-Projects/reviews/<YYYY-MM-DD>.md`. Touch `~/Design-Projects/.last-review`.

### 4. Ask one question

End with: "Want me to start any of those 3 right now?"

## Hard rules

- **Don't invent activity.** If git log is empty, say "no commits this week — was the focus elsewhere?"
- **Be specific in 'next week's 3'.** Not "work on portfolio" — "add a 7th project card to portfolio: Acme redesign case study, ~3 hours."
- **One celebration.** Brief. Genuine. Don't pad.
- **Save the recap.** Reviews compound when the user can re-read them.

## How this chains with other skills

If "next week's 3" includes a job search action: chain to `career-ops-evaluate` or `interview-prep`.
If it includes shipping a portfolio piece: chain to `portfolio-case-study` or `figma-converter`.
If it includes resume/cover letter work: chain to `resume-tailor` or `cover-letter-generator`.

Don't auto-chain — propose the chain and let the user trigger it.
