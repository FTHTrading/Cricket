# Module Spec: Membership Wallet
## FutureTech Georgia Cricket Infrastructure Platform

`docs/product/09-module-spec-membership-wallet.md`  
**Owner:** FTH Product · **Version:** 1.0 · **Date:** April 2026

---

## Objective

Create persistent, recurring-revenue membership accounts for cricket league participants, venue attendees, and community members — converting episodic ticket buyers and seasonal registrants into ongoing commercial relationships with measurable lifetime value.

---

## Users

| Role | Use Case |
|------|----------|
| `member` | Enroll; manage account; view benefits; renew; purchase upgrades |
| `venue_operator` / `league_admin` | Configure membership tiers; view member roster; manage benefits; run enrollment campaigns |
| `finance` | Track recurring revenue; manage refunds and cancellations; generate membership reports |
| `platform_admin` | Manage multi-tenant membership configurations |

---

## Membership Tier Model

Each tenant (venue or league) configures its own tier structure. Default tier model:

| Tier | Target | Price Range | Core Benefits |
|------|--------|------------|---------------|
| **General Member** | Casual fans and players | $25–$75/yr | Discounted ticket access; member newsletter; early event notice |
| **Season Member** | Active players and regular attendees | $100–$250/yr | All General benefits; reserved seating area; discounted registration fees; member badge |
| **Premium Member** | High-engagement fans and sponsors | $500–$1,500/yr | All Season benefits; premium seating; concession credits; named recognition; partner perks |
| **Founding Member** | Early supporters and anchor community | Configurable | All Premium benefits; permanent founding recognition; priority suite access; potential later-stage commercial participation |

Founding Member tier is the highest-value product and the category most likely to connect to later capital-markets structures (after gating criteria are met).

---

## Workflows

### 1. Membership Enrollment (member)
1. Member selects tier from league or venue membership page
2. Member creates an account (or logs in if existing)
3. Member enters payment details (Stripe card or saved ACH)
4. System creates membership record with start date, tier, and benefits
5. Stripe subscription created for recurring billing
6. Confirmation email with membership ID, benefits summary, and welcome content sent
7. Member profile updated with membership badge and tier

### 2. Recurring Billing (automated)
1. Stripe subscription auto-renews on annual or monthly cycle
2. On successful renewal: `renewal.success` event logged; member notified; membership end date extended
3. On failed renewal (card decline): member notified with retry link; 3 retries over 7 days; if all fail, membership moves to `lapsed`
4. Lapsed member retains read-only access during 14-day grace period; then access revoked

### 3. Tier Upgrade (member)
1. Member selects upgrade from dashboard
2. System calculates prorated amount for remaining period
3. Member confirms and pays prorated upgrade fee
4. Membership tier updated immediately; new benefits activated
5. Upgrade event logged; confirmation sent

### 4. Benefit Redemption (member + venue_operator)
1. Member presents digital membership pass (QR code in app or email) at gate
2. QR scanner at venue reads membership ID
3. System validates: is membership active? What tier? What benefits apply at this event?
4. Gate operator applies appropriate access (member lane, reserved area, concession credit)
5. Benefit redemption event logged

### 5. Enrollment Campaign (venue_operator / league_admin)
1. Admin creates campaign: targeted tier, discount code or promotional price, campaign window
2. Campaign link generates a pre-configured enrollment flow with promotional pricing applied
3. Sign-ups tracked against campaign ID for attribution
4. Campaign report shows: enrollments, revenue, tier breakdown, source channel

### 6. Member Roster Management (venue_operator / league_admin)
1. Admin views full member roster with tier, status, join date, last renewal
2. Admin can manually extend, cancel, or pause individual memberships (with audit trail)
3. Admin can export roster to CSV for offline use
4. Admin can send bulk email to a tier or status segment via the platform

---

## Permissions

| Action | `platform_admin` | `venue_operator` / `league_admin` | `member` | `finance` |
|--------|:-:|:-:|:-:|:-:|
| Configure tiers | ✓ | ✓ | — | — |
| Enroll new member | ✓ | ✓ | ✓ (self) | — |
| View full roster | ✓ | ✓ | — | ✓ |
| View own membership | — | — | ✓ | — |
| Upgrade tier | — | ✓ | ✓ (self) | — |
| Cancel membership | ✓ | ✓ | ✓ (self) | — |
| Issue refund | ✓ | — | — | ✓ |
| Generate reports | ✓ | ✓ | — | ✓ |
| Send bulk email | — | ✓ | — | — |

