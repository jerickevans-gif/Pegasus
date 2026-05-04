#!/usr/bin/env node
// Validates a profile JSON file against profile.schema.json.
// Lightweight (no ajv dep) — checks the structural rules we actually care about.
//
// Usage:  node scripts/validate-profile.js path/to/profile.json
//         node scripts/validate-profile.js          (uses example from schema)

const fs = require('fs');
const path = require('path');

const schemaPath = path.resolve(__dirname, '..', 'profile.schema.json');
const schema = JSON.parse(fs.readFileSync(schemaPath, 'utf8'));

let target = process.argv[2];
let profile;
if (target) {
  profile = JSON.parse(fs.readFileSync(target, 'utf8'));
} else {
  profile = schema.examples[0];
  target = '(example from schema)';
}

const errors = [];
function check(name, ok, msg) { if (!ok) errors.push(`${name}: ${msg}`); }

// 1. Top-level type
check('root', typeof profile === 'object' && !Array.isArray(profile), 'must be an object');

// 2. Each known field has correct type
for (const [key, def] of Object.entries(schema.properties)) {
  if (!(key in profile)) continue;
  const v = profile[key];
  if (def.type === 'string') {
    check(key, typeof v === 'string', `expected string, got ${typeof v}`);
  }
  if (def.format === 'email' && typeof v === 'string' && v) {
    check(key, /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v), `not a valid email: ${v}`);
  }
  if (def.format === 'uri' && typeof v === 'string' && v) {
    try { new URL(v); }
    catch { check(key, false, `not a valid URL: ${v}`); }
  }
}

// 3. Warn (not fail) on unknown keys — the dashboard tolerates extras
const unknown = Object.keys(profile).filter(k => !(k in schema.properties));

console.log(`Profile: ${target}`);
console.log(`Fields:  ${Object.keys(profile).length} (${Object.keys(schema.properties).length} known in schema)`);
if (unknown.length) console.log(`Unknown (allowed): ${unknown.join(', ')}`);

if (errors.length === 0) {
  console.log('✓ Profile is valid');
  process.exit(0);
} else {
  console.error('✗ Profile has errors:');
  errors.forEach(e => console.error('  ' + e));
  process.exit(1);
}
