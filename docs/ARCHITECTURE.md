# Architecture — com-pare

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Backend/DB:** Supabase (Postgres + Auth + Realtime)
- **Payments:** Stripe Checkout (server-side session creation only)
- **Email:** Resend (transactional)

## Now vs Later
**Now:** listings page, comparison widget, referral signup flow, lead capture, Stripe partnership checkout, admin dashboard
**Later:** provider self-service portal, rate-change alerts, AI rate ranking, SMS/WhatsApp nudges, loyalty rewards

## Key User Action — Step by Step
1. Visitor lands on `/` → Supabase returns published `listings` rows
2. User selects 2–4 listings → client builds `comparison` record in DB
3. User clicks "Share" → referral link generated from `users.referral_code`
4. Friend opens `/ref/[code]` → `referrals` row created (status: pending)
5. Friend signs up → referral status → converted, referrer count incremented
6. User clicks "Contact Provider" → `leads` row inserted, provider email triggered
7. Provider visits `/partner` → Stripe Checkout session created server-side
8. Stripe webhook → `payments` row confirmed → provider tier upgraded

## Layer Plan
1. **Data first** — tables, RLS, seed data (this sprint)
2. **App logic** — CRUD routes, comparison engine, referral tracking, lead capture
3. **Payments** — Stripe checkout + webhook
4. **Smart features** — AI rate scoring, auto-rank listings by value

## Core Without AI
The comparison, referral, and lead flows are pure rule-based SQL queries. AI ranking is additive — removing it shows the same listings in insertion order.
