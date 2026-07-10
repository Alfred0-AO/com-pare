# Test Plan — com-pare

## Success Scenario (manual, run in order)
1. Open `https://com-pare.vercel.app` — provider listing loads without login. **Pass:** ≥3 providers shown.
2. Enter "500 SGD → Philippines" in comparison form, submit. **Pass:** ranked results appear; row in `comparisons` table with `amount_sgd=500`.
3. Click "Sign up", enter name/email/password. **Pass:** redirected to dashboard; `users` row exists with non-null `referral_code`.
4. Copy referral link (`/ref/[code]`), open in incognito. **Pass:** page loads, cookie set with referral code.
5. Sign up new account in incognito. **Pass:** `referrals` row exists linking both user IDs, `status = confirmed`.
6. Navigate to `/partner`. Fill "Western Union Test" lead form, submit. **Pass:** `partnership_leads` row with `status = new`.
7. Click "Pay SGD 500 partnership fee" → Stripe test checkout. Use card `4242 4242 4242 4242`. **Pass:** redirected to success page; `checkout_sessions.status = paid`; `service_providers.is_partner = true`.

## Empty States
- No providers seeded → homepage shows "No providers listed yet. Check back soon."
- Comparison with 0 results → "No providers found for this route yet."
- No referrals yet → dashboard shows "Share your link to start earning."

## Error Cases
- Comparison form submitted empty → inline validation "Enter an amount and select a destination."
- Stripe checkout cancelled → redirected to `/partner?status=cancelled`, lead row preserved.
- Duplicate referral code signup → graceful error "This referral link has already been used."
- `/api/checkout` called without lead_id → returns 400 JSON error, never exposes Stripe key.

## Permissions Check (post Sprint 4)
- Log in as User A; navigate to User B's comparison URL → returns 404 or empty.
- Non-admin hits `/admin/leads` → redirected to homepage.
