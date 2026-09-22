# ☁️ GUIDE SUPABASE — LUMINA v1.3
### Activer les comptes et la synchronisation multi-appareils, gratuitement

> **Durée : environ 15 minutes** · **Coût : 0 €** · **Aucune carte bancaire demandée**
> ⚠️ **Cette étape est facultative.** Sans elle, LUMINA continue de fonctionner exactement comme avant, en mode local.

---

## 🎯 Ce que ça change

| | Sans compte (mode local) | Avec compte (v1.3) |
|---|---|---|
| Favoris, notes, progression | Sur **un seul appareil** | **Sur tous vos appareils** |
| Vider le cache du navigateur | ❌ Tout est perdu | ✅ Rien n'est perdu |
| Galerie | Votre liste à vous | **Galerie partagée** entre tous les utilisateurs |
| Changer de téléphone | ❌ On repart de zéro | ✅ On se reconnecte, tout revient |

---

## ⚠️ À savoir avant de commencer — en toute transparence

Le palier gratuit de Supabase est **réellement gratuit**, mais il a **une contrainte à connaître** :

> 🔔 **Un projet gratuit est mis en pause après 7 jours sans aucune activité.**
> Il se réveille en un clic depuis le tableau de bord, sans perte de données. Mais si personne n'utilise l'application pendant une semaine, la connexion échouera jusqu'au réveil.

**Les limites du palier gratuit :**

| Ressource | Limite gratuite | Ce que ça représente pour LUMINA |
|---|---|---|
| Base de données | 500 Mo | ~50 000 utilisateurs de données personnelles |
| Utilisateurs actifs | 50 000 / mois | Largement au-delà d'un lancement |
| Projets gratuits | 2 maximum | Un pour les tests, un pour la production |
| Mise en pause | après 7 jours d'inactivité | Réveil manuel en un clic |

**Mon conseil honnête :** c'est parfait pour valider le produit et accueillir vos premiers utilisateurs. Le jour où l'application tourne vraiment, le passage au palier payant (~25 $/mois) supprime la mise en pause. Mais on n'y est pas.

---

## 📝 Étape 1 — Créer le projet (5 min)

