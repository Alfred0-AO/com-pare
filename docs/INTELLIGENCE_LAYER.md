# Intelligence Layer

## Messy Inputs
- User types permit expiry as "June 2025" or "06/2025" → normalise to ISO date
- Category is free text → map to enum (remittance / food / transport / other)
- OWWA contribution amount entered in USD or PHP → store in SGD equivalent

## Auto-Structure Schema (example)
```json
{
  "permit_expiry_raw": "June 14 2025",
  "permit_expiry_parsed": "2025-06-14",
  "days_remaining": 71,
  "urgency": "yellow",
  "source": "user_input",
  "confidence": 1.0,
  "review_status": "unreviewed"
}
```

## Events to Track
- `permit_date_entered` — worker adds or updates expiry
- `owwa_renewed` — new OWWA record created
- `philhealth_contribution_logged`
- `finance_entry_added`
- `subscription_activated`
- `alert_sent` — expiry notification fired

## Scoring Rules (v1 — rule-based, no ML)
| Condition | Badge |
|---|---|
| expiry_date < today | 🔴 Expired |
| expiry_date ≤ today + 30 days | 🟡 Renew Soon |
| expiry_date > today + 30 days | 🟢 Valid |

Same rule applies to OWWA `valid_until` and PhilHealth `last_contribution_date + 90 days`.

## What Gets Ranked
- Dashboard card order: most urgent expiry first
- Finance: most recent entries first

## v1 vs Later
- **v1:** all scoring is date arithmetic in SQL/JS
- **Later:** ML model predicts optimal renewal month based on historical patterns; OCR extracts dates from permit photos
