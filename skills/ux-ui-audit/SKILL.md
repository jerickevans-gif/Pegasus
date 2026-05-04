---
name: ux-ui-audit
description: Conduct a comprehensive UX/UI audit and optimization review of any web app, mobile app, or PWA. Apply best practices around emergency usability, voice-first design, accessibility (WCAG 2.1 AA), modular layout, responsive breakpoints, performance, content design, search, error handling, settings, and emotional/trust design. Generalizable to any product where the user's first principle is "can I find and act on this in 3 seconds, in stress, with one hand?"
---

# UX/UI Audit — Best Practices

You audit web apps, mobile apps, and PWAs against a 17-section checklist that covers emergency usability through emotional design. The full checklist lives in `checklist.md` and a delivery template lives in `report-template.md`. This SKILL.md is the operating manual.

## When to use this skill

- The user asks for a UX audit, accessibility review, design review, or UX optimization pass.
- You're about to ship a non-trivial product surface and want a self-check.
- A product team mentions stress users, accessibility, voice, offline, or PWAs — those are signals every section here matters.
- The user wants you to "make it watertight" or "ship-quality" on UX.

## How to use it

1. **Read the source**. Don't audit blind. Pull the canonical token files (CSS variables, fonts, design tokens), the entry HTML/JSX, and any nav scaffolding. Then click through the surface (or read its routes) so the audit is grounded in what actually exists.
2. **Score each of the 17 sections** in `checklist.md` as one of:
   - **Pass** — works correctly and meets best-practice intent.
   - **Partial** — present but flawed (e.g., focus rings exist but contrast fails).
   - **Missing** — absent.
   - **N/A** — doesn't apply (e.g., no voice on a doc-only site).
3. **For every Partial / Missing**, propose a concrete fix sized to one PR. Include the file path or component name when you can.
4. **Prioritize fixes** by user-pain × frequency: emergency usability first, then accessibility, then everything else.
5. **Deliver the report** using `report-template.md`. End with a 3-line tl;dr the team can ship in Slack.

## The 17-section checklist (high-level — see `checklist.md` for the full detail)

1. **Emergency usability** — time-to-info ≤ 3 taps, large hit targets, sunlight/dark contrast, persistent mode indicator.
2. **Voice interface** — wake-word reliability, confidence display, manual correction, fallback to text/touch.
3. **Knowledge navigation** — search, browse categories, atom cards, scannable detail.
4. **Offline functionality** — PWA install, service worker cache coverage, offline indicator.
5. **Alert systems** — status badges, low-storage warnings, stale-data indicator.
6. **PWA & install** — install banner, splash screen, standalone mode.
7. **Accessibility (WCAG 2.1 AA)** — screen reader, keyboard, contrast, focus, touch, scaling, motion.
8. **Responsive breakpoints** — mobile (375), tablet (768), desktop (1024), large (1440).
9. **Performance** — FCP, TTI, lazy loading, smooth scroll, voice latency.
10. **Domain coverage** — the domain's full set (e.g. failure modes, rooms, products) is browsable.
11. **Content design** — atom/card structure, voice-first format, visual format.
12. **Search & discovery** — full-text, voice, browse, recent, fuzzy.
13. **Integration entry points** — links to / from sibling tools.
14. **Browser API integration** — Web Speech, SpeechSynthesis, etc., with graceful fallback.
15. **Error handling** — network, voice, content errors with reproompts.
16. **Settings** — voice, display, cache, privacy.
17. **Emotional & trust design** — calm tone, reliability cues, privacy made visible.

## Hard rules — apply to every audit

These showed up over and over in real audits and should be checked unconditionally.

### Modularity & control
- Every visible section should be a **toggleable widget** with a stable id.
- Ship 3 layout presets — **minimalist**, **recommended**, **maximalist** — plus **custom**.
- Persist the user's layout. Voice + keyboard + button bridge all dispatch the **same intent** to the **same router**. Never duplicate logic per surface.
- Expose a global hardware bridge (e.g. `window.appButtons.dispatch(intent)`) so a paired physical controller fires identical intents.

### Voice as a first-class peer to touch
- Treat **voice, keyboard, and pointer** as three input channels into one intent dispatcher.
- Provide explicit fallback: if `SpeechRecognition` is unsupported, show keyboard equivalents inline.
- Voice phrases live with the widget definitions — don't keep a separate phrase table that drifts.

