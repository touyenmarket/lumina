# 🔧 CORRECTIF v1.3.1 — le bouton « Outils » n'ouvrait rien

## Ce que vous avez vu

Clic sur **Outils** → rien. Aucun déroulé, aucune erreur.

## Ce que c'était vraiment

**Votre installation Supabase n'y est pour rien — vos 5 étapes sont bonnes.**

C'est un bug **présent depuis la v1.0**, qui n'avait jamais été détecté. Il est resté invisible tant que le panneau « Outils » ne contenait que des statistiques secondaires. En y plaçant la carte **Mon compte**, il est devenu bloquant : la porte d'entrée de la connexion était derrière un bouton mort.

### Deux défauts superposés

**1. Un masquage impossible à lever**

Le panneau était masqué par une consigne écrite directement sur la balise :

```html
<div id="bottomTools" style="display:none;">
```

Le clic ajoutait bien la classe `on`, et la feuille de style disait `#bottomTools.on { display:block }`. Mais en CSS, **une consigne écrite sur la balise l'emporte toujours** sur une règle de feuille de style. Le panneau recevait l'ordre d'apparaître et l'ignorait, indéfiniment.

Corrigé en déplaçant l'état fermé dans la feuille de style, au même niveau :

```css
#bottomTools    { display:none;  }
#bottomTools.on { display:block; }
```

**2. Le mauvais lien mis à jour**

La fonction cherchait le libellé à basculer ainsi :

```js
document.querySelector("#s1 .row span.link")
```

Or l'écran d'accueil contient **trois** liens de ce type. Celui-ci renvoyait le premier — un « Tout voir › » de la bibliothèque. Même une fois le panneau réparé, le libellé serait resté figé sur « Afficher › ». Le lien porte désormais un identifiant propre, `btLink`.

---

## ✅ À faire de votre côté

**Une seule chose : forcer le rechargement**, car votre navigateur a gardé l'ancienne version en mémoire.

| Appareil | Manipulation |
|---|---|
| **Ordinateur** | `Ctrl` + `Maj` + `R` (Mac : `Cmd` + `Maj` + `R`) |
| **iPhone / iPad** | Réglages → Safari → Effacer historique et données |
| **Android** | Chrome → ⋮ → Historique → Effacer les données de navigation |
| **App installée** | La désinstaller, puis la réinstaller depuis le site |

> J'ai fait passer le cache interne de `lumina-v130` à `lumina-v131` : sur un site déjà en ligne, la mise à jour se fera seule au second chargement.

---

## 🔍 Vérification en 4 gestes

| # | Action | ✅ Attendu |
|---|---|---|
| 1 | Accueil → cliquer **Outils** | Le panneau **se déroule** |
| 2 | Regarder le lien à droite | Il affiche maintenant **« Masquer ‹ »** |
| 3 | Chercher la carte **☁️ Mon compte** | Formulaire e-mail + mot de passe (et non le message « mode local ») |
| 4 | Recliquer sur **Outils** | Le panneau se referme, le lien repasse à « Afficher › » |

> 🔴 **Si à l'étape 3 vous lisez encore « Mode local »** : le rechargement n'a pas pris, ou `config.js` n'est pas en ligne. Ouvrez directement `votre-site.fr/config.js` dans le navigateur — vous devez y voir vos deux clés. Une erreur 404 signifie que le fichier n'a pas été déployé.

---

## 🛡️ Ce que j'ai fait pour que ça ne se reproduise pas

- **Recherche du même piège partout** : j'ai passé en revue les **17** éléments masqués de la même façon dans l'application. **Aucun autre n'est concerné** — celui-ci était le seul à être repiloté par une classe.
- **5 contrôles ajoutés** au vérificateur automatique (absence de masquage en ligne, état porté par le CSS, identifiant du lien, cible de la fonction).
- **Test d'ouverture réelle** : le test ne se contente plus de vérifier que la classe est posée, il **calcule le style réellement appliqué** et exige `display:block`. C'est précisément ce qui manquait pour attraper ce bug plus tôt.

**Résultats : 20/20 au test d'ouverture · 88/88 au vérificateur de release.**

---

## 📌 La leçon, notée au journal

> Vérifier qu'une classe est posée **ne prouve pas** que l'utilisateur voit quelque chose. Tout test d'affichage doit interroger le style calculé, pas l'état interne du code.

C'est aussi un rappel que mes 59 tests de la v1.3 étaient passés au vert **alors que la fonctionnalité était inaccessible** : ils validaient que la carte existait dans la page, jamais qu'on pouvait l'atteindre en cliquant.

---

*LUMINA v1.3.1 — 22 septembre 2026 — 0 € engagé*
