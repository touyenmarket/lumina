-- ============================================================
-- LUMINA v1.4 — Stockage des films (Phase 8.6)
-- À coller dans : Supabase → SQL Editor → New query → Run
-- Durée : ~10 secondes. Idempotent : peut être relancé sans risque.
--
-- ⚠️ PRÉREQUIS : supabase-schema.sql doit avoir été exécuté avant.
-- ============================================================

-- ------------------------------------------------------------
-- 1. LE COFFRE (bucket privé)
--    Privé = un fichier n'est lisible qu'avec le jeton de son
--    propriétaire. Aucune URL publique ne circule.
-- ------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit)
values ('films', 'films', false, 41943040)   -- 40 Mo par fichier
on conflict (id) do update set
  public = false,
  file_size_limit = 41943040;


-- ------------------------------------------------------------
-- 2. RÈGLES D'ACCÈS AU COFFRE
--    Convention de rangement : <user_id>/<horodatage>_<nom>
--    Le premier dossier porte l'identifiant du propriétaire,
--    ce qui permet de vérifier l'appartenance de chaque fichier.
-- ------------------------------------------------------------
drop policy if exists "deposer mes films"   on storage.objects;
drop policy if exists "lire mes films"      on storage.objects;
drop policy if exists "remplacer mes films" on storage.objects;
drop policy if exists "effacer mes films"   on storage.objects;

create policy "deposer mes films"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'films'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "lire mes films"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'films'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "remplacer mes films"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'films'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "effacer mes films"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'films'
    and (storage.foldername(name))[1] = auth.uid()::text
  );


-- ------------------------------------------------------------
-- 3. CATALOGUE DES FILMS
--    Le fichier vit dans le coffre ; cette table décrit
--    ce qu'il contient (titre, style, poids, date).
-- ------------------------------------------------------------
create table if not exists public.films (
  id         bigserial   primary key,
  user_id    uuid        not null references auth.users(id) on delete cascade,
  path       text        not null unique,
  name       text        not null,
  kind       text        default 'pack',
  size       bigint      default 0,
  title      text,
  style      text,
  created_at timestamptz not null default now()
);

create index if not exists films_user_idx on public.films (user_id, created_at desc);

alter table public.films enable row level security;

drop policy if exists "voir mes films"      on public.films;
drop policy if exists "ajouter mes films"   on public.films;
drop policy if exists "supprimer mes films" on public.films;

create policy "voir mes films"
  on public.films for select
  using (auth.uid() = user_id);

create policy "ajouter mes films"
  on public.films for insert
  with check (auth.uid() = user_id);

create policy "supprimer mes films"
  on public.films for delete
  using (auth.uid() = user_id);


-- ------------------------------------------------------------
-- 4. GARDE-FOU CÔTÉ SERVEUR : 50 Mo par utilisateur
--    L'application vérifie déjà ce quota, mais un contrôle
--    navigateur se contourne. Celui-ci ne se contourne pas.
--    50 Mo × 20 comptes = 1 Go, la limite du palier gratuit.
-- ------------------------------------------------------------
create or replace function public.check_user_quota()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  total bigint;
begin
  select coalesce(sum(size), 0) into total
  from public.films where user_id = new.user_id;

  if total + coalesce(new.size, 0) > 52428800 then   -- 50 Mo
    raise exception 'Quota dépassé : 50 Mo maximum par utilisateur. Supprimez un film avant d''en ajouter un nouveau.';
  end if;

  return new;
end;
$$;

drop trigger if exists films_quota_check on public.films;
create trigger films_quota_check
  before insert on public.films
  for each row execute function public.check_user_quota();


-- ------------------------------------------------------------
-- 5. VUE DE SUIVI — surveiller la consommation globale
--    À consulter régulièrement : le palier gratuit offre 1 Go.
-- ------------------------------------------------------------
-- ⚠️ security_invoker = true : la vue applique les règles RLS de
--    la personne qui la consulte, au lieu de celles de son créateur.
--    Sans cette option, Supabase affiche « UNRESTRICTED » et n'importe
--    quel utilisateur connecté verrait les totaux de TOUT LE MONDE.
--    Avec elle, chacun ne voit que sa propre consommation.
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

-- 👉 Vous, propriétaire du projet, gardez la vision globale via le
--    SQL Editor (rôle postgres), qui n'est pas soumis aux règles RLS :
--       select count(*), pg_size_pretty(sum(size)) from public.films;


-- ------------------------------------------------------------
-- 6. VÉRIFICATION
-- ------------------------------------------------------------
-- (a) Le coffre existe et est bien PRIVÉ
select id, public as "public (doit être false)",
       pg_size_pretty(file_size_limit) as "taille max par fichier"
from storage.buckets where id = 'films';

-- (b) La table est protégée
select tablename, rowsecurity as "RLS activée"
from pg_tables where schemaname = 'public' and tablename = 'films';

-- (c) Consommation actuelle
select * from public.storage_usage;
