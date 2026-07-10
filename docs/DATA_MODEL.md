# Data Model — com-pare

## users
| field | type | notes |
|---|---|---|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid | nullable, Supabase auth link |
| display_name | text | |
| email | text | unique |
| referral_code | text | unique, generated on signup |
| referred_by_code | text | nullable |
| created_at | timestamptz | default now() |

## service_providers
| field | type | notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| name | text | e.g. "Western Union Orchard" |
| category | text | remittance / telco / insurance |
| fee_pct | numeric | |
| speed_hours | numeric | typical transfer time |
| rating | numeric | 1–5 |
| website_url | text | |
| is_partner | boolean | paid partner flag |
| created_at | timestamptz | |

## comparisons
| field | type | notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| amount_sgd | numeric | |
| destination_country | text | |
| results_snapshot | jsonb | ranked providers at time of search |
| created_at | timestamptz | |

## referrals
| field | type | notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable (referrer's users.id) |
| referee_user_id | uuid | nullable (new user's users.id) |
| referral_code | text | |
| status | text | pending / confirmed |
| created_at | timestamptz | |

## partnership_leads
| field | type | notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| provider_name | text | |
| contact_email | text | |
| message | text | |
| status | text | new / contacted / converted |
| created_at | timestamptz | |

## checkout_sessions
| field | type | notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| partnership_lead_id | uuid | FK to partnership_leads |
| stripe_session_id | text | |
| amount_sgd | numeric | |
| status | text | pending / paid / failed |
| created_at | timestamptz | |

## RLS
All tables: `enable row level security`. v1 permissive read+write policies for demo. Lock-down sprint replaces with `auth.uid() = user_id` owner policies.
