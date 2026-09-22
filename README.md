# LUMINA 🎬

**« Tournez un livre. Diffusez un film. »**

Application PWA de LUMINA — votre roman devient un film, dans le style de votre choix.

> **Version `v1.0-demo`** — figée le 22 septembre 2026
> 100 % statique : HTML / CSS / JS purs. **Aucune dépendance, aucun build, aucun serveur.**
> Phase actuelle : interface complète et navigable. Le moteur de génération d'images n'est pas encore branché.

---

## 🆕 Nouveautés de cette version

| | Nouveauté |
|---|---|
| 🎨 | **7 directions artistiques avec vraie vignette de prévisualisation** — Peint classique, Néo-noir, Manga, Aquarelle, Ghibli-like, BD franco-belge, Gravure |
| 🖼️ | **16 visuels réels** : 9 jaquettes de livres + 7 vignettes de style, avec repli SVG automatique |
| 📚 | **Historique de lecture avec jaquette** (au lieu d'une icône générique) |
| ⚡ | **Architecture allégée** : `index.html` 184 Ko + `app.js` 99 Ko (au lieu d'un fichier unique de 6,7 Mo) |
| 🍎 | **4 packs d'export en langage courant** : 🍎 iPhone · 🤖 Partout · ✨ Parfait · 🎬 Le Film à partager |
| ♿ | **Accessibilité** : mode dyslexie, syllabation, vitesse de parole réglable |
| ⌨️ | **Raccourcis clavier** `/` recherche · `F` favoris · `Échap` effacer (actifs, affichage masqué) |
| 🔐 | **Preuve d'antériorité** (empreinte téléchargeable) + export RGPD de ses données |
| 📊 | **Analytics 100 % locales** — rien n'est envoyé nulle part |
| 🔄 | **Service worker mis à jour** : met désormais en cache `app.js` et les 16 images pour un vrai mode hors-ligne |

---

## Arborescence

```
lumina-pwa/
├── index.html              # l'application (8 écrans) — 184 Ko
├── app.js                  # toute la logique, ~130 fonctions — 99 Ko
├── covers/                 # 16 images : 9 jaquettes + 7 vignettes de style
├── icons/                  # icônes PWA 192 / 512 / 180
├── manifest.webmanifest    # manifest PWA (installation plein écran)
├── sw.js                   # service worker (lancement instantané + hors-ligne)
├── vercel.json             # configuration de déploiement Vercel
├── package.json            # scripts de dev locaux
├── .env.example            # variables Supabase (à venir, non utilisées)
├── .gitignore
└── README.md
```

⚠️ **`index.html` et `app.js` vont toujours ensemble.** L'application ne fonctionne pas si l'un des deux manque.

---

## 🔄 Mettre à jour un dépôt GitHub existant

Si vous aviez déjà déposé une version précédente :

```bash
# 1. Placez-vous dans votre dépôt local
cd chemin/vers/votre-depot

# 2. Remplacez les fichiers par ceux du ZIP
#    (décompressez le ZIP et copiez tout son contenu par-dessus)

# 3. Vérifiez ce qui a changé
git status

# 4. Publiez
git add -A
git commit -m "LUMINA v1.0-demo — 7 styles illustrés, historique avec jaquettes, architecture allégée"
git push
```

Vercel redéploie automatiquement au `push`.

### 📌 Deux points de vigilance

1. **`git add -A`** (et non `git add .`) : le `-A` enregistre aussi les **suppressions**. La version précédente contenait peut-être des fichiers volumineux désormais inutiles.
2. **Nouveaux dossiers** : `covers/` et le fichier `app.js` sont probablement absents de votre ancien dépôt. Vérifiez qu'ils apparaissent bien dans `git status`.

---

## Déployer sur Vercel (première fois)

1. Poussez ce dossier dans un dépôt GitHub.
2. Sur [vercel.com](https://vercel.com) → **Add New… → Project → Import** votre dépôt.
3. Vercel détecte un site statique : **aucun réglage** (pas de build command, pas d'output directory).
4. **Deploy.** Chaque `git push` sur `main` redéploie automatiquement.

### Variante — ligne de commande

```bash
npm i -g vercel
cd lumina-pwa
vercel --prod
```

---

## Tester en local

```bash
cd lumina-pwa
python3 -m http.server 3000
# puis ouvrir http://localhost:3000
```

⚠️ **Ouvrir `index.html` par double-clic ne suffit pas** : le navigateur bloque le chargement de `app.js` et des images en mode fichier. Il faut passer par un serveur, même local.

---

## ✅ Vérifier que le déploiement est bon

Une fois en ligne, contrôlez ces 5 points :

- [ ] La page d'accueil s'affiche, le bouton **« Entrer dans la salle »** fonctionne
- [ ] Écran **Tourner** : les 12 affiches de livres s'affichent en photo
- [ ] Écran **L'Atelier** → **Direction artistique** : les 7 styles montrent de **vraies images** (château peint, rue de nuit, manga, aquarelle, forêt, BD, gravure) — et non des carrés de couleur
- [ ] Le bouton **📲 Installer l'app** apparaît sur mobile
- [ ] Revenir à l'accueil : la ligne **Reprendre** affiche la **jaquette** du livre

Si les styles apparaissent en carrés de couleur : le dossier `covers/` n'a pas été poussé sur GitHub.

---

## Pourquoi HTTPS est essentiel

L'installation PWA (bouton 📲) et le service worker exigent le **HTTPS**. Vercel le fournit automatiquement.

---

## Cache & mises à jour

À chaque modification de `index.html` ou `app.js`, **incrémentez la version du cache** dans `sw.js` :

```js
const CACHE = 'lumina-v100';   // → 'lumina-v101', etc.
```

Sans cela, les téléphones déjà installés continueront d'afficher l'ancienne version.

---

## Supabase (à venir)

Rien n'est branché sur Supabase pour l'instant. Les données (favoris, notes, progression, statistiques) sont stockées **localement dans le navigateur**.

Quand le moteur sera connecté, Supabase servira pour l'**authentification**, le **stockage** des films et la **base de données** des projets. Les variables sont déjà prévues dans `.env.example`.

---

*LUMINA v1.0-demo — 22 septembre 2026 — 0 € d'infrastructure engagé*
