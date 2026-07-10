# PRD — com-pare

## Problem
Filipino workers in Singapore lack a single place to compare remittance centres and service providers. Service providers (remittance shops, telcos, etc.) have no cost-effective way to reach this community. There is no referral or monetisation bridge between the two.

## Target User
- **Primary:** Filipino workers in Singapore (OFW / Phil Workers) seeking best remittance rates and services
- **Secondary:** Remittance centres and service providers willing to pay for qualified leads

## Core Objects
- **User** — worker who signs up and compares services
- **ServiceProvider** — remittance centre or sponsor listing
- **Comparison** — a user's rate/service lookup session
- **Referral** — a user inviting another user (with tracking code)
- **PartnershipLead** — a service provider expressing interest in a paid partnership
- **CheckoutSession** — payment record for a provider's partnership fee

## MVP Checklist (v1 must-haves)
- [ ] Landing page shows live service provider listings (no login required)
- [ ] User can run a remittance comparison (currency, amount, provider)
- [ ] User can sign up and get a unique referral link
- [ ] Referred friend signup is tracked to referrer
- [ ] Service provider can submit a partnership enquiry
- [ ] Admin can view referral counts and provider leads
- [ ] Stripe checkout flow for provider partnership fee

## Non-Goals (v1)
- Real-time exchange rate API integration
- In-app messaging between users and providers
- Mobile native app
- Multi-currency wallet

## Success Criteria
A Filipino worker lands on the homepage, runs a remittance comparison, signs up, copies their referral link, shares it, a friend signs up via that link — both appear in the admin dashboard. A remittance centre submits a partnership lead and completes a Stripe payment. All steps persist to the database and are visible in the UI without a page reload.
