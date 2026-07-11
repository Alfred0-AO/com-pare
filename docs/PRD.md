# PRD — com-pare

## Problem
Filipino workers in Singapore struggle to find and compare remittance centres and other services (insurance, loans, SIM cards). Service providers have no cheap, targeted channel to reach this audience.

## Target User
- **Primary:** Filipino OFW (overseas Filipino worker) in Singapore — needs to compare remittance rates, fees, and promos.
- **Secondary:** Service providers (remittance centres, insurers, telecoms) willing to pay for qualified leads.

## Core Objects
- **User** — profile, referral code, referral count
- **Provider** — business name, category, contact, partnership tier, payout rate
- **Listing** — provider's published rate/offer shown to users
- **Comparison** — user's saved side-by-side of ≥2 listings
- **Referral** — who invited whom, status (pending/converted)
- **Lead** — user click-through or inquiry sent to a provider, billable event
- **Payment** — Stripe checkout session for provider partnership fee

## MVP Must-Haves
- [ ] Homepage shows live listings (no login required)
- [ ] User can compare ≥2 listings side-by-side
- [ ] User registers, gets unique referral link
- [ ] Referred friend signs up via link → referral recorded
- [ ] User clicks "Contact Provider" → lead created, provider notified
- [ ] Provider can pay partnership fee via Stripe checkout
- [ ] Admin sees dashboard: user count, referral count, lead count, revenue

## Non-Goals (v1)
- Mobile app, SMS notifications, loyalty points, multi-currency beyond SGD→PHP

## Success Criteria
A Filipino worker visits the site, compares two remittance listings, shares their referral link with a friend who signs up, clicks through to a provider — and that lead is recorded and visible in the admin dashboard. One provider completes a Stripe payment for a partnership slot. All of this works end-to-end in production.
