# LUMINA 🎬

**« Tournez un livre. Diffusez un film. »**

Prototype d'interface PWA de LUMINA — votre roman devient un film, dans le style de votre choix.

> **Phase actuelle** : interface uniquement (ni LLM, ni stockage, ni serveur).
> L'app est 100 % statique : HTML / CSS / JS purs, **aucune dépendance, aucun build**.

---

## Arborescence

```
lumina-pwa/
├── index.html              # l'application complète (9 livres, 7 écrans, bande-annonce)
├── manifest.webmanifest    # manifest PWA (installation plein écran)
├── sw.js                   # service worker (lancement instantané + hors-ligne)
├── icons/                  # icônes 192 / 512 / 180
├── vercel.json             # configuration de déploiement Vercel
├── package.json            # scripts de dev locaux
├── .env.example            # variables Supabase (à venir, non utilisées pour l'instant)
├── .gitignore
└── README.md
```

---

## Déployer sur Vercel (via GitHub)

### Option 1 — Connexion GitHub (recommandée)

1. Pousse ce dossier dans un dépôt GitHub :

```bash
cd lumina-pwa
git init
git add .
git commit -m "LUMINA — interface PWA"
git branch -M main
git remote add origin https://github.com/VOTRE_COMPTE/lumina.git
git push -u origin main
```

2. Sur [vercel.com](https://vercel.com) → **Add New… → Project → Import** votre dépôt.
3. Vercel détecte automatiquement un site statique (aucun réglage requis : pas de build command, pas d'output directory).
4. **Deploy.** Chaque `git push` sur `main` redéploie automatiquement l'app.

### Option 2 — CLI Vercel

```bash
npm i -g vercel
cd lumina-pwa
vercel          # aperçu
vercel --prod   # production
```

### Option 3 — Glisser-déposer

Glissez le dossier `lumina-pwa` sur [vercel.com](https://vercel.com) (New Project → drag & drop). Simple, mais sans auto-déploiement depuis GitHub.

---

## Pourquoi HTTPS est essentiel

L'installation PWA (bouton 📲) et le service worker exigent le **HTTPS**.
Vercel le fournit automatiquement — c'est pour cela qu'on héberge là plutôt qu'en local.

---

## Supabase (à venir)

La phase actuelle est 100 % interface : **rien n'est branché sur Supabase pour l'instant.**

Quand on connectera le moteur (génération des scènes + stockage des films MP4), Supabase servira pour :

- **Auth** — comptes utilisateurs ;
- **Storage** — stockage des films MP4 et des livres ;
- **Database** — les projets (livre, style, format, statut du tournage).

Les variables sont déjà prévues dans `.env.example`
(`VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`) — prêtes à remplir le moment venu.

---

## En local

```bash
cd lumina-pwa
python3 -m http.server 3000
# puis ouvrir http://localhost:3000
```

---

## Mise à jour & cache

Quand vous modifiez `index.html`, pensez à **incrémenter la version du cache** dans `sw.js` :

```js
const CACHE = 'lumina-v2';   // → 'lumina-v3', etc.
```

Cela force les téléphones à recharger la nouvelle version au prochain lancement.
