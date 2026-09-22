-- ============================================================
-- LUMINA v1.4.1 — Correctif de la vue storage_usage
-- À exécuter dans Supabase → SQL Editor → New query → Run
-- Durée : 2 secondes.
--
-- POURQUOI : Supabase affichait « UNRESTRICTED » sur cette vue.
-- Sans l'option ci-dessous, une vue s'exécute avec les droits de
-- son créateur et ignore les règles RLS : tout utilisateur connecté
-- aurait vu les totaux de TOUS les comptes.
-- ============================================================

drop view if exists public.storage_usage;

create view public.storage_usage
  with (security_invoker = true)
as
  select
    count(*)                                     as nb_fichiers,
    count(distinct user_id)                      as nb_utilisateurs,
    pg_size_pretty(coalesce(sum(size), 0))       as espace_utilise,
    round(coalesce(sum(size), 0) / 10737418.24, 1) || ' %' as pct_du_gigaoctet
  from public.films;

grant select on public.storage_usage to authenticated;

-- Vérification : le badge « UNRESTRICTED » doit disparaître
-- du Table Editor après un rafraîchissement de la page.
select viewname,
       case when 'security_invoker=true' = any(reloptions)
            then '✅ protégée' else '⚠️ à revoir' end as etat
from pg_views v
join pg_class c on c.relname = v.viewname
where v.schemaname = 'public' and v.viewname = 'storage_usage';

-- Votre vision globale de propriétaire (rôle postgres, ici même) :
select count(*) as fichiers,
       pg_size_pretty(coalesce(sum(size),0)) as espace_total
from public.films;
