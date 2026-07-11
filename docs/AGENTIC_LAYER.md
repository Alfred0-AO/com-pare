# Agentic Layer — com-pare

## Risk Levels & Actions

### Low — auto (no approval needed)
- Tag a listing's category from its title
- Compute and store `value_score` on listing save
- Generate referral code on user signup

### Medium — light approval (admin confirms)
- Mark a referral as converted after signup detected
- Flag a listing as stale if rate unchanged > 30 days
- Draft a "top deal this week" email to opted-in users

### High — approval required before execution
- Send lead-notification email to provider
- Upgrade provider tier after payment confirmed
- Publish a new provider listing live on site

### Critical — human only
- Issue refund to provider
- Delete user account and all associated data
- Change Stripe webhook signing secret

## Named Tools (approved list)
- `score_listing(listing_id)` — recalculate value_score
- `create_lead(user_id, provider_id, listing_id, action)` — insert lead row
- `send_lead_email(provider_id, lead_id)` — trigger Resend template
- `create_stripe_session(provider_id, tier)` — server-side only
- `upgrade_provider_tier(provider_id, tier)` — post webhook confirmation

## Audit Log Fields
`id, actor_id, tool_name, input_json, output_json, risk_level, approved_by, status, created_at`

## v1
Only `score_listing`, `create_lead`, and `create_stripe_session` active. All others queued for next sprint.