### Stress hands
- Every interactive control: **44 × 44 px minimum** (Fitts's Law).
- No hover-only interactions. No precision gestures. Tap-only equivalents always exist.
- Undo or back-out is reachable in one tap.

### Sunlight + darkness contrast
- Ship **three** themes: light (parchment), dark (sovereign default), **hi-contrast** (pure black + sodium yellow).
- All three pass WCAG AA. Hi-contrast passes AAA where possible (≥ 7:1 body text).
- Focus rings on hi-contrast: 3px + 3px offset using the brand accent.

### Mode indicator
- A single persistent pill that shows: **online/offline · voice listening · theme · preset · crisis**.
- Click opens settings. Aria-label combines all values for screen-reader friendliness.

### Offline-first PWA
- Manifest with name, theme color, icons, shortcuts.
- Service worker with: precache shell, stale-while-revalidate for live data, cache-first for static assets, network-first fallback for everything else.
- Install banner that's dismissible with persisted dismissal.

### Accessibility — keep it boring
- `<a href="#main">Skip to main</a>` as the first body element. `id="main"` on `<main>`. `tabIndex={-1}` on main so the skip link is focusable.
- Every form field has a `<label htmlFor>`. Every icon-only button has `aria-label`.
- Live updates use `aria-live="polite"` (or `assertive` for crises only).
- `prefers-reduced-motion` zeros all transitions globally.
- Tab order matches visual order. No keyboard trap.

### Responsive breakpoints — distinct, not just shrunk
- **Mobile (≤ 720)**: bottom nav, single column, 44px+ targets.
- **Tablet (720–1023)**: icon-only rail, two columns, distinct from mobile *and* desktop.
- **Desktop (≥ 1024)**: full nav, multi-column. Don't just unhide the mobile nav.

### Backend & integration
- Pluggable **storage adapter** behind one interface — in-memory for tests, SQLite for prod, swap to Postgres/DHT/radio later by changing one line.
- Keep API routes thin: validate input, call `storage.<method>`, return JSON. No business logic in route handlers.
- Document the plugin contract in a `README.md` next to the storage code.

### Vetted user-generated content
- Every UGC pipeline (atom submission, review queue) has a **moderation step** before merging.
- Reviewer + reviewedAt + reviewNote captured.
- Approved content propagates with the reviewer's signature, not the submitter's identity.

### Live data + integration testing
- For any feature that integrates an external API, **smoke-test against the real source** in a barrage script — not just mocked data. Failures from live APIs (auth, headers, schema, rate limits, CORS) only surface when you actually call them.
- Every adapter that calls an external service must **fail soft**: return `[]` or a typed empty result, never throw, never propagate raw errors to the UI. Log the upstream status code internally so debugging the swallow path is cheap.
- Don't blindly trust query parameters work — some public APIs (NOAA NWS is the canonical example) return 400 for plausible-looking params. Test the actual response, not the assumption.
- When a public API needs a custom `User-Agent`, the proxy needs to set it on the **server fetch**, not the client. Document this at the adapter boundary.
- **Failure log discipline:** every barrage run appends to a single `LIVE-TEST-FAILURES.md` with `expected / actual / fix / priority`. Re-runs add new entries. Recommendations sit at the bottom in priority order.

### Server-side search vs. client-side filter
- A client-side filter is fine for ≤ ~100 items. Past that, ship a server endpoint with `?q=&tag=&limit=&offset=` and **debounce client input** (~150 ms). Don't refactor at scale — design for the eventual scale on day one.
- The same fuzzy + score logic should live on the server. Don't duplicate it client-side; have the client be a thin caller.

### Watch out for `networkidle` with persistent connections
- If your app opens an SSE / WebSocket / long-poll connection, `page.waitForLoadState("networkidle")` will **never fire**. Use `domcontentloaded` + a small settle delay instead.
- Document this in your test helpers so a future contributor doesn't waste an hour.

### Idempotent migrations on every boot
- A storage adapter that seeds data on first run is brittle: growing the seed set ships new data only to fresh installs. Use `INSERT OR IGNORE` / `MERGE` semantics so seed migrations apply to every boot without breaking existing rows.
- The same pattern applies to `localStorage` shape upgrades — always version your persisted state.

### "Don't make me wait, don't make me think"
- Every external fetch shows a spinner (or skeleton) within 100 ms.
- Every search input debounces at ~150 ms.
- Every page transition has visible feedback within 16 ms (one frame).
- A misheard voice command auto-retries listening — don't make the user re-press the mic button.

### Live event push to the client
- For multi-tab / multi-cockpit sync, ship a Server-Sent Events route from day one. The implementation is ~30 lines and removes the need for clients to poll.
- Surface the connection state in the mode pill (or equivalent), so users know when live updates have dropped.

### Honesty in settings
- Every toggle in settings should affect **something**. If the destination isn't wired yet, **disable the toggle** with an explainer (`"No destination wired yet — placeholder for a future opt-in pipe"`). Don't ship toggles that secretly do nothing.

### ARCHITECTURE.md per project
- Document every pluggable surface (storage, voice, radio, live feeds, intent dispatcher, layout, etc.) in a single `ARCHITECTURE.md` at the repo root.
- Each adapter section: interface, default impl, drop-in path, registry location.
- Future you (or the next contributor) reads this once and is up to speed.

## Output discipline

- Lead with the **3-line tl;dr**.
- Never list tables of contents. The reader sees the sections by reading.
- Quote actual file paths and line numbers, not generalities.
- For every "Missing" item give exactly one fix sized to a PR.
- Don't be polite at the cost of being honest. If 5 of 17 sections are Missing, say so.

## When you finish

After delivering the report, ask the user once whether they want you to **start fixing** in priority order. Do not start fixing without the green light.

## Companion files

- `checklist.md` — the full 17-section audit checklist with the granular sub-items for each section.
- `report-template.md` — the format the audit report uses.
