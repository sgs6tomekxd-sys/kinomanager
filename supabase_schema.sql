-- Tabela Użytkowników (Twórz tylko jeśli nie istnieje)
create table if not exists public.users (
  id uuid default gen_random_uuid() primary key,
  username text unique not null,
  password text not null,
  role text default 'user' check (role in ('admin', 'user')),
  created_at timestamp with time zone default timezone('utc', now())
);

-- Tabela Filmów (Twórz tylko jeśli nie istnieje)
create table if not exists public.movies (
  id text primary key,
  title text not null,
  distributor text,
  play_start date,
  play_end date,
  shipping_destination text,
  shipping_deadline date,
  is_sent boolean default false,
  disk_received boolean default false,
  key_available boolean default false,
  key_not_required boolean default false,
  key_valid_until date,
  archived boolean default false,
  added_at date default current_date,
  updated_at timestamp with time zone default timezone('utc', now())
);

-- Tabela Logów (Twórz tylko jeśli nie istnieje)
create table if not exists public.logs (
  id text primary key,
  user_name text not null,
  action text not null,
  timestamp text,
  created_at timestamp with time zone default timezone('utc', now())
);

-- Domyślny Administrator (Dodaj tylko jeśli nie ma)
insert into public.users (username, password, role)
values ('admin', 'admin', 'admin')
on conflict (username) do nothing;

-- RLS (Włącz bezpieczeństwo)
alter table public.users enable row level security;
alter table public.movies enable row level security;
alter table public.logs enable row level security;

-- Polityki bezpieczeństwa (Usuń stare i dodaj nowe, aby uniknąć błędów duplikatów)
drop policy if exists "Public Access Users" on public.users;
create policy "Public Access Users" on public.users for all using (true) with check (true);

drop policy if exists "Public Access Movies" on public.movies;
create policy "Public Access Movies" on public.movies for all using (true) with check (true);

drop policy if exists "Public Access Logs" on public.logs;
create policy "Public Access Logs" on public.logs for all using (true) with check (true);

-- Konfiguracja Realtime (Ignoruj błędy jeśli już dodano)
do $$
begin
  begin alter publication supabase_realtime add table public.movies; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.users; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.logs; exception when duplicate_object then null; end;
end $$;
