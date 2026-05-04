---
name: job-finder
description: Pull current job listings from BuiltIn.com and LinkedIn, rank them against the user's resume + LinkedIn profile, and return a ranked shortlist with apply URLs. Use when the user asks for help with a job search, wants tailored job recommendations, or asks for a "job pull". Requires the Playwright MCP (use `pegasus connect` to install).
---

# Job Finder

Pull current openings from **BuiltIn.com** and **LinkedIn**, score them against the user's profile, and return a ranked shortlist they can act on the same day.

## When to use this skill

- The user says any of: "find me jobs", "do a job pull", "what should I apply to", "rank these jobs", "design jobs at startups".
- The user is doing a job search and asks for help picking targets.
- The user wants their resume scored against the current market.

## Inputs you need from the user

Ask once, in a single message, then proceed. Don't ask one-at-a-time.

1. **Resume.** Look in this order before asking:
   - `~/Design-Projects/resume/index.html` (if they made one with `pegasus new resume`)
   - `~/Design-Projects/Resume.pdf` or any `*resume*.{pdf,docx,md,txt}` in `~/Design-Projects/`
   - Ask the user to paste it or drop the file path
2. **LinkedIn profile URL.** (e.g. `linkedin.com/in/their-handle`)
3. **Search constraints.** Default if they don't say:
   - Roles: derived from the resume's titles
   - Location: "Remote, US" plus any city mentioned in the resume
   - Salary floor: ask
   - Must-haves / hard nos: ask if not stated

## How to do the pull

### 1. Read the user's profile

- Read the resume file with the `Read` tool. Extract: titles, years of experience, top 5 skills, industries, current location.
- If LinkedIn URL provided and Playwright MCP is available: open the URL, screenshot, extract publicly visible role + summary.
- Build a one-paragraph **profile summary** in your scratchpad. Confirm it back with the user in one sentence ("OK, treating you as a 7-year senior product designer focused on healthcare, open to remote — sound right?").

### 2. Pull from BuiltIn.com

Use the Playwright MCP to navigate `https://builtin.com/jobs/design`. Apply filters that match the profile:
- Location: `?location=remote-us` or city-specific
- Experience level: based on years from resume
- Sort by: most recent

Scrape: title, company, location, salary (if shown), posted date, apply URL. Cap at 50.

### 3. Pull from LinkedIn

Use Playwright to navigate `https://www.linkedin.com/jobs/search/?keywords=<roles>&location=<location>`. LinkedIn shows public listings without login. Scrape the same fields. Cap at 50.

If the user wants logged-in results (better personalization, salary visibility), tell them to:
1. Log into LinkedIn in their default browser
2. Re-run the skill — Playwright will reuse the session in some setups

### 4. Score each job

For each listing, score 0–100 across:
- **Skills overlap** (0–40): how many of the user's top skills appear in the job description
- **Title fit** (0–25): seniority match, role match
- **Location/remote** (0–15): matches their constraints
- **Compensation** (0–10): meets or beats the floor
- **Recency** (0–10): posted in last 14 days = full points

Compute total. Sort descending.

### 5. Output the shortlist

Write the result to `~/Design-Projects/job-shortlist-<YYYYMMDD>.md` AND show it in chat.

```
# Job shortlist · <date>

**Profile:** <one-sentence profile summary>
**Constraints:** <remote/location, salary floor, must-haves>
**Sources:** BuiltIn.com (<n> scanned), LinkedIn (<n> scanned)

## Top 10 to apply to today

| # | Role · Company | Location | Salary | Score | Why |
|---|----------------|----------|--------|-------|-----|
| 1 | Senior Product Designer · Acme | Remote (US) | $180k | 92 | 6/8 skills match. Healthcare focus aligns. Hiring manager has design background per LinkedIn. |
| 2 | … | | | | |

## Worth a look (next 10)

…

## Skipped (and why)

- Junior Designer at Foo — too junior for your level
- Designer at Bar — onsite Berlin, conflicts with your remote-US constraint
```

End the chat message with a 2-line tl;dr and ask: "Want me to draft a tailored cover line for any of these?"

## Hard rules

- **Never** invent jobs. Only list what you actually scraped.
- **Always** include the apply URL — make it one click for the user.
- **Always** save the shortlist to a file so they can re-open it tomorrow.
- **If Playwright is missing**, stop and tell the user: "Run `pegasus connect` and install Playwright, then ask me again."
- **Don't** scrape job sites while logged in as someone else's account. Respect ToS.
- If the LinkedIn scrape returns 0 results, that usually means the search URL malformed. Tell the user, show them the URL you tried, and offer to adjust.

## Companion files

None — this skill is self-contained.
