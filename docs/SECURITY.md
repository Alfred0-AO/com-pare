# Security — com-pare

## Secrets
- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `RESEND_API_KEY`, `SUPABASE_SERVICE_ROLE_KEY` — server-side env vars only, never in client bundles or logs.
- Stripe session created exclusively in Next.js API route (`/api/checkout`), never from the browser.

## Permission Model
- **Anonymous visitor:** read published listings, create comparison, create lead (demo-first).
- **Authenticated user:** all of above + own profile, own referrals, own comparisons.
- **Provider:** manage their own listings and view their own leads.
- **Admin:** full read on all tables; can publish/unpublish providers.
- v1 RLS policies are permissive. Lock-down sprint scopes every write to `auth.uid() = user_id`.

## Approved-Tools Rule
Agents may only call the named tools listed in AGENTIC_LAYER.md. No raw SQL execution, no `send_any`, no `run_any`. Every tool call is logged to `audit_logs`.

## Audit Principle
Every state-changing action (lead created, payment confirmed, tier upgraded, listing published) writes a row to `audit_logs` with actor, tool, inputs, outputs, and timestamp. Logs are append-only; no delete policy on that table.

## Payments Safety
Stripe webhooks validated with `stripe.webhooks.constructEvent` before any DB write. Provider tier is only upgraded after `payment_intent.succeeded` or `checkout.session.completed` is verified.
