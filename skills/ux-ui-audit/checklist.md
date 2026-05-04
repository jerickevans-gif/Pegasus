# UX/UI Audit — Full checklist

Score each item: **Pass / Partial / Missing / N/A**.

---

## 1. Emergency usability

### 1.1 Time-to-info
- [ ] Critical info reachable in **≤ 3 taps** from the home surface
- [ ] **Voice query → answer** ≤ 2 seconds local, ≤ 4 seconds with embed proxy
- [ ] Most-used scenarios surfaced as a quick-pivot row above the fold
- [ ] Quick-access shortcuts (`/`, `Cmd-K`, mode-pill click) all work

### 1.2 Stress-tested hands
- [ ] All interactive elements ≥ 44 × 44 px
- [ ] No precision gestures (drag, pinch, long-press) without a tap-only fallback
- [ ] Undo / back available within one tap
- [ ] No critical action behind a hover state

### 1.3 Environmental visibility
- [ ] Light theme legible in bright sunlight (≥ 7:1 body text in hi-contrast)
- [ ] Dark theme legible at night with no glare
- [ ] No body text below 14 px
- [ ] Hi-contrast theme available, AAA contrast where possible

### 1.4 Mode indicator
- [ ] Persistent badge shows online/offline, voice on/off, theme, preset
- [ ] One tap opens settings
- [ ] Crisis mode visibly re-skins the surface

---

## 2. Voice interface

### 2.1 Wake word
- [ ] Wake-phrase detection rate ≥ 90% in quiet room
- [ ] False-positive rate ≤ 1% over 5 minutes of conversation
- [ ] Visual + audio feedback on wake
- [ ] Manual stop / start always available

### 2.2 Command recognition
- [ ] Speech-to-text accuracy logged (sampled) for tuning
- [ ] Confidence shown when low
- [ ] Recognition alternatives offered when ambiguous
- [ ] Manual correction (text edit + re-submit) always reachable

### 2.3 TTS output
- [ ] At least 4 voices selectable (male/female, regional accents)
- [ ] Rate / pitch / volume sliders
- [ ] System voice option (uses OS-native TTS)
- [ ] Stop / pause buttons during playback

### 2.4 Voice feedback
- [ ] "Heard you say: …" confirmation before destructive actions
- [ ] Visual + audio confirmation (orb pulse + sound)
- [ ] Reprompt is natural ("I didn't catch that — try again?")
- [ ] Voice help available by saying "what can I say"

### 2.5 Fallback
- [ ] Voice fails over to text/touch with no functional loss
- [ ] Text search always available (search bar visible at top of every nav surface)
- [ ] Menu navigation reachable without voice

---

## 3. Knowledge navigation

### 3.1 Search
- [ ] Fuzzy matching (typo-tolerant)
- [ ] Recent searches persist
- [ ] Suggestions appear as you type
- [ ] Voice input button next to search box

### 3.2 Browse
- [ ] All domain categories visible (or one tap away)
- [ ] Clear category labels (no jargon)
- [ ] Distinguishing icons or color treatments
- [ ] Live counts per category

### 3.3 Item cards
- [ ] Title prominent (≥ 18 px on mobile, ≥ 22 px on desktop)
- [ ] 2-3 line summary visible
- [ ] Click expands to detail
- [ ] Related items linked

### 3.4 Detail view
- [ ] Scannable format (headings, white space)
- [ ] Steps numbered
- [ ] Warnings boxed with `border-warn` color
- [ ] Do / don't sections clearly distinguished

---

## 4. Offline functionality

### 4.1 PWA installability
- [ ] Install prompt visible (manifest valid, served over HTTPS / localhost)
- [ ] Install works without internet after first launch
- [ ] App-like experience post-install (no browser chrome)

### 4.2 Service worker
- [ ] Cache covers app shell + critical routes
- [ ] Offline page loads
- [ ] Static assets cached cache-first
- [ ] Live data cached stale-while-revalidate

### 4.3 Offline indicator
- [ ] Visible offline status (in mode pill + somewhere persistent)
- [ ] "Working offline" banner appears on `navigator.offline`
- [ ] Stale-data indicator on lists

---

## 5. Alert systems

### 5.1 Status badges
- [ ] "Offline · all content cached"
- [ ] "Last updated · `<time>`"
- [ ] "Content available offline"

### 5.2 Warnings
- [ ] Low-storage warning when `navigator.storage.estimate()` shows ≥ 90% full
- [ ] Cache-cleared warning before destructive actions

---

## 6. PWA & install

### 6.1 Install banner
- [ ] Appears appropriately (after first meaningful interaction)
- [ ] Dismissible
- [ ] Remembers dismissal in `localStorage`

### 6.2 App experience
- [ ] Splash screen with brand mark
- [ ] Standalone mode hides browser chrome
- [ ] Status bar matches theme color

### 6.3 Offline mode
- [ ] Cached content browseable
- [ ] Search works against cached data
- [ ] Navigation works between cached routes

---

## 7. Accessibility (WCAG 2.1 AA)

### 7.1 Screen reader
- [ ] All content labeled (`aria-label` on icon-only buttons; `<label htmlFor>` on inputs)
- [ ] Landmark regions used (`<header>`, `<nav>`, `<main>`, `<aside>`, `<footer>`)
- [ ] Headings navigate (h1 → h2 → h3 in order)
- [ ] Live regions for alerts (`aria-live="polite"` / `"assertive"`)
- [ ] Status announced (e.g., "Searching", "5 results")

