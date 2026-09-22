/* ============================================================
   LUMINA — configuration Supabase (optionnelle)
   ------------------------------------------------------------
   1. Copiez ce fichier en  config.js
   2. Remplacez les deux valeurs par celles de votre projet
      (Supabase → Project Settings → Data API)
   3. Déployez : le formulaire de connexion apparaît tout seul

   ⚠️ La clé "anon" est PUBLIQUE par conception : elle est faite
      pour vivre dans le navigateur. Ce qui protège vos données,
      ce sont les règles RLS du fichier supabase-schema.sql.
      Ne mettez JAMAIS la clé "service_role" ici.

   Sans ce fichier, LUMINA fonctionne normalement en mode local.
   ============================================================ */
window.LUMINA_CONFIG = {
  url:     'https://axofcgwdopbcymheqcgw.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF4b2ZjZ3dkb3BiY3ltaGVxY2d3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NjY1ODIsImV4cCI6MjEwNTE0MjU4Mn0.0bCvJ7kuO-PaT33YceU2WmLvHu50QtBJx-8rUaCZRNA'
};
