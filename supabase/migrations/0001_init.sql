create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  display_name text,
  email text unique,
  referral_code text unique,
  referred_by_code text,
  created_at timestamptz not null default now()
);

alter table users enable row level security;
drop policy if exists "users_v1_read" on users;
create policy "users_v1_read" on users for select using (true);
drop policy if exists "users_v1_write" on users;
create policy "users_v1_write" on users for all using (true) with check (true);

create table if not exists service_providers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  name text,
  category text,
  fee_pct numeric,
  speed_hours numeric,
  rating numeric,
  website_url text,
  is_partner boolean default false,
  created_at timestamptz not null default now()
);

alter table service_providers enable row level security;
drop policy if exists "service_providers_v1_read" on service_providers;
create policy "service_providers_v1_read" on service_providers for select using (true);
drop policy if exists "service_providers_v1_write" on service_providers;
create policy "service_providers_v1_write" on service_providers for all using (true) with check (true);

create table if not exists comparisons (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  amount_sgd numeric,
  destination_country text,
  results_snapshot jsonb,
  score_value numeric,
  score_source text default 'rule_engine',
  score_confidence numeric,
  score_review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);

alter table comparisons enable row level security;
drop policy if exists "comparisons_v1_read" on comparisons;
create policy "comparisons_v1_read" on comparisons for select using (true);
drop policy if exists "comparisons_v1_write" on comparisons;
create policy "comparisons_v1_write" on comparisons for all using (true) with check (true);

create table if not exists referrals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  referee_user_id uuid,
  referral_code text,
  status text default 'pending',
  created_at timestamptz not null default now()
);

alter table referrals enable row level security;
drop policy if exists "referrals_v1_read" on referrals;
create policy "referrals_v1_read" on referrals for select using (true);
drop policy if exists "referrals_v1_write" on referrals;
create policy "referrals_v1_write" on referrals for all using (true) with check (true);

create table if not exists partnership_leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  provider_name text,
  contact_email text,
  message text,
  status text default 'new',
  created_at timestamptz not null default now()
);

alter table partnership_leads enable row level security;
drop policy if exists "partnership_leads_v1_read" on partnership_leads;
create policy "partnership_leads_v1_read" on partnership_leads for select using (true);
drop policy if exists "partnership_leads_v1_write" on partnership_leads;
create policy "partnership_leads_v1_write" on partnership_leads for all using (true) with check (true);

create table if not exists checkout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  partnership_lead_id uuid,
  stripe_session_id text,
  amount_sgd numeric,
  status text default 'pending',
  created_at timestamptz not null default now()
);

alter table checkout_sessions enable row level security;
drop policy if exists "checkout_sessions_v1_read" on checkout_sessions;
create policy "checkout_sessions_v1_read" on checkout_sessions for select using (true);
drop policy if exists "checkout_sessions_v1_write" on checkout_sessions;
create policy "checkout_sessions_v1_write" on checkout_sessions for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  actor_user_id uuid,
  action text,
  target_table text,
  target_id uuid,
  old_value jsonb,
  new_value jsonb,
  risk_level text,
  approved_by uuid,
  created_at timestamptz not null default now()
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into service_providers (id, name, category, fee_pct, speed_hours, rating, website_url, is_partner) values
  (gen_random_uuid(), 'Western Union Orchard', 'remittance', 1.2, 2, 4.8, 'https://www.westernunion.com/sg', true),
  (gen_random_uuid(), 'iRemit Singapore', 'remittance', 0.9, 4, 4.6, 'https://www.iremit.com.sg', true),
  (gen_random_uuid(), 'LBC Express Boon Lay', 'remittance', 1.5, 6, 4.3, 'https://www.lbcexpress.com', false),
  (gen_random_uuid(), 'Jollibee Remittance Centre', 'remittance', 1.1, 3, 4.5, 'https://example.com/jollibee-remit', false),
  (gen_random_uuid(), 'Smart Padala Lucky Plaza', 'remittance', 1.0, 2, 4.7, 'https://www.smart.com.ph/padala', true)
on conflict do nothing;

insert into users (id, display_name, email, referral_code, referred_by_code) values
  (gen_random_uuid(), 'Maria Santos', 'maria.santos@example.com', 'MARIA01', null),
  (gen_random_uuid(), 'Juan dela Cruz', 'juan.delacruz@example.com', 'JUAN02', 'MARIA01'),
  (gen_random_uuid(), 'Ana Reyes', 'ana.reyes@example.com', 'ANA03', 'JUAN02')
on conflict do nothing;