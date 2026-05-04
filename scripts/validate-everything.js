#!/usr/bin/env node
// Validates that EVERY suggestion in the dashboard maps to real, executable code/file/URL.
// Run from repo root:  node scripts/validate-everything.js
//
// Checks:
// - Every template suggested → exists in templates/<name>/index.html
// - Every skill suggested → exists in skills/<name>/SKILL.md with matching frontmatter
// - Every CLI command → exists on PATH or is documented + valid
// - Every workflow ID → exists in templates/auto-mode/workflows.md
// - Every recommended repo → URL resolves (HEAD request)
// - Every cheatsheet doc → exists in docs/

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
// (jsdom not needed for validator — we parse with regex)

const repoRoot = path.resolve(__dirname, '..');
const html = fs.readFileSync(path.join(repoRoot, 'dashboard.html'), 'utf8');

const issues = [];
const passes = [];
const log = (ok, msg) => (ok ? passes : issues).push(msg);

// Parse data arrays from dashboard JS
function extractArray(name) {
  const m = html.match(new RegExp(`const ${name} = \\[([\\s\\S]*?)\\n\\];`));
  if (!m) return [];
  // Crude but works: find each `{ ... }` object literal
  const items = [];
  let depth = 0, start = -1;
  for (let i = 0; i < m[1].length; i++) {
    if (m[1][i] === '{') { if (depth === 0) start = i; depth++; }
    else if (m[1][i] === '}') { depth--; if (depth === 0) items.push(m[1].slice(start, i + 1)); }
  }
  return items;
}

function field(item, key) {
  const m = item.match(new RegExp(`${key}:\\s*'((?:[^'\\\\]|\\\\.)*)'`)) ||
            item.match(new RegExp(`${key}:\\s*"((?:[^"\\\\]|\\\\.)*)"`));
  return m ? m[1].replace(/\\'/g, "'").replace(/\\"/g, '"') : null;
}

console.log('═══════════════════════════════════════════════');
console.log('  PEGASUS EXHAUSTIVE VALIDATION');
console.log('═══════════════════════════════════════════════');

// === TEMPLATES ===
console.log('\n[Templates] Verifying each `pegasus new <type>` has a matching template folder...');
const templates = extractArray('templates');
templates.forEach(t => {
  const name = field(t, 'name');
  const cmd = field(t, 'cmd');
  const dir = path.join(repoRoot, 'templates', name);
  const idx = path.join(dir, 'index.html');
  const claudeMd = path.join(dir, 'CLAUDE.md');
  if (!fs.existsSync(dir)) {
    log(false, `  ✗ template '${name}': folder missing at templates/${name}/`);
  } else if (!fs.existsSync(idx)) {
    log(false, `  ✗ template '${name}': missing templates/${name}/index.html`);
  } else if (!fs.existsSync(claudeMd)) {
    log(false, `  ⚠ template '${name}': missing CLAUDE.md (works but docs are missing)`);
  } else {
    log(true, `  ✓ ${cmd} → templates/${name}/ (${fs.statSync(idx).size} bytes)`);
  }
});

// === SKILLS ===
console.log('\n[Skills] Verifying each skill has a matching SKILL.md with correct frontmatter...');
const skills = extractArray('skills');
skills.forEach(s => {
  const name = field(s, 'name');
  const dir = path.join(repoRoot, 'skills', name);
  const skillMd = path.join(dir, 'SKILL.md');
  if (!fs.existsSync(skillMd)) {
    log(false, `  ✗ skill '${name}': missing skills/${name}/SKILL.md`);
  } else {
    const content = fs.readFileSync(skillMd, 'utf8');
    const nameMatch = content.match(/^name:\s*(.+)$/m);
    if (!nameMatch || nameMatch[1].trim() !== name) {
      log(false, `  ✗ skill '${name}': frontmatter name mismatch (got '${nameMatch?.[1]?.trim()}')`);
    } else {
      log(true, `  ✓ ${name}`);
    }
  }
});

