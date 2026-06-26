create table if not exists workers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  full_name text not null,
  fin_number text,
  nationality text default 'Filipino',
  employer_name text,
  created_at timestamptz not null default now()
);
alter table workers enable row level security;
drop policy if exists "workers_v1_read" on workers;
create policy "workers_v1_read" on workers for select using (true);
drop policy if exists "workers_v1_write" on workers;
create policy "workers_v1_write" on workers for all using (true) with check (true);

create table if not exists permit_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  worker_id uuid references workers(id) on delete cascade,
  permit_type text not null default 'Work Permit',
  permit_number text,
  issue_date date,
  expiry_date date,
  employer_name text,
  status text default 'active',
  created_at timestamptz not null default now()
);
alter table permit_records enable row level security;
drop policy if exists "permit_records_v1_read" on permit_records;
create policy "permit_records_v1_read" on permit_records for select using (true);
drop policy if exists "permit_records_v1_write" on permit_records;
create policy "permit_records_v1_write" on permit_records for all using (true) with check (true);

create table if not exists owwa_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  worker_id uuid references workers(id) on delete cascade,
  membership_number text,
  valid_from date,
  valid_until date,
  contribution_amount numeric,
  status text default 'active',
  created_at timestamptz not null default now()
);
alter table owwa_records enable row level security;
drop policy if exists "owwa_records_v1_read" on owwa_records;
create policy "owwa_records_v1_read" on owwa_records for select using (true);
drop policy if exists "owwa_records_v1_write" on owwa_records;
create policy "owwa_records_v1_write" on owwa_records for all using (true) with check (true);

create table if not exists philhealth_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  worker_id uuid references workers(id) on delete cascade,
  philhealth_number text,
  last_contribution_date date,
  last_contribution_amount numeric,
  quarters_paid integer default 0,
  status text default 'active',
  created_at timestamptz not null default now()
);
alter table philhealth_records enable row level security;
drop policy if exists "philhealth_records_v1_read" on philhealth_records;
create policy "philhealth_records_v1_read" on philhealth_records for select using (true);
drop policy if exists "philhealth_records_v1_write" on philhealth_records;
create policy "philhealth_records_v1_write" on philhealth_records for all using (true) with check (true);

create table if not exists finance_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  worker_id uuid references workers(id) on delete cascade,
  entry_type text not null check (entry_type in ('income','expense')),
  category text,
  amount_sgd numeric not null,
  description text,
  entry_date date not null default current_date,
  created_at timestamptz not null default now()
);
alter table finance_entries enable row level security;
drop policy if exists "finance_entries_v1_read" on finance_entries;
create policy "finance_entries_v1_read" on finance_entries for select using (true);
drop policy if exists "finance_entries_v1_write" on finance_entries;
create policy "finance_entries_v1_write" on finance_entries for all using (true) with check (true);

create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  worker_id uuid references workers(id) on delete cascade,
  stripe_customer_id text,
  stripe_subscription_id text,
  plan text default 'free' check (plan in ('free','monthly','annual')),
  status text default 'active',
  current_period_end timestamptz,
  created_at timestamptz not null default now()
);
alter table subscriptions enable row level security;
drop policy if exists "subscriptions_v1_read" on subscriptions;
create policy "subscriptions_v1_read" on subscriptions for select using (true);
drop policy if exists "subscriptions_v1_write" on subscriptions;
create policy "subscriptions_v1_write" on subscriptions for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  worker_id uuid,
  action text not null,
  table_name text,
  record_id uuid,
  old_value jsonb,
  new_value jsonb,
  ip_address text,
  created_at timestamptz not null default now()
);
alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into workers (id, full_name, fin_number, employer_name) values
  ('a1000000-0000-0000-0000-000000000001', 'Maria Santos', 'G1234567P', 'Maple Home Services Pte Ltd'),
  ('a1000000-0000-0000-0000-000000000002', 'Rosario dela Cruz', 'G2345678Q', 'Tan Family Household'),
  ('a1000000-0000-0000-0000-000000000003', 'Josephine Reyes', 'G3456789R', 'Lim Residence')
on conflict (id) do nothing;

insert into permit_records (worker_id, permit_type, permit_number, issue_date, expiry_date, employer_name, status) values
  ('a1000000-0000-0000-0000-000000000001', 'Work Permit', 'WP2023-78341', '2023-06-15', '2025-06-14', 'Maple Home Services Pte Ltd', 'active'),
  ('a1000000-0000-0000-0000-000000000002', 'Work Permit', 'WP2022-55120', '2022-11-01', '2024-10-31', 'Tan Family Household', 'active'),
  ('a1000000-0000-0000-0000-000000000003', 'Work Permit', 'WP2021-44009', '2021-03-20', '2024-03-19', 'Lim Residence', 'active');

insert into owwa_records (worker_id, membership_number, valid_from, valid_until, contribution_amount, status) values
  ('a1000000-0000-0000-0000-000000000001', 'OWWA-SG-112233', '2024-01-10', '2026-01-09', 25.00, 'active'),
  ('a1000000-0000-0000-0000-000000000002', 'OWWA-SG-223344', '2023-05-15', '2025-05-14', 25.00, 'active'),
  ('a1000000-0000-0000-0000-000000000003', 'OWWA-SG-334455', '2022-09-01', '2024-08-31', 25.00, 'active');

insert into philhealth_records (worker_id, philhealth_number, last_contribution_date, last_contribution_amount, quarters_paid, status) values
  ('a1000000-0000-0000-0000-000000000001', 'PH-001122334', '2024-03-31', 400.00, 8, 'active'),
  ('a1000000-0000-0000-0000-000000000002', 'PH-002233445', '2024-02-29', 400.00, 6, 'active'),
  ('a1000000-0000-0000-0000-000000000003', 'PH-003344556', '2023-12-31', 400.00, 4, 'active');

insert into finance_entries (worker_id, entry_type, category, amount_sgd, description, entry_date) values
  ('a1000000-0000-0000-0000-000000000001', 'income', 'salary', 650.00, 'March salary', '2024-03-31'),
  ('a1000000-0000-0000-0000-000000000001', 'expense', 'remittance', 400.00, 'Remittance to family via GCash', '2024-04-01'),
  ('a1000000-0000-0000-0000-000000000001', 'expense', 'food', 60.00, 'Groceries at Fairprice', '2024-04-03'),
  ('a1000000-0000-0000-0000-000000000002', 'income', 'salary', 620.00, 'March salary', '2024-03-31'),
  ('a1000000-0000-0000-0000-000000000002', 'expense', 'remittance', 350.00, 'Western Union to Cebu', '2024-04-02'),
  ('a1000000-0000-0000-0000-000000000003', 'income', 'salary', 700.00, 'March salary', '2024-03-31');

insert into subscriptions (worker_id, plan, status, current_period_end) values
  ('a1000000-0000-0000-0000-000000000001', 'monthly', 'active', now() + interval '28 days'),
  ('a1000000-0000-0000-0000-000000000002', 'free', 'active', null),
  ('a1000000-0000-0000-0000-000000000003', 'annual', 'active', now() + interval '280 days');