1. Aller sur **[supabase.com](https://supabase.com)** → **Start your project**
2. Se connecter avec GitHub (le plus simple)
3. **New project** :
   - **Name** : `lumina`
   - **Database Password** : générez-en un et **conservez-le** (vous n'en aurez pas besoin pour LUMINA, mais ne le perdez pas)
   - **Region** : **Frankfurt (eu-central-1)** — le plus proche de la France, et vos données restent dans l'Union européenne
   - **Plan** : **Free**
4. Cliquer **Create new project** puis patienter ~2 minutes

---

## 🗄️ Étape 2 — Créer les tables (2 min)

1. Dans le menu de gauche : **SQL Editor** → **New query**
2. Ouvrir le fichier **`supabase-schema.sql`** (fourni dans le ZIP)
3. **Copier tout son contenu**, le coller dans l'éditeur
4. Cliquer **Run** (ou Ctrl+Entrée)

✅ **Résultat attendu** : un tableau de 2 lignes s'affiche en bas —

| tablename | RLS activée |
|---|---|
| gallery | true |
| lumina_data | true |

> 🔐 **`RLS activée = true` est le point le plus important.** RLS (Row Level Security) garantit que chaque utilisateur ne peut lire et modifier **que ses propres données**, même si quelqu'un récupère la clé publique. Si vous voyez `false`, relancez le script.

---

## 🔑 Étape 3 — Récupérer vos deux clés (1 min)

1. Menu de gauche : **Project Settings** (l'engrenage) → **Data API**
2. Noter ces deux valeurs :

| Champ | Ressemble à | Où le trouver |
|---|---|---|
| **Project URL** | `https://abcdefgh.supabase.co` | En haut de la page |
| **anon public** | `eyJhbGciOiJIUzI1NiIs...` (très longue) | Section *Project API keys* |

> 🛑 **N'utilisez JAMAIS la clé `service_role`.** Elle contourne toutes les protections. La clé `anon` est conçue pour être publique dans un navigateur — c'est RLS qui protège les données.

---

## ⚙️ Étape 4 — Connecter LUMINA (2 min)

**Deux méthodes. La première est recommandée.**

### Méthode A — Fichier de configuration *(pour tous vos utilisateurs)*

1. Dans le dossier `lumina-pwa/`, **copier** `config.example.js` en **`config.js`**
2. Y remplacer les deux valeurs :

```js
window.LUMINA_CONFIG = {
  url:     'https://abcdefgh.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIs...'
};
```

3. Publier :

```bash
git add -A
git commit -m "LUMINA v1.3 — comptes et synchronisation Supabase"
git push
```

✅ Le formulaire de connexion apparaît automatiquement pour tout le monde.

### Méthode B — Saisie dans l'application *(pour tester rapidement)*

Ouvrir **Outils → Mon compte**, coller l'URL et la clé, cliquer **☁️ Connecter mon projet**. La configuration reste sur votre appareil uniquement.

---

## ✉️ Étape 5 — Réglage des e-mails (1 min, recommandé)

Par défaut, Supabase envoie un e-mail de confirmation à chaque inscription. **Pour vos premiers tests, désactivez-le** :

**Authentication → Sign In / Providers → Email** → décocher **Confirm email** → **Save**

Vous pourrez le réactiver avant l'ouverture au public.

> 📧 Le palier gratuit limite les e-mails automatiques à environ **2 par heure**. Pour un vrai lancement, il faudra brancher un service d'envoi (Resend a aussi un palier gratuit).

---

## ✅ Étape 6 — Vérifier que tout marche

| # | Action | ✅ Résultat attendu |
|---|---|---|
| 1 | **Outils → Mon compte** | Un formulaire e-mail + mot de passe s'affiche (plus le message « mode local ») |
| 2 | Saisir un e-mail et un mot de passe (6 caractères min.) → **Créer un compte** | Message « ✅ Compte créé », la pastille passe au **vert** |
| 3 | Mettre un ♡ sur un livre, puis cliquer **🔄 Synchroniser** | Message « ✅ Synchronisé » |
| 4 | Dans Supabase : **Table Editor → lumina_data** | Vos lignes apparaissent, avec votre `user_id` |
| 5 | **Ouvrir le site sur votre téléphone**, se connecter avec le même compte | ⭐ **Le test décisif** : vos favoris sont là |
| 6 | **Diffuser → Publier dans la galerie** | Badge « 🌍 galerie partagée », visible depuis vos autres appareils |
| 7 | **Déconnexion** | Vos données restent visibles sur l'appareil (mode local) |

---

## 🆘 En cas de problème

| Message | Cause | Solution |
|---|---|---|
| `Invalid login credentials` | Mauvais mot de passe, ou compte non confirmé | Vérifier, ou désactiver *Confirm email* (étape 5) |
| `Failed to fetch` | Projet en pause, ou URL erronée | Réveiller le projet dans le tableau de bord ; vérifier l'URL |
| `new row violates row-level security` | Le script SQL n'a pas été exécuté entièrement | Relancer `supabase-schema.sql` en entier |
| Le formulaire n'apparaît pas | `config.js` absent du dépôt | Vérifier qu'il est bien poussé (il **doit** être versionné) |
| `relation "lumina_data" does not exist` | Tables non créées | Refaire l'étape 2 |

---

## 🔒 Note de sécurité

**La clé `anon` est publique — c'est normal et voulu.** N'importe qui peut la lire dans le code source de la page. Ce qui protège vos données, ce sont les **règles RLS** créées à l'étape 2 :

- `lumina_data` : chacun ne lit et n'écrit **que ses propres lignes** (`auth.uid() = user_id`)
- `gallery` : **lecture publique** (c'est une vitrine), mais on ne peut publier qu'en son propre nom

C'est exactement le modèle utilisé par Supabase en production. **La seule clé à ne jamais exposer est `service_role`.**

---

*LUMINA v1.3.1 — 22 septembre 2026 — 83/83 contrôles automatiques au vert*
