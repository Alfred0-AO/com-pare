# Agentic Layer

## Risk Levels & Actions

### Low — Auto (no approval needed)
- Tag a finance entry with a category based on description keywords
- Compute and display urgency badge from stored dates
- Draft renewal reminder copy (shown to user before sending)

### Medium — Light Approval (user confirms)
- Create a new permit, OWWA, or PhilHealth record from a parsed photo
- Update status to 'expired' when expiry_date passes (nightly job, user notified)

### High — Always Approval (explicit user tap)
- Send expiry alert email to user → user opts in per alert type
- Initiate Stripe checkout session → user must click through payment UI

### Critical — Human Only
- Delete any record (worker, permit, finance)
- Refund a subscription payment
- Export all user data (PDPA request)

## Named Tools (approved, no raw exec)
- `send_expiry_alert(worker_id, alert_type)` — Resend email, rate-limited
- `create_stripe_checkout(worker_id, plan)` — returns URL, no charge until user completes
- `update_subscription_status(worker_id, status)` — called by Stripe webhook only
- `compute_urgency_badges(worker_id)` — pure read, returns badge data

## Audit Log Fields
Every meaningful action writes: `action`, `table_name`, `record_id`, `old_value`, `new_value`, `user_id`, `ip_address`, `created_at`

## v1 vs Later
- **v1:** only `compute_urgency_badges` and `create_stripe_checkout` are live
- **Later:** `send_expiry_alert` (Sprint 3), OCR parse tool (Later)
