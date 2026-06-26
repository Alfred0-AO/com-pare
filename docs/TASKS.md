# Tasks & Sprints

## Sprint 1 — Database, Seed Data & Core Dashboard _(no login required)_
**Goal:** App renders real-looking data for an anonymous visitor. Every form saves to the DB.

- [ ] Run migration SQL (all tables + seed rows)
- [ ] Homepage dashboard: fetch and display permit, OWWA, PhilHealth, finance rows
- [ ] Urgency badge component (red / yellow / green) driven by date arithmetic
- [ ] Permit record form: create & edit, persists to `permit_records`
- [ ] OWWA record form: create & edit, persists to `owwa_records`
- [ ] PhilHealth record form: create & edit, persists to `philhealth_records`
- [ ] Finance entry form: income/expense, persists to `finance_entries`; running balance shown
- [ ] Empty state UI copy for each section
- [ ] Loading skeleton and error boundary on all data fetches
- [ ] Delete button on each record (with confirmation modal) → hard delete + audit log entry

**DoD:** Dashboard loads with seed data in under 2 s; every form save is reflected immediately; empty states show correct copy; no dead buttons.

---

## Sprint 2 — Auth, Per-User Data & Stripe Checkout ✅ _v1 functional milestone_
**Goal:** A real worker can sign up, own her data, and pay.

- [ ] Supabase Auth: sign-up and login pages (`/signup`, `/login`)
- [ ] On sign-up: insert `workers` row with `user_id = auth.uid()`
- [ ] Replace v1 RLS policies with owner-scoped policies (`auth.uid() = user_id`)
- [ ] Stripe products: Monthly SGD 4.90 and Annual SGD 39
- [ ] `/api/checkout` route: creates Stripe Checkout session, returns URL
- [ ] `/api/webhooks/stripe` route: handles `checkout.session.completed` → upsert `subscriptions`
- [ ] Free tier gate: history capped at last 3 finance entries; upgrade prompt shown
- [ ] Subscription badge in nav bar (Free / Pro)
- [ ] Post-checkout redirect to dashboard with success toast
- [ ] Audit log entry on subscription activation

**DoD:** Sign-up → enter permit date → checkout → data correct on refresh; Stripe test payment captured; RLS blocks cross-user reads.

---

## Sprint 3 — Expiry Alerts & Document Uploads
**Goal:** Workers get warned before things expire.

- [ ] Nightly cron (Vercel cron or pg_cron): query records expiring within 30 days
- [ ] `send_expiry_alert` tool: sends email via Resend (permit / OWWA / PhilHealth)
- [ ] In-app notification bell: badge count of upcoming expiries
- [ ] Alert opt-in settings page (per alert type)
- [ ] Document upload: Supabase Storage bucket, attach to permit / OWWA / PhilHealth record
- [ ] Thumbnail preview on dashboard cards

**DoD:** Test email received when permit expiry is set to 25 days from today; upload persists and thumbnail renders.

---

## Sprint 4 — Finance Charts & Admin Usage View
**Goal:** Builder can see who is using the app and finance is more useful.

- [ ] Monthly income vs expense bar chart (Recharts)
- [ ] Expense category pie chart
- [ ] Admin route `/admin` (role-gated): total users, paying users, MRR
- [ ] Audit log viewer: last 50 entries, filterable by action
- [ ] Export finance entries as CSV

**DoD:** Admin page shows correct counts; chart renders from real DB data; CSV download works.

---

## Gantt (Sprint → Weeks)
```
Week 1:  Sprint 1 — DB + dashboard + all entry forms
Week 2:  Sprint 2 — Auth + RLS lockdown + Stripe checkout   ← v1 live
Week 3:  Sprint 3 — Email alerts + document uploads
Week 4:  Sprint 4 — Charts + admin panel
```