---

## Key Fields

### Membership Record

| Field | Type | Description |
|-------|------|-------------|
| `membership_id` | UUID | Unique membership record |
| `tenant_id` | UUID | League or venue tenant |
| `user_id` | UUID | Member's user account |
| `tier` | Enum | `general` \| `season` \| `premium` \| `founding` |
| `status` | Enum | `active` \| `lapsed` \| `cancelled` \| `paused` \| `grace_period` |
| `start_date` | Date | Enrollment date |
| `end_date` | Date | Current period end date |
| `stripe_subscription_id` | String | Stripe subscription reference |
| `benefits` | JSON | Active benefit configuration for this tier |
| `membership_number` | String | Human-readable membership ID (displayed on pass) |
| `enrolled_via` | String | `direct` \| `campaign_{id}` \| `admin` |

### Benefit Redemption Log

| Field | Type | Description |
|-------|------|-------------|
| `redemption_id` | UUID | Record identifier |
| `membership_id` | UUID | Membership redeemed |
| `event_id` | UUID | Event where redemption occurred |
| `benefit_type` | Enum | `admission` \| `reserved_seating` \| `concession_credit` \| `registration_discount` |
| `redeemed_at` | Timestamp | Redemption timestamp |
| `redeemed_by` | UUID | Staff user who validated (if gate-scanned) or system (if auto) |

---

## Failure Cases

| Failure | Response |
|---------|----------|
| Renewal payment fails | Retry logic: 3 attempts over 7 days; member notified at each failure; after day 7 grace period begins |
| QR code presented at wrong event | System validates event scope; member sees "benefit not valid at this event" message |
| Duplicate enrollment | System detects existing active membership for same user+tenant; blocks duplicate; prompts upgrade flow instead |
| Member disputes charge | Finance initiates Stripe dispute workflow; membership paused pending resolution; not cancelled until dispute resolved |
| Tier configuration mismatch | Admin must explicitly confirm tier change if benefits are being reduced; audit trail captures reason |
| Concession credit over-redemption | Credit balance tracked per event; system blocks redemption at $0 balance |

---

## Reports

| Report | Audience | Frequency | Format |
|--------|----------|-----------|--------|
| Active membership roster | `venue_operator`, `finance` | On demand | CSV |
| Tier distribution summary | `venue_operator`, `league_admin` | On demand | PDF, CSV |
| Monthly recurring revenue | `finance` | Monthly | PDF, CSV |
| Churn and lapse report | `venue_operator`, `finance` | Monthly | CSV |
| Campaign enrollment report | `venue_operator` | Per campaign | PDF, CSV |
| Benefit redemption log | `venue_operator` | Per event | CSV |
| Lifetime value summary (anonymized) | `platform_admin` | Quarterly | Internal PDF |

---

## MVP Scope

- General, Season, and Premium tiers (Founding tier as admin-created manual)
- Stripe recurring subscriptions (annual only in MVP)
- Membership QR pass (email-delivered)
- Basic member dashboard (status, benefits, renewal date)
- Basic admin roster view
- Renewal success/failure emails

## Future Scope

- Mobile app with native QR pass (iPhone Wallet / Google Wallet integration)
- Monthly billing cadence with prorated pricing
- Founding Member enrollment flow with additional onboarding steps
- Benefit marketplace (members purchase add-ons)
- Member referral program
- Tier-linked access to Capital Markets OS founding-member structures (later stage, gated)
- Multi-venue / multi-league membership bundles

---

## APIs and Services Touched

- `POST /api/memberships` — create membership
- `GET /api/memberships/{id}` — get membership status and benefits
- `POST /api/memberships/{id}/upgrade` — tier upgrade
- `POST /api/memberships/{id}/cancel` — cancel
- `POST /api/memberships/{id}/redemptions` — log benefit redemption
- `GET /api/memberships/{id}/pass` — generate QR pass (signed URL)
- Stripe Webhooks: `customer.subscription.updated`, `invoice.paid`, `invoice.payment_failed`

---

## Security and Audit Notes

- QR pass tokens are signed with a server-side secret; cannot be forged or reused across events
- Pass tokens include event scope if benefit is event-specific (prevents cross-event pass sharing)
- All tier changes, cancellations, and admin overrides write to the immutable event log with actor ID
- Stripe subscription IDs stored; card data never stored in FTH database
- Member PII (email, phone, DOB) encrypted at rest; access restricted to authorized roles
