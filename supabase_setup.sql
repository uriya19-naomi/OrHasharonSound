-- ============================================================
-- Setup for: or_hasharon_sound
-- Run this once in the Supabase SQL Editor (Dashboard > SQL Editor > New query > Run)
-- ============================================================

-- 1. Dedicated schema for this app
create schema if not exists or_hasharon_sound;

-- Expose it to the auto-generated API (PostgREST)
grant usage on schema or_hasharon_sound to anon, authenticated;

-- ------------------------------------------------------------
-- 2. Usage logs table (one row per visit/action, kept forever)
-- ------------------------------------------------------------
create table or_hasharon_sound.usage_logs (
  id bigint generated always as identity primary key,
  visited_at timestamptz not null default now(),
  visitor_name text,        -- optional, only if you ask for a name
  action text not null default 'page_view'
);

alter table or_hasharon_sound.usage_logs enable row level security;

-- Anyone (anonymous visitors) can insert a log row, but cannot read, update or delete any
create policy "anon can insert logs"
  on or_hasharon_sound.usage_logs
  for insert
  to anon, authenticated
  with check (true);

grant insert on or_hasharon_sound.usage_logs to anon, authenticated;
grant usage, select on sequence or_hasharon_sound.usage_logs_id_seq to anon, authenticated;

-- ------------------------------------------------------------
-- 3. Checklist items table (the actual app data)
-- ------------------------------------------------------------
create table or_hasharon_sound.checklist_items (
  id text primary key,       -- e.g. 'xlr', 'pl', 'stand1', 'stand2'
  label text not null,
  checked boolean not null default false,
  updated_at timestamptz not null default now()
);

alter table or_hasharon_sound.checklist_items enable row level security;

-- Anyone can read the current checklist state
create policy "anon can read checklist"
  on or_hasharon_sound.checklist_items
  for select
  to anon, authenticated
  using (true);

-- Anyone can update the checked state (no insert/delete from the public site)
create policy "anon can update checklist"
  on or_hasharon_sound.checklist_items
  for update
  to anon, authenticated
  using (true)
  with check (true);

grant select, update on or_hasharon_sound.checklist_items to anon, authenticated;

-- Seed the four checklist items
insert into or_hasharon_sound.checklist_items (id, label) values
  ('xlr', 'XLR Cable'),
  ('pl', 'PL Cable'),
  ('stand1', 'Stand 1'),
  ('stand2', 'Stand 2')
on conflict (id) do nothing;
