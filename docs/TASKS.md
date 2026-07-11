# Tasks — com-pare

## Sprint 1 — Database & Seed Data
**Goal:** Schema live in Supabase; demo rows visible; homepage renders without login.
- [ ] Run migration SQL (all tables, RLS v1 policies)
- [ ] Seed 4 providers, 6 listings, 3 users, 2 referrals, 2 leads
- [ ] Verify homepage `/` fetches and renders listings (loading / empty / error states)
- [ ] Confirm no login wall on homepage
**DoD:** A fresh browser hitting the deployed URL shows ≥3 listings with rates and scores. No auth required.

## Sprint 2 — Core Engine: Compare + Referral ✦ v1 functional
**Goal:** The one workflow works end-to-end.
- [ ] Comparison widget: select 2–4 listings, side-by-side view persists to DB
- [ ] User signup flow: name, phone, auto-generate `referral_code`
- [ ] Referral link `/ref/[code]` creates `referrals` row on visit
- [ ] Signup via referral link → referral status = converted, referrer count +1
- [ ] "Contact Provider" button → inserts `leads` row, shows confirmation
- [ ] All 5 UI states handled: loading, empty, partial, error, ready
**DoD:** Full scenario (compare → share → friend signs up → lead clicked) completes and every row appears in Supabase. No dead buttons.

## Sprint 3 — Provider Partnership & Payments
**Goal:** A provider can pay to be listed; revenue is recorded.
- [ ] `/partner` page: partnership tiers explained, CTA to pay
- [ ] `POST /api/checkout` creates Stripe Checkout session (server-side)
- [ ] Stripe webhook handler validates event, writes `payments` row, upgrades tier
- [ ] Paid providers get "Featured" badge on listings
- [ ] Admin dashboard: user count, referral count, lead count, revenue total
**DoD:** A test Stripe payment completes, `payments` row is confirmed, provider tier changes to 'featured', badge appears on listing.

## Sprint 4 — Lock It Down (Auth + RLS)
**Goal:** Real user data is owner-scoped; app is safe for real users.
- [ ] Supabase Auth (email/phone) integrated
- [ ] Replace v1 permissive RLS with `auth.uid() = user_id` write policies
- [ ] Referral code tied to authenticated user
- [ ] Provider portal login-gated
- [ ] Admin route protected by role check
**DoD:** User A cannot read or write User B's comparisons, referrals, or leads. Confirmed via Supabase policy tester and manual test.

## Sprint 5 — Intelligence & Growth
**Goal:** Listings ranked by value; referral loop drives growth.
- [ ] `value_score` computed on listing upsert (rule-based formula)
- [ ] Homepage sorted by `value_score DESC`
- [ ] Referral leaderboard (top referrers this month)
- [ ] Lead-notification email to provider via Resend
- [ ] Admin can flag listing for AI review
**DoD:** Listings reorder visibly when `exchange_rate` is edited. Provider receives email within 60 s of lead creation.

---
## Gantt (which sprint each feature lands)
| Feature | Sprint |
|---|---|
| DB schema + seed | 1 |
| Homepage listings | 1 |
| Comparison widget | 2 |
| Referral signup flow | 2 |
| Lead capture | 2 |
| Stripe checkout | 3 |
| Admin dashboard | 3 |
| Auth + RLS lockdown | 4 |
| Value scoring + rank | 5 |
| Lead email notification | 5 |