// === COMMANDS (sample check — validate pegasus subcommands actually exist in the helper) ===
console.log('\n[Commands] Verifying every `pegasus X` subcommand is in bin/pegasus dispatch...');
const cmds = extractArray('commands');
const pegasusScript = fs.readFileSync(path.join(repoRoot, 'bin/pegasus'), 'utf8');
cmds.forEach(c => {
  const cmd = field(c, 'cmd');
  if (!cmd || !cmd.startsWith('pegasus ')) {
    // Non-pegasus commands: check they exist on PATH (best effort)
    const bin = cmd?.split(/\s+/)[0];
    if (bin && bin.match(/^[a-z@]/)) {
      try {
        execSync(`command -v ${bin}`, { stdio: 'ignore' });
        log(true, `  ✓ ${cmd} (binary on PATH)`);
      } catch {
        // npx/installs are special — don't fail
        if (!['npx', 'magick', 'lighthouse', 'pa11y', 'svgo', 'potrace'].includes(bin)) {
          log(false, `  ⚠ ${cmd} → '${bin}' not on PATH (user may need to install)`);
        } else {
          log(true, `  ✓ ${cmd} (optional dep)`);
        }
      }
    } else {
      log(true, `  ✓ ${cmd} (slash/CLI command)`);
    }
    return;
  }
  const sub = cmd.split(/\s+/)[1];
  // Check that bin/pegasus has a case for this subcommand in its dispatch
  if (pegasusScript.includes(`  ${sub})`) || pegasusScript.includes(`${sub}|`) || pegasusScript.includes(`${sub})\t`) || pegasusScript.match(new RegExp(`^\\s*${sub}\\)\\s+`, 'm'))) {
    log(true, `  ✓ ${cmd} → bin/pegasus dispatches '${sub}'`);
  } else {
    log(false, `  ✗ ${cmd} → bin/pegasus has no '${sub}' handler`);
  }
});

// === WORKFLOWS ===
console.log('\n[Workflows] Verifying each W## ID exists in templates/auto-mode/workflows.md...');
const workflows = extractArray('workflows');
const wfDoc = fs.existsSync(path.join(repoRoot, 'templates/auto-mode/workflows.md'))
  ? fs.readFileSync(path.join(repoRoot, 'templates/auto-mode/workflows.md'), 'utf8')
  : '';
workflows.forEach(w => {
  const id = field(w, 'id');
  const name = field(w, 'name');
  if (wfDoc.includes(`### ${id} ·`) || wfDoc.includes(`### ${id} —`)) {
    log(true, `  ✓ ${id} · ${name}`);
  } else {
    log(false, `  ✗ ${id} '${name}': not found in workflows.md`);
  }
});

// === RECOMMENDED (URL existence — HEAD request) ===
console.log('\n[Recommended] Validating each repo URL resolves (HEAD)...');
const recommended = extractArray('recommended');
recommended.forEach(r => {
  const name = field(r, 'name');
  const clone = field(r, 'clone');
  const urlMatch = clone?.match(/https?:\/\/\S+/);
  if (!urlMatch) {
    log(true, `  ✓ ${name} (local command, no URL to verify)`);
    return;
  }
  const url = urlMatch[0].replace(/\.git\b/, '').replace(/[)\.]+$/, '');
  try {
    const result = execSync(`curl -sI -o /dev/null -w "%{http_code}" --max-time 5 "${url}"`, { encoding: 'utf8' }).trim();
    if (result === '200' || result === '301' || result === '302') {
      log(true, `  ✓ ${name} → ${url} (HTTP ${result})`);
    } else {
      log(false, `  ✗ ${name} → ${url} (HTTP ${result})`);
    }
  } catch (e) {
    log(false, `  ⚠ ${name} → couldn't HEAD (${e.message.slice(0, 50)})`);
  }
});

// === DOCS ===
console.log('\n[Cheatsheets] Verifying every doc referenced in install.sh exists...');
const installSh = fs.readFileSync(path.join(repoRoot, 'install.sh'), 'utf8');
const docRefs = [...installSh.matchAll(/PEGASUS_RAW\/(docs\/[^"\s]+)/g)].map(m => m[1]);
[...new Set(docRefs)].forEach(d => {
  const local = path.join(repoRoot, d);
  if (fs.existsSync(local)) {
    log(true, `  ✓ ${d}`);
  } else {
    log(false, `  ✗ ${d} not found in repo (install.sh would 404)`);
  }
});

// === SUMMARY ===
console.log('\n═══════════════════════════════════════════════');
console.log(`  RESULTS: ${passes.length} passing, ${issues.length} issues`);
console.log('═══════════════════════════════════════════════');
if (issues.length) {
  console.log('\nISSUES:');
  issues.forEach(i => console.log(i));
  process.exit(1);
}
console.log('\n✓ Every command, template, skill, workflow, recommended repo, and doc resolves.');
process.exit(0);
