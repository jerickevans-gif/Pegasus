// Pegasus Dashboard service worker
// Versioned cache so new dashboard releases force-refresh without manual reload.
// Bump CACHE_VERSION when shipping a meaningful dashboard change.

const CACHE_VERSION = 'pegasus-v6-2026-05-03';
const ASSETS = [
  './dashboard.html',
  './manifest.webmanifest',
  './favicon.svg',
  'https://cdn.tailwindcss.com/3.4.16',
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE_VERSION).then(c => c.addAll(ASSETS).catch(() => null)));
  self.skipWaiting();  // immediately replace old SW
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_VERSION).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())  // take over open tabs
  );
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  // Network-first for the dashboard HTML so users always get latest on reload
  if (e.request.url.endsWith('dashboard.html') || e.request.url.endsWith('/')) {
    e.respondWith(
      fetch(e.request).then(res => {
        const copy = res.clone();
        caches.open(CACHE_VERSION).then(c => c.put(e.request, copy)).catch(() => null);
        return res;
      }).catch(() => caches.match(e.request))
    );
    return;
  }
  // Cache-first for other assets (CDN, fonts)
  e.respondWith(
    caches.match(e.request).then(hit => hit || fetch(e.request).then(res => {
      const copy = res.clone();
      caches.open(CACHE_VERSION).then(c => c.put(e.request, copy)).catch(() => null);
      return res;
    }))
  );
});
