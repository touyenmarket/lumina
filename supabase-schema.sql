-- ============================================================
-- LUMINA v1.3 — Schéma Supabase (palier gratuit)
-- À coller dans : Supabase → SQL Editor → New query → Run
-- Durée : environ 10 secondes. Idempotent : peut être relancé.
-- ============================================================

-- ------------------------------------------------------------
-- 1. DONNÉES PERSONNELLES (favoris, notes, progression…)
--    Un enregistrement par utilisateur et par clé.
-- ------------------------------------------------------------
create table if not exists public.lumina_data (
  user_id    uuid        not null references auth.users(id) on delete cascade,
  key        text        not null,
  value      text,
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);

alter table public.lumina_data enable row level security;

-- Chacun ne voit et ne modifie QUE ses propres données.
drop policy if exists "lecture de mes donnees"      on public.lumina_data;
drop policy if exists "ecriture de mes donnees"     on public.lumina_data;
drop policy if exists "mise a jour de mes donnees"  on public.lumina_data;
drop policy if exists "suppression de mes donnees"  on public.lumina_data;

create policy "lecture de mes donnees"
  on public.lumina_data for select
  using (auth.uid() = user_id);

create policy "ecriture de mes donnees"
  on public.lumina_data for insert
  with check (auth.uid() = user_id);

create policy "mise a jour de mes donnees"
  on public.lumina_data for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "suppression de mes donnees"
  on public.lumina_data for delete
  using (auth.uid() = user_id);


-- ------------------------------------------------------------
-- 2. GALERIE PARTAGÉE
--    Lisible par tous, modifiable seulement par son auteur.
-- ------------------------------------------------------------
create table if not exists public.gallery (
  id         bigserial   primary key,
  user_id    uuid        not null references auth.users(id) on delete cascade,
  title      text        not null,
  author     text,
  style      text,
  chapters   int         default 12,
  cover      text,
  views      int         default 1,
  created_at timestamptz not null default now()
);

create index if not exists gallery_created_idx on public.gallery (created_at desc);

alter table public.gallery enable row level security;

drop policy if exists "galerie visible par tous"      on public.gallery;
drop policy if exists "publier dans la galerie"       on public.gallery;
drop policy if exists "modifier mes publications"     on public.gallery;
drop policy if exists "retirer mes publications"      on public.gallery;

-- Lecture publique : même sans compte, on peut parcourir la galerie.
create policy "galerie visible par tous"
  on public.gallery for select
  using (true);

create policy "publier dans la galerie"
  on public.gallery for insert
  with check (auth.uid() = user_id);

create policy "modifier mes publications"
  on public.gallery for update
  using (auth.uid() = user_id);

create policy "retirer mes publications"
  on public.gallery for delete
  using (auth.uid() = user_id);


-- ------------------------------------------------------------
-- 3. COMPTEUR DE VUES
--    Fonction sécurisée : incrémente sans permettre de tout modifier.
-- ------------------------------------------------------------
create or replace function public.increment_view(row_id bigint)
returns void
language sql
security definer
set search_path = public
as $$
  update public.gallery set views = views + 1 where id = row_id;
$$;

grant execute on function public.increment_view(bigint) to anon, authenticated;


-- ------------------------------------------------------------
-- 4. VÉRIFICATION
-- ------------------------------------------------------------
-- Doit renvoyer 2 lignes : lumina_data et gallery
select tablename, rowsecurity as "RLS activée"
from pg_tables
where schemaname = 'public' and tablename in ('lumina_data','gallery');
