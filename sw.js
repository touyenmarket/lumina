/* LUMINA — service worker : installation instantanée + hors-ligne
   v1.0-demo — 22/09/2026
   ⚠️ À CHAQUE MISE À JOUR : incrémenter CACHE ci-dessous (lumina-v100 → lumina-v101…)
      sinon les téléphones gardent l'ancienne version en cache. */
const CACHE = 'lumina-v130';

const ASSETS = [
  './',
  './index.html',
  './app.js',
  './manifest.webmanifest',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/icon-180.png',
  /* jaquettes des livres */
  './covers/monte_cristo.jpg',
  './covers/dracula.jpg',
  './covers/dame_camelias.jpg',
  './covers/mousquetaires.jpg',
  './covers/frankenstein.jpg',
  './covers/vingt_mille.jpg',
  './covers/moby_dick.jpg',
  './covers/ile_tresor.jpg',
  './covers/notre_dame.jpg',
  /* vignettes des 7 directions artistiques */
  './covers/style_peint_classique.jpg',
  './covers/style_neo_noir.jpg',
  './covers/style_manga.jpg',
  './covers/style_aquarelle.jpg',
  './covers/style_ghibli.jpg',
  './covers/style_bd.jpg',
  './covers/style_gravure.jpg'
];

self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open(CACHE)
      /* addAll échoue en bloc si un seul fichier manque : on met en cache un par un */
      .then(function (c) {
        return Promise.all(ASSETS.map(function (url) {
          return c.add(url).catch(function () { return null; });
        }));
      })
      .then(function () { return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function (e) {
  e.waitUntil(
    caches.keys()
      .then(function (keys) {
        return Promise.all(keys.filter(function (k) { return k !== CACHE; })
          .map(function (k) { return caches.delete(k); }));
      })
      .then(function () { return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function (e) {
  if (e.request.method !== 'GET') return;
  var url = new URL(e.request.url);
  if (url.origin !== self.location.origin) return;

  /* index.html et app.js : réseau d'abord (toujours la dernière version),
     cache en secours si hors-ligne */
  var isCore = url.pathname.endsWith('/') ||
               url.pathname.endsWith('/index.html') ||
               url.pathname.endsWith('/app.js');

  if (isCore) {
    e.respondWith(
      fetch(e.request).then(function (res) {
        var copy = res.clone();
        caches.open(CACHE).then(function (c) { c.put(e.request, copy); });
        return res;
      }).catch(function () {
        return caches.match(e.request).then(function (hit) {
          return hit || caches.match('./index.html');
        });
      })
    );
    return;
  }

  /* images, icônes, manifest : cache d'abord (rapide), réseau si absent */
  e.respondWith(
    caches.match(e.request).then(function (hit) {
      return hit || fetch(e.request).then(function (res) {
        var copy = res.clone();
        caches.open(CACHE).then(function (c) { c.put(e.request, copy); });
        return res;
      }).catch(function () {
        return caches.match('./index.html');
      });
    })
  );
});
