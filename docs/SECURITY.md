# Security

## Secret Handling
- Stripe secret key and Resend API key stored only in Vercel environment variables — never in frontend code or git
- Supabase service-role key used only in Next.js API routes (server-side), never passed to the browser
- Only the Supabase `anon` key is exposed to the client

## Permission Model
- **v1 (demo):** permissive RLS — any visitor can read/write (seed data visible, demo usable)
- **Lock-down sprint:** RLS policies replaced with `auth.uid() = user_id`; workers without a session get zero rows
- Stripe webhooks verified with `stripe.webhooks.constructEvent` using the webhook signing secret

## Approved-Tools Rule
- No `eval`, no `run_any`, no dynamic SQL construction from user input
- All DB writes go through typed Supabase client calls in server actions
- Agent actions limited to the named tools listed in AGENTIC_LAYER.md

## Audit Principle
- Every create / update / delete writes a row to `audit_logs` with before/after values
- Stripe events logged as audit entries with `action = 'stripe_event'` and raw payload in `new_value`
- Logs are append-only; no delete policy on `audit_logs` table
