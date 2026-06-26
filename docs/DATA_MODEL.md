# Data Model

## workers
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | set after auth, used for RLS lockdown |
| full_name | text | |
| fin_number | text | Singapore FIN |
| nationality | text | default 'Filipino' |
| employer_name | text | |
| created_at | timestamptz | |

## permit_records
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| worker_id | uuid FK → workers | |
| permit_type | text | 'Work Permit' / 'S Pass' |
| permit_number | text | |
| issue_date | date | |
| expiry_date | date | drives badge colour |
| status | text | active / expired |

## owwa_records
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| worker_id | uuid FK → workers | |
| membership_number | text | |
| valid_from | date | |
| valid_until | date | drives badge |
| contribution_amount | numeric | USD amount paid |
| status | text | |

## philhealth_records
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| worker_id | uuid FK → workers | |
| philhealth_number | text | |
| last_contribution_date | date | |
| last_contribution_amount | numeric | PHP |
| quarters_paid | integer | |
| status | text | |

## finance_entries
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| worker_id | uuid FK → workers | |
| entry_type | text | 'income' or 'expense' |
| category | text | salary / remittance / food / transport / other |
| amount_sgd | numeric | |
| description | text | |
| entry_date | date | |

## subscriptions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| worker_id | uuid FK → workers | |
| stripe_customer_id | text | |
| stripe_subscription_id | text | |
| plan | text | free / monthly / annual |
| status | text | active / cancelled / past_due |
| current_period_end | timestamptz | |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| worker_id | uuid nullable | |
| action | text | e.g. 'permit_updated', 'subscription_activated' |
| table_name | text | |
| record_id | uuid | |
| old_value | jsonb | |
| new_value | jsonb | |
| ip_address | text | |

### AI Fields (future)
Any AI-generated field (e.g. `predicted_renewal_date`) stores:
- `value` — the prediction
- `source` — model name / rule name
- `confidence` — 0.0–1.0
- `review_status` — 'unreviewed' / 'accepted' / 'rejected'

### RLS
v1: permissive read+write for demo. Lock-down sprint replaces with `auth.uid() = user_id`.
