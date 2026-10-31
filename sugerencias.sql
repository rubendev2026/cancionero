-- Sugerencias de canciones (canciones que el público quiere y el grupo aún no toca)
-- Ejecutar una vez en Supabase > SQL Editor.

create table if not exists public.song_suggestions (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) between 1 and 120),
  artist text default '' check (char_length(artist) <= 120),
  requester_name text default '' check (char_length(requester_name) <= 60),
  note text default '' check (char_length(note) <= 200),
  status text not null default 'Pendiente' check (status in ('Pendiente','Aprendida','Descartada')),
  created_at timestamptz not null default now()
);

alter table public.song_suggestions enable row level security;

-- Público: solo puede enviar sugerencias (no puede verlas ni cambiarlas)
drop policy if exists "public create suggestions" on public.song_suggestions;
create policy "public create suggestions"
on public.song_suggestions for insert
to anon, authenticated
with check (status = 'Pendiente');

-- Grupo (usuario autenticado): ver, actualizar y borrar
drop policy if exists "auth read suggestions" on public.song_suggestions;
create policy "auth read suggestions" on public.song_suggestions
for select to authenticated using (true);

drop policy if exists "auth update suggestions" on public.song_suggestions;
create policy "auth update suggestions" on public.song_suggestions
for update to authenticated using (true) with check (true);

drop policy if exists "auth delete suggestions" on public.song_suggestions;
create policy "auth delete suggestions" on public.song_suggestions
for delete to authenticated using (true);

grant insert on public.song_suggestions to anon;
grant select, insert, update, delete on public.song_suggestions to authenticated;
