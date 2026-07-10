# Intelligence Layer — com-pare

## Messy Input → Structured Data
User types: "send 500 to Manila" → parsed to `{amount_sgd: 500, destination_country: 'Philippines'}`.

## Auto-Structure Schema (JSON example)
```json
{
  "amount_sgd": 500,
  "destination_country": "Philippines",
  "ranked_providers": [
    {"provider_id": "uuid", "score": 0.91, "fee_pct": 1.2, "speed_hours": 2, "rating": 4.8}
  ]
}
```
Stored in `comparisons.results_snapshot`.

## Events to Track
- `comparison_run` — amount, country, result count
- `referral_link_copied` — referrer user_id
- `referral_signup_confirmed` — referee user_id, referral_code
- `partnership_lead_submitted` — provider name, category
- `checkout_completed` — amount, provider

## Scoring Rules (v1 — rule-based, no AI)
```
Score = (1 - fee_pct/max_fee)*0.5 + (1 - speed_hours/max_speed)*0.3 + (rating/5)*0.2
```
Higher score = ranked first. Stored as `confidence numeric` on the snapshot row (value = score, source = 'rule_engine', review_status = 'unreviewed').

## What Gets Ranked
- Service providers per comparison query (fee, speed, rating)
- Partnership leads by conversion likelihood (later)

## v1 vs Later
- **v1:** Rule-based scoring SQL, snapshot stored in jsonb.
- **Later:** AI re-ranks based on user profile (remittance history, destination, preferred speed). AI fields get `value + source + confidence + review_status` columns.
