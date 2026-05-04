// Pegasus dashboard Tailwind build config.
// Outputs only the classes actually used in dashboard.html (HTML + inline JS).
// Build:  npm run build:css   (or)   npx tailwindcss@3.4.16 -c tailwind.config.js -i src/tailwind.input.css -o dashboard.css --minify
module.exports = {
  content: ['./dashboard.html'],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        serif: ['"Crimson Pro"', 'Georgia', 'serif'],
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['"JetBrains Mono"', 'ui-monospace', 'monospace'],
      },
    },
  },
  // Classes injected dynamically via JS that the JIT scanner can't always see.
  safelist: [
    'pulse-hint',
    'hidden-by-search',
    'hidden-by-track',
    'copied',
    'visible',
    'open',
    'scrolled',
    { pattern: /^(bg|text|border|ring)-(red|amber|green|blue|stone)-(50|100|200|300|400|500|600|700|800|900|950)$/ },
  ],
};
