# Security — com-pare

## Secret Handling
- `STRIPE_SECRET_KEY`, `SUPABASE_SERVICE_ROLE_KEY` — server-side only, in Vercel env vars, never shipped to the browser.
- Client uses only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
- Stripe session creation happens exclusively in a Next.js API route (`/api/checkout`), never in client code.

## Permission Model
- **v1 (demo):** Permissive RLS policies — any visitor can read and write. Safe because no PII or payment data is stored client-side.
- **Lock-down sprint:** Replace all `using (true)` policies with `auth.uid() = user_id`. Comparisons and referrals become owner-scoped.
- **Admin views:** Protected by Supabase service role on server routes; no admin UI exposed to anonymous users.

## Approved-Tools Rule
- Only named tools listed in `AGENTIC_LAYER.md` may be called by automated logic.
- No `eval`, no dynamic SQL construction from user input, no `run_any` / `send_any` patterns.
- Stripe webhook endpoint validates `stripe-signature` header before acting.

## Audit Principle
- Every state change to `partnership_leads`, `checkout_sessions`, `referrals`, and `service_providers` writes an `audit_logs` row.
- Audit rows are append-only (no update/delete RLS policy on `audit_logs`).
- If a payment action is genuinely beyond the builder's expertise, stop and engage a payments specialist before going live.
