#!/usr/bin/env node
// Tests every link, button, onclick handler in the dashboard.
// Plus tests the job-parsing logic with realistic input.

const fs = require('fs');
const path = require('path');
let JSDOM;
try { JSDOM = require('jsdom').JSDOM; }
catch { try { JSDOM = require('/tmp/node_modules/jsdom').JSDOM; }
catch { console.error('npm install --prefix /tmp jsdom'); process.exit(2); } }

const repoRoot = path.resolve(__dirname, '..');
const html = fs.readFileSync(path.join(repoRoot, 'dashboard.html'), 'utf8');

const dom = new JSDOM(html, {
  runScripts: 'dangerously', resources: 'usable', pretendToBeVisual: true,
  url: 'file://' + path.join(repoRoot, 'dashboard.html')
});

const errors = [];
dom.window.addEventListener('error', e => errors.push(`JS ERROR: ${e.message} @ ${e.lineno}:${e.colno}`));

const passes = [];
const fails = [];
const log = (ok, msg) => (ok ? passes : fails).push(msg);

setTimeout(() => {
  const w = dom.window;
  const d = w.document;

  console.log('=== LINK + BUTTON AUDIT ===\n');

  // 1. Every <a href> with non-empty href should be valid (http(s)://, javascript:, mailto:, or # anchor that exists)
  const links = [...d.querySelectorAll('a[href]')];
  const sectionIds = new Set([...d.querySelectorAll('[id]')].map(e => e.id));
  let goodAnchors = 0, badAnchors = 0;
  links.forEach(a => {
    const href = a.getAttribute('href');
    if (!href) return;
    if (href.startsWith('http')) {
      log(true, `external link OK: ${href.slice(0, 60)}`);
    } else if (href.startsWith('#')) {
      const id = href.slice(1);
      if (id && !sectionIds.has(id)) { log(false, `broken anchor: ${href}`); badAnchors++; }
      else { goodAnchors++; }
    } else if (href.startsWith('javascript:') || href.startsWith('mailto:') || href.startsWith('file:')) {
      log(true, `${href.split(':')[0]}: link OK`);
    } else if (href === '/') {
      log(true, 'root link OK');
    } else {
      log(false, `unusual href: ${href}`);
    }
  });
  console.log(`  ${goodAnchors} valid # anchors, ${badAnchors} broken`);
  console.log(`  ${links.filter(a => a.getAttribute('href')?.startsWith('http')).length} external links present\n`);

  // 2. Every button with onclick should evaluate without error
  const onclickEls = [...d.querySelectorAll('[onclick]')];
  console.log(`Testing ${onclickEls.length} onclick handlers...`);
  onclickEls.forEach((el, i) => {
    const code = el.getAttribute('onclick');
    try {
      // Just parse the function source to validate syntax
      new w.Function(code);
      log(true, `onclick #${i} parses`);
    } catch (e) {
      log(false, `onclick BROKEN: ${code.slice(0, 80)} → ${e.message}`);
    }
  });

  // 3. Test parseJobsMarkdown with realistic samples
  console.log('\n=== JOB PARSER ===\n');
  const samples = [
    {
      name: 'Standard table from job-finder skill',
      input: `# Job shortlist · 2026-05-03

**Profile:** Senior Product Designer, Remote US
**Sources:** BuiltIn (50 scanned), LinkedIn (50 scanned)

## Top 5 to apply to today

| Title | Company | Location | Salary | Score | Why | Apply |
|---|---|---|---|---|---|---|
| Senior Product Designer | Stripe | Remote (US) | $200k-260k | 92 | Healthcare + design systems match | https://stripe.com/jobs/senior-pd |
| Lead Designer | Figma | Remote (US) | $190k-240k | 88 | 7yr exp aligns; design tools is your space | https://figma.com/careers/lead-design |
| Principal Designer | Linear | Remote (NA) | $220k-280k | 85 | Senior IC role you wanted | https://linear.app/jobs |`,
      expectMin: 3,
    },
    {
      name: 'Variant: "Role · Company" combined header',
      input: `| Role · Company | Location | Score | Apply |
|---|---|---|---|
| Senior Designer · Acme | Remote | 78 | https://acme.com/jobs/123 |`,
      expectMin: 1,
    },
    {
      name: 'Empty input',
      input: '',
      expectMin: 0,
    },
    {
      name: 'Just text, no table',
      input: 'I looked at 50 jobs and none were a great fit. Try expanding your filters.',
      expectMin: 0,
    },
  ];

  // Need to invoke parseJobsMarkdown which lives in the dashboard JS
  const parse = w.parseJobsMarkdown;
  if (typeof parse !== 'function') {
    log(false, 'parseJobsMarkdown not exposed on window — can only test indirectly');
  } else {
    samples.forEach(s => {
      try {
        const result = parse(s.input);
        if (result.length >= s.expectMin) {
          log(true, `parser: ${s.name} → ${result.length} jobs`);
        } else {
          log(false, `parser: ${s.name} → got ${result.length}, expected ≥${s.expectMin}`);
        }
      } catch (e) {
        log(false, `parser threw on ${s.name}: ${e.message}`);
      }
    });
  }

  // 4. Verify modal structure works
  const modal = d.getElementById('workflowModal');
  log(!!modal, 'workflowModal element exists');
  log(!modal?.classList.contains('open'), 'workflowModal closed initially');

  // === SUMMARY ===
  console.log(`\n=== RESULTS ===`);
  console.log(`${passes.length} passing, ${fails.length} failing`);
  if (fails.length) { console.log('\nFAILURES:'); fails.forEach(f => console.log('  ✗ ' + f)); }
  const realErrors = errors.filter(e => !e.includes('IntersectionObserver') && !e.includes('scrollIntoView') && !e.includes('localStorage'));
  console.log(`\nRuntime JS errors: ${realErrors.length === 0 ? '✓ NONE' : realErrors.join(' | ')}`);
  process.exit(fails.length > 0 || realErrors.length > 0 ? 1 : 0);
}, 2500);
