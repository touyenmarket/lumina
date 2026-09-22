# LUMINA v1.4.2 — le message « JWT expired » ne peut plus s'afficher

**Date :** 22/09/2026 · **Coût engagé : 0 €**
**Pour qui :** toi (déploiement) — 3 minutes, aucune modification côté Supabase.

---

## 1. La cause exacte du message qui restait

Deux choses différentes ont été confondues, et c'est de ma faute :

| Ce qu'on a corrigé | Où ça se corrige | Effet sur le message |
|---|---|---|
| La vue `storage_usage` (badge UNRESTRICTED) | Supabase → SQL Editor | ✅ fait par toi — le badge a disparu |
| Le renouvellement automatique du jeton | **Les fichiers de l'app** (`app.js`, `sw.js`) | ❌ pas encore en ligne chez toi |

Exécuter le SQL répare la base de données. Ça ne change **rien** au JavaScript
de l'application. Tant que `app.js` n'est pas remplacé sur ton dépôt GitHub,
ton app continue de tourner en v1.4 : jeton d'une heure, message technique brut
affiché dès qu'il est périmé.

**Preuve visuelle à contrôler après déploiement** — en bas de l'écran d'accueil,
le pied de page doit afficher :

> LUMINA **v1.4.2 · jeton auto** · démo · 0 € engagé

La mention « **· jeton auto** » ne peut être écrite que par le code corrigé.
Si tu ne la vois pas, l'app tourne encore sur l'ancien fichier (cache ou
déploiement non repris) : le reste ne servira à rien.

---

## 2. Ce que change la v1.4.2 (au-delà du renouvellement automatique)

Le correctif v1.4.1 renouvelait le jeton, mais laissait encore passer un
message technique dans certains cas de figure. C'est réparé :

1. **Aucun message technique à l'écran, jamais.** Les erreurs d'authentification
   sont traduites : « 🔐 Session expirée — reconnectez-vous dans la carte Mon compte ».
   Le texte brut de Supabase (« JWT expired », « refresh failed », code 401…)
   n'est plus jamais montré.
2. **Panne de réseau ≠ déconnexion.** Avant, une coupure réseau pendant le
   renouvellement pouvait vider la session. Maintenant : message « 📶 Connexion
   instable », et **la session est conservée**. On ne déconnecte que si Supabase
   refuse vraiment la reconnexion (400/401/403).
3. **Jeton perdu ou révoqué → reconnexion propre.** Session vidée, message clair,
   formulaire de connexion affiché. Pas de boucle, pas de message incompréhensible.
4. **Le lien par e-mail termine enfin la connexion.** Second défaut trouvé en relisant
   le code : le bouton « ✉️ Recevoir un lien par e-mail » envoyait bien le lien, mais
   au retour dans l'application le jeton présent dans l'adresse n'était jamais lu —
   la connexion ne s'achevait donc pas. C'est réparé : l'app lit le jeton au retour,
   enregistre la session, efface le jeton de l'adresse (sécurité) et synchronise.
5. **Ligne d'état dans la carte « Mon compte »** (visible quand tu es connecté) :

   > App **v1.4.2** · jeton **47 min** · renouvellement auto actif

   Tu vois d'un coup d'œil si tout va bien, sans ouvrir Supabase ni la console.

---

## 3. À faire de ton côté (3 minutes)

1. **GitHub** — remplacer à la racine du dépôt `lumina-pwa/` :
   - `app.js`
   - `index.html`
   - `sw.js` (le cache passe à `lumina-v142`)

   Puis valider (« Commit changes »). Vercel redéploie tout seul en 30 à 60 secondes.

2. **Vercel** — attendre que le déploiement passe au vert (onglet *Deployments*).

3. **App** — ouvrir puis **recharger deux fois** (`Ctrl+Maj+R`, Mac : `Cmd+Maj+R`).
   Sur iPhone, app installée : la fermer complètement (glisser vers le haut) puis la rouvrir.

4. **Contrôler le pied de page** : `LUMINA v1.4.2 · jeton auto · démo · 0 € engagé`.
   C'est la seule preuve qui compte.

5. Laisser l'app ouverte 5 minutes, puis revenir 1 heure plus tard : plus aucun message.
6. (Facultatif) S'identifier une fois avec « ✉️ Recevoir un lien par e-mail » :
   le lien doit connecter directement, sans repasser par le formulaire.

---

## 4. Si « · jeton auto » n'apparaît toujours pas

Le fichier servi n'est pas le bon. Dans l'ordre :

1. Vercel → *Deployments* : le dernier déploiement est-il bien postérieur à ton
   envoi sur GitHub ? S'il est rouge, déployer manuellement (*Redeploy*).
2. Navigateur : ouvrir l'app dans un **onglet privé** (aucun cache). Si la mention
   apparaît en privé → c'était bien le cache du navigateur ou du service worker.
3. iPhone/app installée : supprimer l'app de l'écran d'accueil et la réinstaller
   depuis l'URL (le service worker est alors reconstruit de zéro).
4. Me le dire : je te donnerai la commande exacte pour vérifier ce que le serveur
   renvoie réellement (`curl .../app.js | grep`), sans rien modifier chez toi.

---

## 5. Rappel : le SQL déjà exécuté reste valable

- `correctif-vue-v1.4.1.sql` : ✅ exécuté, badge `UNRESTRICTED` disparu.
- Rien à refaire côté Supabase pour cette version.
- Le stockage (coffre de 50 Mo par compte, bucket privé `films`) est inchangé.

**Coûts : toujours 0 € engagé.** Aucun abonnement n'a été souscrit pour cette
correction (ni Stripe, ni domaine, ni Supabase Pro).
