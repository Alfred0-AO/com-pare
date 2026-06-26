# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + Auth:** Supabase (Postgres + RLS + Storage)
- **Payments:** Stripe Checkout + Webhooks
- **Email:** Resend (transactional alerts)

## What to Build Now vs Later
**Now:** dashboard, manual entry forms, expiry badges, auth, Stripe checkout
**Next:** email/push alerts, document photo uploads, expense charts
**Later:** OCR permit parsing, AI-suggested renewal reminders, agency multi-worker view

## Key User Action — Step by Step
1. Worker opens app → sees demo dashboard (no login required)
2. She taps "Add my details" → signs up with email/password
3. Enters permit expiry date → saved to `permit_records` linked to her `worker` row
4. Enters PhilHealth contribution → saved to `philhealth_records`
5. Dashboard re-renders with her real data and colour-coded badges
6. She taps "Upgrade" → Stripe Checkout opens → payment captured
7. Stripe webhook fires → `subscriptions.plan` set to `monthly`
8. Full history and alerts unlocked in UI

## Layer Plan
1. **Data first:** tables + RLS + seed rows → dashboard renders
2. **App logic:** forms persist to DB; badge logic is pure date arithmetic (no AI needed)
3. **Smart features later:** expiry predictions, spending pattern summaries

## Why Core Runs Without AI
All status badges are computed from stored dates (`expiry_date < now() + 30 days`). Finance balance is a SQL sum. The app is fully functional with zero ML.