### 7.2 Keyboard
- [ ] Every feature reachable by keyboard
- [ ] Tab order matches visual order
- [ ] **Skip-to-main** link as first body element
- [ ] Focus visible on every focusable element

### 7.3 Contrast
- [ ] Body text ≥ 4.5 : 1
- [ ] UI element borders ≥ 3 : 1
- [ ] Validated in light, dark, and hi-contrast themes

### 7.4 Focus
- [ ] 2 px visible focus ring (3 px on hi-contrast)
- [ ] Focus not obscured by sticky elements
- [ ] Focus order logical
- [ ] No focus traps

### 7.5 Touch
- [ ] 44 × 44 px minimum
- [ ] Spacing ≥ 8 px between adjacent targets
- [ ] No hover-only interactions

### 7.6 Text scaling
- [ ] 200% browser zoom supported
- [ ] No horizontal scroll at 200%
- [ ] Reflow works at 320 px width

### 7.7 Motion
- [ ] `prefers-reduced-motion` zeros transitions
- [ ] No auto-play media
- [ ] Pause / stop available on any auto-advancing element

---

## 8. Responsive breakpoints

### 8.1 Mobile (375 px)
- [ ] Single column
- [ ] Bottom navigation
- [ ] Large touch targets
- [ ] Compact cards

### 8.2 Tablet (768 px)
- [ ] **Distinct** layout (not just unhidden mobile nav)
- [ ] Icon-only rail or 2-column hybrid
- [ ] Expanded cards

### 8.3 Desktop (1024 px)
- [ ] Multi-column
- [ ] Sidebar visible
- [ ] Dense display

### 8.4 Large (1440 px)
- [ ] Max-width containers (don't stretch text indefinitely)
- [ ] Side-by-side panels where useful

---

## 9. Performance

### 9.1 Load times
- [ ] First Contentful Paint ≤ 1.5 s on 4G mobile
- [ ] Time to Interactive ≤ 3 s
- [ ] Lazy loading for non-critical surfaces

### 9.2 Scrolling
- [ ] Smooth scroll (no jank) at 60 fps
- [ ] No layout shift during scroll

### 9.3 Voice latency
- [ ] Wake-to-ready ≤ 200 ms
- [ ] STT round-trip ≤ 800 ms
- [ ] TTS first-audio ≤ 300 ms

---

## 10. Domain coverage (e.g. 15 failure modes)

### 10.1 Coverage UI
- [ ] All N domain entities are reachable
- [ ] Quick switch between them
- [ ] Voice phrase per entity

### 10.2 Per-entity UI
- [ ] Current entity indicator
- [ ] Entity-specific content
- [ ] Entity-appropriate tone (urgent vs. instructional)

---

## 11. Content design

### 11.1 Item structure
- [ ] Title (clear, searchable, ≤ 64 chars)
- [ ] Summary (2-3 lines, ≤ 240 chars)
- [ ] Steps (numbered, imperative voice)
- [ ] Warnings (boxed)
- [ ] Resources (linked)

### 11.2 Voice-first format
- [ ] Short sentences (≤ 20 words)
- [ ] Numbered steps
- [ ] Clear imperatives ("Do X" not "X should be done")

### 11.3 Visual format
- [ ] Bullet points
- [ ] Bold key terms
- [ ] Boxed warnings with icon

---

## 12. Search & discovery

### 12.1 Full-text
- [ ] Title search
- [ ] Body search
- [ ] Tag search
- [ ] Fuzzy matching
- [ ] Recent queries

### 12.2 Voice search
- [ ] Natural-language input ("find water purification")
- [ ] Confirmation step
- [ ] Results displayed in same list as text search

### 12.3 Browse
- [ ] Category tree
- [ ] Alphabetical option
- [ ] Popular / Recent

---

## 13. Integration entry points

### 13.1 Inbound
- [ ] Sibling tools link in
- [ ] Deep links open the correct bead/route

### 13.2 Outbound
- [ ] Links to siblings preserved when offline (graceful)

---

## 14. Browser API integration

### 14.1 Voice input
- [ ] Web Speech API used where supported
- [ ] Fallback handling (text input always works)

### 14.2 Voice output
- [ ] SpeechSynthesis used
- [ ] Offline voices preferred

---

## 15. Error handling

### 15.1 Network errors
- [ ] Graceful offline mode
- [ ] Clear messages ("Working offline — using cached data")

### 15.2 Voice errors
- [ ] "Didn't catch that" reprompt
- [ ] Natural reprompt phrasing
- [ ] Fallback to text input

### 15.3 Content errors
- [ ] "Content unavailable offline" with cache status
- [ ] Refresh option

---

## 16. Settings

### 16.1 Voice
- [ ] Wake word
- [ ] Voice selection
- [ ] Rate / pitch / volume

### 16.2 Display
- [ ] Theme (light / dark / hi-contrast / system)
- [ ] Font size
- [ ] Contrast mode

### 16.3 Cache
- [ ] Cache size shown
- [ ] Clear cache
- [ ] Precache options

---

## 17. Emotional & trust design

### 17.1 Tone
- [ ] Calm vs. alarmist (no scary all-caps unless critical)
- [ ] Reassuring copy ("You can act on this without internet")
- [ ] Clear instructions

### 17.2 Reliability
- [ ] Offline trust signals
- [ ] Data-fresh indicator
- [ ] Last-sync time visible

### 17.3 Privacy
- [ ] Zero-knowledge claims made visible
- [ ] No tracking made transparent
- [ ] Sovereignty footer on every settings surface
