# ✅ VALIDATION LUMINA v1.3.1
### Checklist de recette — version opérationnelle multi-appareils

> **Durée : ~15 min** · **Statut : validée par l'utilisateur le 22/09/2026**
> Contrôles automatiques : **88/88** · Tests jsdom : **57 + 59 + 20**
> ⚠️ Avant de commencer : **forcer le rechargement** (`Ctrl`+`Maj`+`R`, ou `Cmd`+`Maj`+`R` sur Mac).

---

## 🅰️ BLOC A — Backend v1.3 *(les nouveautés)*

### A1 · Accès au panneau Outils *(corrigé en v1.3.1)*

| # | Action | ✅ Attendu |
|---|---|---|
| 1 | Accueil → cliquer **Outils** | Le panneau **se déroule** |
| 2 | Regarder le lien à droite | Il affiche **« Masquer ‹ »** |
| 3 | Recliquer | Le panneau se referme, le lien repasse à « Afficher › » |

> 🔴 **Si rien ne s'ouvre** : le navigateur a gardé l'ancienne version. Vider le cache.

### A2 · Création de compte

| # | Action | ✅ Attendu |
|---|---|---|
| 4 | Outils → carte **☁️ Mon compte** | Formulaire e-mail + mot de passe |
| 5 | Saisir un e-mail et un mot de passe (6 car. min.) → **Créer un compte** | « ✅ Compte créé », pastille **verte** |
| 6 | Dans Supabase : **Authentication → Users** | Votre compte apparaît |

> 🔴 **Si vous lisez « Mode local »** : `config.js` n'est pas en ligne. Ouvrir `votre-site.fr/config.js` — une erreur 404 confirme le problème.

### A3 · Synchronisation ⭐ *le test décisif*

| # | Action | ✅ Attendu |
|---|---|---|
| 7 | Mettre un ♡ sur un livre → **🔄 Synchroniser** | « ✅ Synchronisé » |
| 8 | Supabase : **Table Editor → lumina_data** | Vos lignes, avec votre `user_id` |
| 9 | **Ouvrir le site sur un autre appareil**, même compte | ⭐ **Vos favoris sont là** |
| 10 | Ajouter une note sur l'appareil B, synchroniser, recharger l'appareil A | La note apparaît |

### A4 · Galerie partagée

| # | Action | ✅ Attendu |
|---|---|---|
| 11 | Diffuser → **Publier dans la galerie** | Badge **🌍 galerie partagée** |
| 12 | Supabase : **Table Editor → gallery** | La ligne existe, signée de votre `user_id` |
| 13 | Consulter depuis l'autre appareil | La publication est visible |

### A5 · Sécurité et mode dégradé

| # | Action | ✅ Attendu |
|---|---|---|
| 14 | **Déconnexion** | « 👋 Déconnecté », données **toujours visibles** sur l'appareil |
| 15 | Se reconnecter | Tout revient |
| 16 | Supabase → **Table Editor → lumina_data** : colonne `RLS` | **Activée** sur les 2 tables |
| 17 | Passer l'appareil en mode avion, recharger | L'app fonctionne, aucune erreur bloquante |

---

## 🅱️ BLOC B — Non-régression v1.2

| # | Action | ✅ Attendu |
|---|---|---|
| 18 | Cliquer le bouton **langue** (🌐) | FR → EN → ES, toute l'interface suit |
| 19 | Recharger la page | La langue choisie est conservée |
| 20 | Écran « La pellicule » → **lecture guidée** | Les mots se surlignent un par un |
| 21 | Tester les 3 vitesses (0,7× / 1× / 1,3×) | Le rythme change |
| 22 | Écran « Diffuser » → galerie | Liste antéchronologique, compteur de vues |

---

## 🅲 BLOC C — Non-régression v1.0 / v1.1

| # | Action | ✅ Attendu |
|---|---|---|
| 23 | Parcours complet : choisir un livre → tourner → « Votre film est prêt 🎉 » | Aucun blocage |
| 24 | Les **7 vignettes de style** | Toutes visibles, aucune jaquette de livre |
| 25 | Les **4 packs** (🍎 🤖 ✨ 🎬) | Noms en langage simple, détail technique en second niveau |
| 26 | Bouton **thème** clair/sombre | Bascule et persiste |
| 27 | Raccourcis `/`, `F`, `Échap` | Fonctionnels (aide masquée, c'est voulu) |
| 28 | **Kit marketing**, carte cadeau, minuteur | Opérationnels |

---

## 🚨 Les 3 signaux d'alarme

| Signal | Cause probable | Action |
|---|---|---|
| **« Outils » n'ouvre rien** | Cache navigateur | Rechargement forcé, réinstaller la PWA |
| **« Mode local » alors que Supabase est configuré** | `config.js` non déployé | Vérifier `votre-site.fr/config.js` |
| **`Failed to fetch` à la connexion** | Projet Supabase **en pause** (7 j d'inactivité) | Le réveiller dans le tableau de bord |

---

## 📋 Fiche de résultat

```
Date : ____________   Navigateur : ____________
Appareil A : ____________   Appareil B : ____________

BLOC A (backend)         ___ / 17
BLOC B (v1.2)            ___ / 5
BLOC C (v1.0-v1.1)       ___ / 6
                        ─────────
TOTAL                    ___ / 28

Test décisif (n° 9, favoris sur 2 appareils) :  ☐ OK   ☐ KO
Anomalies : ________________________________________
```

---

## ✅ Résultat du 22/09/2026

> **Validé par l'utilisateur.** Test n° 9 confirmé : *« Les favoris apparaissent bien avec le même compte sur un appareil différent. »*
> Verdict : **cette version est opérationnelle.**

---

*LUMINA v1.3.1 — 22 septembre 2026 — 88/88 contrôles automatiques — **0 € engagé***
