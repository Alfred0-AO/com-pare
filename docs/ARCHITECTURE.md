# Architecture — com-pare

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + Auth:** Supabase (Postgres + RLS + Auth)
- **Payments:** Stripe Checkout (server-side session creation)
- **Hosting:** Vercel (CI/CD from GitHub)

## Now vs Later (feature terms)
**Now:** Service provider listings, remittance comparison tool, referral link generation, partnership lead form, Stripe checkout, admin usage dashboard.
**Later:** Live exchange rate API, provider self-service portal, automated commission payouts, mobile app.

## Key User Action — Step by Step
1. Worker hits homepage → Supabase returns seeded provider listings (no login).
2. Worker enters amount + destination → app queries `comparisons` table logic, returns ranked results.
3. Worker clicks "Sign up" → Supabase Auth creates account → `users` row written with `referral_code`.
4. Worker copies referral link (`/ref/[code]`) → shares with friend.
5. Friend opens link → `referral_code` stored in cookie → friend signs up → `referrals` row created linking both.
6. Provider clicks "Partner with us" → fills lead form → `partnership_leads` row written.
7. Provider clicks "Pay" → Next.js API route creates Stripe session (server-side, key never in browser) → provider redirected to Stripe → on success webhook writes `checkout_sessions` row.

## Layer Plan
1. **Data first:** Tables + RLS + seed data → app is demoable.
2. **App logic:** Comparison ranking (rule-based: fee %, speed, rating).
3. **Smart features later:** AI-suggested best provider per user profile.

## Core Without AI
Comparison ranking is a SQL `ORDER BY` on `fee_pct, speed_hours, rating` — no AI dependency.
