# Intelligence Layer — com-pare

## Messy Inputs
- Provider submits rate as free text (e.g. "5.68 send 200-500")
- Promo text varies wildly in format
- Referral quality unknown at signup

## Auto-Structure Schema (example JSON)
```json
{
  "listing_id": "uuid",
  "extracted_rate": 5.68,
  "extracted_fee": 2.50,
  "promo_keywords": ["no fee", "weekend bonus"],
  "value_score": 87,
  "value_score_source": "rule:rate*0.7+fee_inverse*0.3",
  "value_score_confidence": 0.91,
  "value_score_review_status": "unreviewed"
}
```

## Events to Track
- Listing viewed
- Comparison created
- Lead clicked
- Referral converted
- Payment completed

## Scoring Rules (v1 — rule-based)
`value_score = (exchange_rate × 0.6) + (1/fee_sgd × 0.4)` normalised 0–100

## What Gets Ranked
- Listings on homepage sorted by `value_score DESC`
- Providers ranked in admin by lead count and revenue generated

## v1 vs Later
- **v1:** rule-based score computed on insert/update
- **Later:** LLM extracts rate from free-text, detects promo sentiment, personalises ranking by user send history
