# Com-pare — Product Requirements Document

## Problem
Filipino domestic workers and FDWs in Singapore juggle multiple government memberships and deadlines across different platforms: MOM work permit expiry, OWWA membership renewal, PhilHealth contributions, and personal finances. Missing any one of these has real legal and financial consequences. There is no single place to track all of them.

## Target User
Filipino workers (FDW / OFW) currently employed in Singapore, aged 25–45, primarily phone users, sending remittances home monthly.

## Core Objects
- **Worker profile** — the user's personal record
- **Permit record** — MOM work permit number, issue/expiry dates
- **OWWA record** — membership number, validity window
- **PhilHealth record** — PHN, last contribution date, quarters paid
- **Finance entry** — income or expense log (SGD)
- **Subscription** — free or paid plan, Stripe link

## MVP Must-Haves
- [ ] Dashboard: permit, OWWA, PhilHealth, and wallet summary — colour-coded by expiry urgency
- [ ] Manual entry forms for all four tracked items
- [ ] Finance log: add income or expense, see running balance
- [ ] User sign-up / login
- [ ] Stripe checkout for monthly (SGD 4.90) or annual (SGD 39) plan
- [ ] Paid tier gates: history log beyond last 3 entries + email alerts
- [ ] App is viewable with demo data before login

## Non-Goals (v1)
- OCR / photo parsing of permit cards
- SSS tracking
- Agency / multi-worker admin panel
- Mobile native app
- Automated renewal submissions

## Success Criteria
A worker signs up, enters her MOM permit expiry date and latest PhilHealth contribution, completes Stripe checkout for the monthly plan, and sees her dashboard with a green/yellow/red status badge — all data persisted and correct on page refresh.
