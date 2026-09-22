# 📦 STOCKAGE DES FILMS — LUMINA v1.4
### Conserver ses films en ligne et les retrouver partout — toujours 0 €

> **Durée d'installation : ~5 min** · **Coût : 0 €** · **Prérequis : la v1.3 doit être installée**
> C'est la **dernière brique gratuite** du plan. Après elle, tout ce qui reste engage de l'argent.

---

## 🎯 Ce que ça apporte

Jusqu'ici, un film produit était **téléchargé et perdu** : rien ne le reliait au compte. Désormais il vit dans un coffre personnel, accessible depuis n'importe quel appareil.

| | Avant | Avec la v1.4 |
|---|---|---|
| Un film terminé | Téléchargé, puis oublié | **Conservé dans votre coffre** |
| Changer d'appareil | Film perdu | **Vous le retrouvez et le retéléchargez** |
| Espace occupé | — | **Affiché en clair**, avec une barre de progression |

---

## ⚠️ Les limites, dites franchement

Le stockage est **la ressource la plus vite consommée** du palier gratuit. J'ai donc posé des garde-fous **avant** qu'un dépassement ne survienne.

| Ressource | Limite gratuite | Garde-fou posé |
|---|---|---|
| Espace total | **1 Go** | 50 Mo par personne → ~20 comptes |
| Taille d'un fichier | 50 Mo imposés | **40 Mo** bloqués côté app **et** serveur |
| **Trafic sortant** | **5 Go/mois** | ⚠️ **La vraie limite** — voir ci-dessous |

### 🔔 Le piège à connaître : le trafic sortant (egress)

Ce n'est pas l'espace qui vous fera basculer en payant, c'est le **téléchargement**. Chaque récupération d'un film consomme du trafic sortant.

> **Exemple concret** : un film de 30 Mo téléchargé 170 fois = **5 Go** → quota mensuel épuisé.

Le stockage se remplit lentement ; le trafic, lui, se consomme à chaque clic. **Surveillez-le dans Supabase → Reports → Egress.**

---

## 📝 Installation (5 min)

1. Supabase → **SQL Editor** → **New query**
2. Copier tout le contenu de **`supabase-storage.sql`**, coller, **Run**

✅ **Trois résultats doivent s'afficher :**

| Vérification | Attendu |
|---|---|
| (a) Le coffre | `films` · **public = false** · 40 MB |
| (b) La table | `films` · **RLS activée = true** |
| (c) Consommation | `0 fichiers · 0 bytes · 0 %` |

> 🔐 **`public = false` est essentiel.** Un coffre public rendrait tous les films téléchargeables par n'importe qui, sans compte.

---

## 🛡️ Comment vos films sont protégés

Chaque fichier est rangé sous l'identifiant de son propriétaire :

```
films/
  a1b2c3.../ 1790098730565_monte-cristo.zip   ← utilisateur A
  d4e5f6.../ 1790098812043_dracula.m4b        ← utilisateur B
```

Quatre règles vérifient que le premier dossier correspond bien à la personne connectée. **Un utilisateur ne peut ni lire, ni écrire, ni supprimer dans le dossier d'un autre** — ce n'est pas une vérification de l'application (contournable), c'est une règle du serveur.

**Double garde-fou sur le quota :** l'application refuse l'envoi au-delà de 50 Mo *et* un déclencheur PostgreSQL rejette l'insertion côté serveur. Un contrôle navigateur seul se contourne ; celui-ci non.

---

## ✅ Vérification en 7 gestes

| # | Action | ✅ Attendu |
|---|---|---|
| 1 | Outils → carte **📦 Mes films conservés** | Barre de quota, « Votre coffre est vide » |
| 2 | Terminer un film → **☁️ Conserver ce film** | « ✅ Film conservé dans votre coffre » |
| 3 | Regarder la carte | Le film apparaît avec son poids et sa date |
| 4 | Supabase → **Storage → films** | Un dossier à votre identifiant, contenant le fichier |
| 5 | **Autre appareil**, même compte | ⭐ Le film est là, téléchargeable via ⬇️ |
| 6 | Cliquer 🗑️ | Demande de confirmation, puis disparition |
| 7 | Supabase → **Storage** | Le fichier a bien disparu |

---

## 📊 Surveiller la consommation

Dans le SQL Editor :

```sql
select * from public.storage_usage;
```

| nb_fichiers | nb_utilisateurs | espace_utilise | pct_du_gigaoctet |
|---|---|---|---|
| 12 | 3 | 84 MB | 8.2 % |

**Seuils d'alerte :**
- **50 %** → réfléchir à une politique de purge (ex. supprimer les films de plus de 90 jours)
- **80 %** → agir : purger, ou passer au palier Pro (~25 $/mois, 100 Go)
- **Egress > 4 Go/mois** → le vrai signal d'un lancement réussi… et d'un futur coût

---

## 🆘 En cas de problème

| Message | Cause | Solution |
|---|---|---|
| `Bucket not found` | Script non exécuté | Relancer `supabase-storage.sql` |
| `new row violates row-level security` | Règles absentes | Relancer le script en entier |
| `Quota dépassé : 50 Mo maximum` | Coffre plein | Supprimer un film (garde-fou serveur : normal) |
| « Fichier trop lourd » | Plus de 40 Mo | Limite volontaire, sous les 50 Mo imposés |
| `Payload too large` | Fichier > limite du coffre | Vérifier `file_size_limit` du bucket |

---

## 💡 Ce qui reste à décider après ça

Cette brique épuise le gratuit. Les suivantes coûtent :

| Poste | Coût |
|---|---|
| Paiement Stripe | ~1,5 % + 0,25 € par transaction |
| Nom de domaine | ~12 €/an |
| Supabase Pro | ~25 $/mois (supprime la pause de 7 jours, 100 Go) |
| Moteur de génération d'images | **Le poste lourd, à arbitrer** |

---

*LUMINA v1.4 — 22 septembre 2026 — 106/106 contrôles automatiques — **0 € engagé***
