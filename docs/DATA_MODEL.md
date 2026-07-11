# Data Model — com-pare

## users
| field | type |
|---|---|
| id | uuid PK |
| user_id | uuid nullable |
| full_name | text |
| phone | text |
| referral_code | text unique |
| referred_by | uuid → users.id nullable |
| referral_count | int default 0 |
| created_at | timestamptz |

## providers
| field | type |
|---|---|
| id | uuid PK |
| user_id | uuid nullable |
| business_name | text |
| category | text | *(remittance, insurance, telecom, loans)*
| contact_email | text |
| partnership_tier | text default 'free' |
| payout_rate | numeric | *commission % per lead*
| is_active | bool default true |
| created_at | timestamptz |

## listings
| field | type |
|---|---|
| id | uuid PK |
| user_id | uuid nullable |
| provider_id | uuid → providers.id |
| title | text |
| exchange_rate | numeric |
| fee_sgd | numeric |
| promo_text | text |
| value_score | numeric | *(AI)*
| value_score_source | text |
| value_score_confidence | numeric |
| value_score_review_status | text default 'unreviewed' |
| is_published | bool default true |
| created_at | timestamptz |

## comparisons
| id, user_id, listing_ids jsonb, created_at |

## referrals
| id, user_id (referrer), referred_user_id, referral_code, status (pending/converted), created_at |

## leads
| id, user_id, provider_id, listing_id, action (click/inquiry), created_at |

## payments
| id, user_id, provider_id, stripe_session_id, amount_sgd, status, created_at |

## RLS
All tables: v1 permissive read+write (open for demo). Lock-down sprint replaces with `auth.uid() = user_id`.
