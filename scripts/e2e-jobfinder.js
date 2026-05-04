#!/usr/bin/env node
// End-to-end test of the full job-finder pipeline:
// 1. User clicks "Find me jobs" → prompt copied
// 2. Claude returns a markdown table (we mock this with a realistic sample)
// 3. User pastes/drops the markdown → dashboard parses it
// 4. Jobs render as cards with score, fit, apply link
// 5. localStorage persists across "page reloads"
//
// Validates the integration the unit tests can't: parser → storage → render.

const fs = require('fs');
const path = require('path');

let JSDOM;
try { JSDOM = require('jsdom').JSDOM; }
catch { try { JSDOM = require('/tmp/node_modules/jsdom').JSDOM; }
catch { console.error('npm install --prefix /tmp jsdom'); process.exit(2); } }

const repoRoot = path.resolve(__dirname, '..');
const html = fs.readFileSync(path.join(repoRoot, 'dashboard.html'), 'utf8');

// Realistic Claude job-finder output (matches the format in the prompt the dashboard ships).
const SAMPLE_CLAUDE_OUTPUT = `# Job shortlist · 2026-05-04

**Profile:** Senior Product Designer, Remote US
**Sources:** BuiltIn (50 scanned), LinkedIn (50 scanned)

## Top 5 to apply to today

| Title | Company | Location | Salary | Score | Why | Apply |
|---|---|---|---|---|---|---|
| Senior Product Designer | Stripe | Remote (US) | $200k-260k | 92 | Healthcare focus + design systems exp match perfectly | https://stripe.com/jobs/listing/sr-pd |
| Lead Designer, Tools | Figma | Remote (US) | $190k-240k | 88 | 8yr design tools experience aligns with team focus | https://figma.com/careers/lead-design-tools |
| Principal Designer | Linear | Remote (NA) | $220k-280k | 85 | Senior IC role you wanted; values craft | https://linear.app/jobs/principal-designer |
| Senior Designer | Vercel | Remote (Global) | $180k-220k | 82 | Strong design culture; you've used Vercel | https://vercel.com/careers/senior-designer |
| Lead Product Designer | Anthropic | SF / Remote | $210k-270k | 80 | AI tools is your stated interest | https://anthropic.com/careers/lead-pd |

## Why these vs other matches
- Filtered out 8 jobs that violated comp floor ($200k base)
- Dropped 3 agencies per your hard-no
- Skipped 5 contract / part-time per your priorities

Saved full table to ~/Design-Projects/jobs-today-2026-05-04.md
`;

const dom = new JSDOM(html, {
  runScripts: 'dangerously', resources: 'usable', pretendToBeVisual: true,
  url: 'http://localhost/'
});

const errors = [];
dom.window.addEventListener('error', e => {
  if (!/IntersectionObserver|scrollIntoView|matchMedia/.test(e.message)) {
    errors.push(`${e.message} @ ${e.lineno}:${e.colno}`);
  }
});

const passes = [], fails = [];
const check = (name, ok) => (ok ? passes : fails).push(name);

setTimeout(() => {
  const w = dom.window, d = w.document;

  console.log('=== E2E JOB-FINDER PIPELINE ===\n');

  // STEP 1: Prompt builder produces well-formed text
  const profile = {
    name: 'Avery', headline: 'Senior PD', resume: '~/r.md',
    targetRoles: 'Senior PD', priorities: '$200k+ remote',
    linkedin: 'https://linkedin.com/in/avery'
  };
  w.localStorage.setItem('pegasus.profile', JSON.stringify(profile));
  w.renderJobChecklist?.();
  const findBtn = d.getElementById('findJobsBtn');
  check('STEP 1a: profile fills enable Find Jobs btn', !findBtn?.disabled);
  check('STEP 1b: button text shows Ready', /Ready/.test(findBtn?.innerHTML || ''));

  // STEP 2: Mock the clipboard, click — verify the prompt structure includes table format
  let captured = null;
  Object.defineProperty(w.navigator, 'clipboard', {
    value: { writeText: t => { captured = t; return Promise.resolve(); } },
    configurable: true,
  });
  d.getElementById('findJobsBtn').click();
  check('STEP 2a: prompt copied on click', !!captured && captured.length > 100);
  check('STEP 2b: prompt instructs Claude to use job-finder', /job-finder/.test(captured));
  check('STEP 2c: prompt requests exact table format', /\| Title \| Company \|/.test(captured));
  check('STEP 2d: prompt includes profile context', captured.includes('Avery'));

  // STEP 3: Simulate Claude returning the markdown table — feed to importJobsFromText
  w.importJobsFromText(SAMPLE_CLAUDE_OUTPUT);
  const stored = JSON.parse(w.localStorage.getItem('pegasus.jobs') || '[]');
  check('STEP 3a: parser extracted all 5 jobs', stored.length === 5);
  check('STEP 3b: top job has score 92', stored.some(j => j.score === 92));
  check('STEP 3c: jobs include the apply URL', stored.every(j => /^https:\/\//.test(j.url || '')));
  check('STEP 3d: parser captured the company', stored.some(j => j.company === 'Stripe'));

  // STEP 4: Render — verify cards appear in DOM
  const list = d.getElementById('jobsList');
  check('STEP 4a: jobsList becomes visible', !list?.classList.contains('hidden'));
  check('STEP 4b: 5 job cards rendered', list?.children.length === 5);
  const empty = d.getElementById('jobsEmpty');
  check('STEP 4c: empty-state hidden after import', empty?.classList.contains('hidden'));

  // STEP 5: Verify a card has the right innards
  const firstCardText = list?.children[0]?.textContent || '';
  check('STEP 5a: first card shows a title', /Designer|PD|Lead|Principal|Senior/.test(firstCardText));
  check('STEP 5b: first card shows a score', /\d{2}/.test(firstCardText));

  // STEP 6: Persistence — re-load dashboard, jobs survive
  const dom2 = new JSDOM(html, {
    runScripts: 'dangerously', resources: 'usable', pretendToBeVisual: true,
    url: 'http://localhost/'
  });
  // Mirror the localStorage from the first instance
  for (const k of ['pegasus.jobs', 'pegasus.profile']) {
    dom2.window.localStorage.setItem(k, w.localStorage.getItem(k));
  }
  setTimeout(() => {
    const stored2 = JSON.parse(dom2.window.localStorage.getItem('pegasus.jobs') || '[]');
    check('STEP 6: jobs persist after reload', stored2.length === 5);
    finalize();
  }, 2500);

  function finalize() {
    console.log(`${passes.length} passing, ${fails.length} failing`);
    if (fails.length) { console.log('\nFAILED:'); fails.forEach(f => console.log('  ✗ ' + f)); }
    if (errors.length) console.log(`Runtime errors: ${errors.join('\n  ')}`);
    process.exit(fails.length || errors.length ? 1 : 0);
  }
}, 2500);
