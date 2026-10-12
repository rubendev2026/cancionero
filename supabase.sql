-- BARAJA NORTEÑA 1.0
create extension if not exists pgcrypto;

create table if not exists public.songs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  tone text default '',
  lyrics text default '',
  category text default 'Norteñas',
  active boolean not null default true,
  request_count integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.requests (
  id uuid primary key default gen_random_uuid(),
  song_id uuid not null references public.songs(id) on delete cascade,
  requester_name text default '',
  dedication text default '',
  status text not null default 'Pendiente' check (status in ('Pendiente','Complacida')),
  created_at timestamptz not null default now(),
  complacida_at timestamptz
);

alter table public.songs enable row level security;
alter table public.requests enable row level security;

-- Público: puede leer canciones activas.
drop policy if exists "public read active songs" on public.songs;
create policy "public read active songs"
on public.songs for select
using (active = true);

-- Público: puede crear peticiones.
drop policy if exists "public create requests" on public.requests;
create policy "public create requests"
on public.requests for insert
with check (status = 'Pendiente');

-- Para el panel del administrador en esta primera versión,
-- las operaciones de administración se harán con una cuenta autenticada.
-- Crea un usuario administrador en Supabase Authentication.

drop policy if exists "authenticated read songs" on public.songs;
create policy "authenticated read songs"
on public.songs for select
to authenticated using (true);

drop policy if exists "authenticated insert songs" on public.songs;
create policy "authenticated insert songs"
on public.songs for insert
to authenticated with check (true);

drop policy if exists "authenticated update songs" on public.songs;
create policy "authenticated update songs"
on public.songs for update
to authenticated using (true) with check (true);

drop policy if exists "authenticated delete songs" on public.songs;
create policy "authenticated delete songs"
on public.songs for delete
to authenticated using (true);

drop policy if exists "authenticated read requests" on public.requests;
create policy "authenticated read requests"
on public.requests for select
to authenticated using (true);

drop policy if exists "authenticated update requests" on public.requests;
create policy "authenticated update requests"
on public.requests for update
to authenticated using (true) with check (true);

-- Incremento seguro del contador al registrar una petición.
create or replace function public.register_request(
  p_song_id uuid,
  p_requester_name text default '',
  p_dedication text default ''
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request_id uuid;
begin
  insert into public.requests(song_id, requester_name, dedication)
  values (p_song_id, coalesce(p_requester_name,''), coalesce(p_dedication,''))
  returning id into v_request_id;

  update public.songs
  set request_count = request_count + 1
  where id = p_song_id and active = true;

  return v_request_id;
end;
$$;

grant execute on function public.register_request(uuid,text,text) to anon, authenticated;

-- Realtime para que el panel reciba nuevas peticiones.
alter publication supabase_realtime add table public.requests;
