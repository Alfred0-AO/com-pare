# Tasks — com-pare

## Sprint 1 — Database & Demo Listings (demoable without login)
**Goal:** App loads with real provider data; comparison tool works end-to-end against DB.
- [ ] Run migration SQL (all tables, RLS v1 policies, seed data)
- [ ] Build homepage `/` showing seeded `service_providers` list (loading / empty / error / ready states)
- [ ] Build comparison form (amount + destination) → ranked results from DB
- [ ] Store each comparison run in `comparisons` table
- [ ] Confirm: anonymous visitor can run a comparison; result persists in DB
**Definition of Done:** A person with no account opens the app, runs a comparison, and the row appears in Supabase `comparisons` table. No login prompt.

---

## Sprint 2 — Referral Engine ✅ v1 functional milestone
**Goal:** Referral loop works end-to-end.
- [ ] User signup page → creates `users` row + generates `referral_code`
- [ ] `/ref/[code]` landing page stores code in cookie
- [ ] On signup via referral link → writes `referrals` row linking referrer + referee
- [ ] Dashboard (no-auth) shows total referral counts per user
- [ ] Confirm: full referral chain tracked in DB
**Definition of Done:** User A signs up → shares link → User B opens link and signs up → `referrals` row exists with both IDs and status `confirmed`. Visible in dashboard.

---

## Sprint 3 — Partnership Lead + Stripe Checkout
**Goal:** Provider can submit a lead and pay.
- [ ] Partnership enquiry form → writes `partnership_leads` row
- [ ] Admin lead list page (server-rendered, service-role protected)
- [ ] `/api/checkout` route creates Stripe session (server-side only)
- [ ] Stripe webhook writes `checkout_sessions` row on payment success
- [ ] Provider redirected to success/failure page
- [ ] `is_partner` flipped to `true` on confirmed payment
**Definition of Done:** A provider submits a lead, clicks Pay, completes Stripe test checkout, and `checkout_sessions.status = 'paid'` + `service_providers.is_partner = true` are confirmed in Supabase.

---

## Sprint 4 — Lock It Down (auth + owner-scoped data)
**Goal:** Real users see only their own data; demo seed remains accessible.
- [ ] Enable Supabase Auth (email + password)
- [ ] Replace v1 RLS policies with `auth.uid() = user_id` owner policies
- [ ] Protect admin routes with service-role server check
- [ ] Link existing `comparisons` and `referrals` to `auth.users` on login
- [ ] Confirm: logged-in user cannot read another user's comparisons
**Definition of Done:** Two test accounts cannot see each other's comparisons or referrals. Admin route returns 403 for non-admin sessions.

---

## Gantt (which sprint each task lands)
```
Sprint 1 [Week 1 D1-D2]: DB schema, seed, comparison tool
Sprint 2 [Week 1 D3-D4]: Signup, referral link, referral tracking  ← v1 functional
Sprint 3 [Week 1 D5-D7]: Lead form, Stripe checkout, admin lead view
Sprint 4 [Week 2]:        Auth, RLS lockdown, owner policies
```
