# Agentic Layer — com-pare

## Risk Levels & Actions

### Low — Auto (no approval needed)
- Tag a new `partnership_lead` as `new` on insert
- Score and rank providers on each comparison run
- Generate `referral_code` on user signup

### Medium — Light Approval (admin confirms before executing)
- Mark a `partnership_lead` status as `contacted` → sends follow-up email draft
- Flag a provider listing as `is_partner = true` after payment confirmed

### High — Always Approval (admin must explicitly approve)
- Send outbound email to a provider contact
- Trigger Stripe refund on a checkout session

### Critical — Human Only
- Delete a user or provider record
- Issue a legal notice or data export
- Manual override of any payment

## Named Tools (approved list)
- `rank_providers(amount, country)` — query + score providers
- `generate_referral_code(user_id)` — deterministic short code
- `create_stripe_session(lead_id, amount)` — server-side only
- `update_lead_status(lead_id, status)` — medium, requires admin token
- `send_partner_email_draft(lead_id)` — high, queues draft for approval

## Audit Log Fields
`id, actor_user_id, action, target_table, target_id, old_value jsonb, new_value jsonb, risk_level, approved_by, created_at`

## v1 vs Later
- **v1:** Low-risk auto actions only (rank, code gen, lead tagging).
- **Later:** Medium/high actions with approval queue UI; webhook-triggered agent on Stripe success.
