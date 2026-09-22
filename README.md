# LUMINA 🎬

**« Tournez un livre. Diffusez un film. »**

Application PWA de LUMINA — votre roman devient un film, dans le style de votre choix.

> **Version `v1.4`** — 22 septembre 2026
> 100 % statique : HTML / CSS / JS purs. **Aucune dépendance, aucun build.**
> **Backend optionnel** : comptes et synchronisation multi-appareils via Supabase (palier gratuit). Sans configuration, l'app reste intégralement locale et hors-ligne.
> Le moteur de génération d'images n'est pas encore branché.

---

## 🆕 Nouveautés v1.4 (0 €)

| Fonction | Ce que ça change |
|---|---|
| 📦 **Coffre à films** | Conservez vos films en ligne, récupérez-les depuis n'importe quel appareil |
| 📊 **Quota visible** | Barre de progression : espace utilisé / 50 Mo offerts |
| 🛡️ **Double garde-fou** | Limite appliquée côté app **et** côté serveur (déclencheur PostgreSQL) |
| 🔐 **Coffre privé** | 4 règles : personne n'accède au dossier d'un autre |

**Installation (~5 min) :** exécuter `supabase-storage.sql` — voir `GUIDE_STOCKAGE_v1.4.md`

> ⚠️ **Le trafic sortant (5 Go/mois) est la vraie limite**, pas l'espace. Un film de 30 Mo téléchargé 170 fois épuise le quota mensuel. À surveiller dans Supabase → Reports.

---

## Nouveautés v1.3 (0 €)

| Fonction | Ce que ça change |
|---|---|
| ☁️ **Comptes utilisateurs** | Inscription, connexion, lien magique par e-mail |
| 🔄 **Synchronisation multi-appareils** | Favoris, notes et progression suivent l'utilisateur — **validé sur 2 appareils** |
| 🌍 **Galerie partagée** | Table commune à tous les utilisateurs, lecture publique |
| 🔐 **Row Level Security** | 8 politiques : chacun n'accède qu'à ses propres données |

**Activation (facultative, ~15 min, 0 €) :** voir `GUIDE_SUPABASE_v1.3.md`
1. Créer un projet sur [supabase.com](https://supabase.com) (palier gratuit, sans carte bancaire)
2. Exécuter `supabase-schema.sql` dans le SQL Editor
3. Copier `config.example.js` en `config.js` et y mettre vos deux clés

> ⚠️ `config.js` **doit être versionné** pour que Vercel le déploie. La clé `anon` est publique par conception ; ce sont les règles RLS qui protègent les données. Ne jamais exposer la clé `service_role`.
> ⚠️ Un projet Supabase gratuit est **mis en pause après 7 jours sans activité** (réveil en un clic, aucune perte).

---

## Nouveautés v1.2 (0 €)

| | Nouveauté |
|---|---|
| 🌍 | **Interface en 3 langues** — Français / English / Español, bouton `FR` en haut à droite, préférence mémorisée. 45 libellés traduits, la voix off suit la langue choisie. |
| 🖼️ | **Galerie publique** — publiez vos livres-films, retrouvez-les dans une liste avec jaquette, style et compteur de vues. Un clic rouvre le film. |
| 📖 | **Lecture guidée** — le texte se surligne **mot à mot** pendant la lecture vocale, avec 3 vitesses (0,7× / 1× / 1,3×). Pensé pour l'apprentissage de la lecture et les lecteurs dyslexiques. |

---

## Nouveautés v1.1 — 5 innovations TIER A (0 €)

| | Nouveauté |
|---|---|
| 📣 | **Kit marketing en un clic** — ZIP contenant une affiche 1080×1350 (Instagram), un visuel 1080×1920 (TikTok/Reels), votre 4ᵉ de couverture, 3 posts prêts à publier et un pitch de 30 s. Images générées à la volée depuis la jaquette du livre. |
| 🎁 | **Mode cadeau** — offrir un livre-film par SMS, WhatsApp ou e-mail, avec un message tout prêt |
| ⏱️ | **Minuteur de lecture** — « 43 min de film · 1 h 14 en audio », calculé selon le nombre de chapitres |
| ☀️🌙 | **Thème clair / sombre** — bascule en haut à droite, mémorisée |
| 🏷️ | **Numéro de version affiché** dans les outils |

---

## Nouveautés v1.0

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
git commit -m "LUMINA v1.3.1 — comptes Supabase, synchronisation multi-appareils, galerie partagée"
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
- [ ] **v1.1** — Écran **Diffuser** : bouton **📣 Télécharger le kit complet** → un ZIP de 5 fichiers arrive
- [ ] **v1.1** — Bouton **☀️/🌙** en haut à droite : bascule clair/sombre, conservée après rechargement
- [ ] **v1.2** — Bouton **FR** en haut à droite : bascule FR → EN → ES, les titres changent de langue
- [ ] **v1.2** — Écran **La pellicule** : carte **Lecture guidée**, le texte se surligne mot à mot
- [ ] **v1.2** — Écran **Diffuser** : **Publier dans la galerie**, le film apparaît dans la liste

Si les styles apparaissent en carrés de couleur : le dossier `covers/` n'a pas été poussé sur GitHub.

---

## Pourquoi HTTPS est essentiel

L'installation PWA (bouton 📲) et le service worker exigent le **HTTPS**. Vercel le fournit automatiquement.

---

## Cache & mises à jour

À chaque modification de `index.html` ou `app.js`, **incrémentez la version du cache** dans `sw.js` :

```js
const CACHE = 'lumina-v140';   // → 'lumina-v121', etc.
```

Sans cela, les téléphones déjà installés continueront d'afficher l'ancienne version.

---

## Supabase (à venir)

Rien n'est branché sur Supabase pour l'instant. Les données (favoris, notes, progression, statistiques) sont stockées **localement dans le navigateur**.

Quand le moteur sera connecté, Supabase servira pour l'**authentification**, le **stockage** des films et la **base de données** des projets. Les variables sont déjà prévues dans `.env.example`.

---

*LUMINA v1.2 — 22 septembre 2026 — 0 € d'infrastructure engagé*
