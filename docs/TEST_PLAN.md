# Test Plan — com-pare

## Success Scenario (manual, run after Sprint 2)
1. Open `https://com-pare.vercel.app` in incognito — listings appear, no login prompt.
2. Select listing A and listing B → click Compare → side-by-side table renders, Supabase `comparisons` row exists.
3. Click "Sign Up" → enter name + phone → account created, referral code shown (e.g. `PHIL-4X2K`).
4. Copy referral link `/ref/PHIL-4X2K`, open in second incognito window → `referrals` row created with status=pending.
5. Complete signup in second window → row status = converted, original user's `referral_count` = 1.
6. In second window, click "Contact Provider" on a listing → `leads` row appears in Supabase with correct `user_id` and `provider_id`.
7. Visit `/partner`, select a tier, click Pay → redirected to Stripe test checkout, complete with card `4242 4242 4242 4242` → redirected back, `payments` row status = confirmed, provider badge = Featured.
8. Open `/admin` → user count ≥1, referral count ≥1, lead count ≥1, revenue > 0.

## Empty States
- No listings in DB → homepage shows "No listings yet. Check back soon."
- No referrals yet → referral page shows "Share your link to get started."

## Error States
- Supabase unreachable → listings page shows "Unable to load listings. Try refreshing."
- Stripe webhook invalid signature → 400 returned, no DB write, error logged.
- User submits comparison with <2 listings → inline validation, form blocked.

## Permission Check (Sprint 4)
- Log in as User A; attempt direct Supabase query for User B's comparison → 0 rows returned.
- Unauthenticated POST to `/api/checkout` with spoofed provider_id → 401 returned.
