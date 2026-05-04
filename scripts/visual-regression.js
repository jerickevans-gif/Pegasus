#!/usr/bin/env node
// Playwright visual regression — captures dashboard.html at 3 viewports
// (mobile, tablet, desktop) and compares to baselines under tests/baselines/.
//
// First run: creates baselines and exits 0.
// Subsequent runs: compares; exits 1 if any pixel diff > tolerance.
//
// Usage:
//   node scripts/visual-regression.js            # compare against baselines
//   node scripts/visual-regression.js --update   # rewrite all baselines
//
// Requires: npm install --no-save playwright pixelmatch pngjs

const fs = require('fs');
const path = require('path');

let chromium, PNG, pixelmatch;
try {
  ({ chromium } = require('playwright'));
  PNG = require('pngjs').PNG;
  pixelmatch = require('pixelmatch');
} catch (e) {
  console.error('Missing deps. Install with:');
  console.error('  npm install --no-save playwright pixelmatch pngjs');
  console.error('  npx playwright install chromium');
  process.exit(2);
}

const repoRoot = path.resolve(__dirname, '..');
const dashboardPath = path.join(repoRoot, 'dashboard.html');
const baselineDir = path.join(repoRoot, 'tests', 'baselines');
const diffDir = path.join(repoRoot, 'tests', 'diffs');
fs.mkdirSync(baselineDir, { recursive: true });
fs.mkdirSync(diffDir, { recursive: true });

const update = process.argv.includes('--update');
const TOLERANCE_PCT = 1.0; // % of pixels allowed to differ

const viewports = [
  { name: 'mobile',  width: 375,  height: 700 },
  { name: 'tablet',  width: 768,  height: 900 },
  { name: 'desktop', width: 1280, height: 900 },
];

(async () => {
  const browser = await chromium.launch();
  let pass = 0, fail = 0, baselineWritten = 0;

  for (const vp of viewports) {
    const ctx = await browser.newContext({ viewport: { width: vp.width, height: vp.height } });
    const page = await ctx.newPage();
    await page.goto('file://' + dashboardPath);
    await page.waitForTimeout(2000); // let renderers populate
    const shotPath = path.join(baselineDir, `${vp.name}-current.png`);
    const basePath = path.join(baselineDir, `${vp.name}.png`);
    await page.screenshot({ path: shotPath, fullPage: false });
    await ctx.close();

    if (update || !fs.existsSync(basePath)) {
      fs.copyFileSync(shotPath, basePath);
      baselineWritten++;
      console.log(`  📸 baseline written: ${vp.name}`);
      continue;
    }

    const a = PNG.sync.read(fs.readFileSync(basePath));
    const b = PNG.sync.read(fs.readFileSync(shotPath));
    if (a.width !== b.width || a.height !== b.height) {
      console.log(`  ✗ ${vp.name}: size mismatch (baseline ${a.width}x${a.height}, current ${b.width}x${b.height})`);
      fail++;
      continue;
    }
    const diff = new PNG({ width: a.width, height: a.height });
    const numDiff = pixelmatch(a.data, b.data, diff.data, a.width, a.height, { threshold: 0.1 });
    const pct = (numDiff / (a.width * a.height)) * 100;
    if (pct <= TOLERANCE_PCT) {
      console.log(`  ✓ ${vp.name}: ${pct.toFixed(2)}% diff (within ${TOLERANCE_PCT}%)`);
      pass++;
    } else {
      const diffPath = path.join(diffDir, `${vp.name}-diff.png`);
      fs.writeFileSync(diffPath, PNG.sync.write(diff));
      console.log(`  ✗ ${vp.name}: ${pct.toFixed(2)}% diff (> ${TOLERANCE_PCT}%) — see ${diffPath}`);
      fail++;
    }
  }

  await browser.close();
  console.log();
  if (baselineWritten > 0) {
    console.log(`✓ Wrote ${baselineWritten} baseline(s). Re-run to verify nothing changes.`);
  }
  console.log(`Visual regression: ${pass} passing, ${fail} failing`);
  process.exit(fail > 0 ? 1 : 0);
})().catch(e => { console.error(e); process.exit(2); });
