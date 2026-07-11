create table if not exists providers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  business_name text not null,
  category text not null default 'remittance',
  contact_email text,
  partnership_tier text not null default 'free',
  payout_rate numeric not null default 0,
  is_active bool not null default true,
  created_at timestamptz not null default now()
);

alter table providers enable row level security;
drop policy if exists "providers_v1_read" on providers;
create policy "providers_v1_read" on providers for select using (true);
drop policy if exists "providers_v1_write" on providers;
create policy "providers_v1_write" on providers for all using (true) with check (true);

create table if not exists listings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  provider_id uuid references providers(id),
  title text not null,
  exchange_rate numeric not null,
  fee_sgd numeric not null default 0,
  promo_text text,
  value_score numeric,
  value_score_source text,
  value_score_confidence numeric,
  value_score_review_status text default 'unreviewed',
  is_published bool not null default true,
  created_at timestamptz not null default now()
);

alter table listings enable row level security;
drop policy if exists "listings_v1_read" on listings;
create policy "listings_v1_read" on listings for select using (true);
drop policy if exists "listings_v1_write" on listings;
create policy "listings_v1_write" on listings for all using (true) with check (true);

create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  full_name text not null,
  phone text,
  referral_code text unique not null,
  referred_by uuid,
  referral_count int not null default 0,
  created_at timestamptz not null default now()
);

alter table users enable row level security;
drop policy if exists "users_v1_read" on users;
create policy "users_v1_read" on users for select using (true);
drop policy if exists "users_v1_write" on users;
create policy "users_v1_write" on users for all using (true) with check (true);

create table if not exists comparisons (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  listing_ids jsonb not null default '[]',
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
  referred_user_id uuid,
  referral_code text not null,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

alter table referrals enable row level security;
drop policy if exists "referrals_v1_read" on referrals;
create policy "referrals_v1_read" on referrals for select using (true);
drop policy if exists "referrals_v1_write" on referrals;
create policy "referrals_v1_write" on referrals for all using (true) with check (true);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  provider_id uuid references providers(id),
  listing_id uuid references listings(id),
  action text not null default 'click',
  created_at timestamptz not null default now()
);

alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

create table if not exists payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  provider_id uuid references providers(id),
  stripe_session_id text,
  amount_sgd numeric not null default 0,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

alter table payments enable row level security;
drop policy if exists "payments_v1_read" on payments;
create policy "payments_v1_read" on payments for select using (true);
drop policy if exists "payments_v1_write" on payments;
create policy "payments_v1_write" on payments for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  actor_id uuid,
  tool_name text not null,
  input_json jsonb,
  output_json jsonb,
  risk_level text not null default 'low',
  approved_by uuid,
  status text not null default 'completed',
  created_at timestamptz not null default now()
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into providers (id, business_name, category, contact_email, partnership_tier, payout_rate, is_active) values
  ('a1000000-0000-0000-0000-000000000001', 'Lucky Money Remittance', 'remittance', 'lucky@example.com', 'featured', 5.0, true),
  ('a1000000-0000-0000-0000-000000000002', 'iRemit Singapore', 'remittance', 'iremit@example.com', 'free', 3.5, true),
  ('a1000000-0000-0000-0000-000000000003', 'Globe Padala SG', 'remittance', 'globe@example.com', 'free', 3.0, true),
  ('a1000000-0000-0000-0000-000000000004', 'OFW Shield Insurance', 'insurance', 'ofwshield@example.com', 'free', 4.0, true);

insert into listings (id, provider_id, title, exchange_rate, fee_sgd, promo_text, value_score, value_score_source, value_score_confidence, value_score_review_status, is_published) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Lucky Money — Standard Rate', 40.12, 2.00, 'No weekend surcharge', 88, 'rule:rate*0.6+fee_inverse*0.4', 0.90, 'reviewed', true),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'Lucky Money — Express (2hr)', 39.80, 0.00, 'Zero fee this June!', 91, 'rule:rate*0.6+fee_inverse*0.4', 0.92, 'reviewed', true),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000002', 'iRemit — Economy', 40.05, 3.50, 'Best for amounts over SGD 500', 75, 'rule:rate*0.6+fee_inverse*0.4', 0.88, 'reviewed', true),
  ('b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000003', 'Globe Padala — Weekend Deal', 39.95, 1.00, 'Sat–Sun promo rate', 82, 'rule:rate*0.6+fee_inverse*0.4', 0.85, 'reviewed', true),
  ('b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000003', 'Globe Padala — Standard', 39.70, 2.50, null, 72, 'rule:rate*0.6+fee_inverse*0.4', 0.85, 'reviewed', true),
  ('b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000004', 'OFW Shield — Basic Health Plan', 0, 30.00, 'Monthly cover from SGD 30', 60, 'rule:rate*0.6+fee_inverse*0.4', 0.70, 'unreviewed', true);

insert into users (id, full_name, phone, referral_code, referral_count) values
  ('c1000000-0000-0000-0000-000000000001', 'Maria Santos', '+6591234567', 'MARIA-7K2P', 2),
  ('c1000000-0000-0000-0000-000000000002', 'Jose Reyes', '+6598765432', 'JOSE-3M9Q', 1),
  ('c1000000-0000-0000-0000-000000000003', 'Ana Dela Cruz', '+6582345678', 'ANA-5X1R', 0);

insert into referrals (user_id, referred_user_id, referral_code, status) values
  ('c1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000002', 'MARIA-7K2P', 'converted'),
  ('c1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000003', 'MARIA-7K2P', 'converted'),
  ('c1000000-0000-0000-0000-000000000002', null, 'JOSE-3M9Q', 'pending');

insert into leads (user_id, provider_id, listing_id, action) values
  ('c1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002', 'click'),
  ('c1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004', 'inquiry'),
  ('c1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003', 'click');

insert into payments (provider_id, stripe_session_id, amount_sgd, status) values
  ('a1000000-0000-0000-0000-000000000001', 'cs_test_demo_lucky_001', 299.00, 'confirmed');