# Test Plan

## v1 Success Scenario (manual walkthrough)

### Setup
1. Open app homepage (no login) → confirm dashboard shows 3 demo worker cards with badges
2. Confirm at least one badge is yellow or red (seed data has near-expiry dates)

### Core Flow
3. Click "Add my details" → redirected to `/signup`
4. Sign up with `testworker@gmail.com` / `Test1234!`
5. Redirected to dashboard — new empty worker profile shown
6. Click "Add Permit" → fill in permit number, issue date `2023-06-15`, expiry `2025-06-14` → Save
7. Confirm permit card appears with green badge (>30 days remaining)
8. Click "Add PhilHealth" → fill in PHN, last contribution date yesterday → Save
9. Confirm PhilHealth card shows yellow badge (contribution overdue soon)
10. Click "Add Income" → category: Salary, amount: 650, date: today → Save
11. Confirm finance summary shows SGD 650 balance
12. Click "Upgrade" → Stripe Checkout opens in test mode
13. Enter card `4242 4242 4242 4242`, any future date, CVC 123 → Pay
14. Redirected to dashboard with "Pro" badge in nav and success toast
15. Confirm `subscriptions` row in Supabase has `plan = 'monthly'`, `status = 'active'`

### Empty State
16. Log in as a brand-new user with no records → each section shows empty state copy (not a blank screen)

### Error Cases
17. Submit permit form with expiry date in the past → form saves; badge shows 🔴 Expired
18. Submit finance entry with amount = 0 → validation error shown inline
19. Kill network mid-save → error toast appears; no duplicate row created on retry
20. Stripe webhook with invalid signature → request rejected with 400; no DB write

### Cross-User Isolation (post lock-down)
21. Log in as User A, add a permit → log out
22. Log in as User B → User A's permit is not visible
