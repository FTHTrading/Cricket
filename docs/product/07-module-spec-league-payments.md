# Module Spec: League Payments
## FutureTech Georgia Cricket Infrastructure Platform

`docs/product/07-module-spec-league-payments.md`  
**Owner:** FTH Product · **Version:** 1.0 · **Date:** April 2026

---

## Objective

Enable cricket leagues and clubs to collect, track, and reconcile all participation-related fees — team registration, player registration, tournament entry, and season dues — through a single managed payments system. Eliminate offline cash handling and manual tracking.

---

## Users

| Role | Use Case |
|------|----------|
| `league_admin` | Configure fee schedules; view payment status; run season-end reconciliation |
| `club_manager` | Pay team registration fees; view team payment status; manage player dues |
| `player` / member | Pay individual registration or dues; view payment history |
| `finance` | Generate payment reports; manage refunds; close settlement periods |

---

## Workflows

### 1. Season Setup (league_admin)
1. Admin creates a new season with start/end dates and format
2. Admin configures fee schedule: team registration fee, per-player fee, optional late fee
3. Admin publishes registration window with open and close dates
4. System generates payment links for each registered team

### 2. Team Registration and Payment (club_manager)
1. Club manager submits team registration form
2. System calculates fee based on fee schedule (team fee + number of players)
3. Club manager receives payment link and invoice
4. Payment is collected via Stripe (card) or invoice (ACH for larger amounts)
5. On successful payment: team status changes to `confirmed`; confirmation email sent to manager and league admin
6. If payment fails after 3 retries: team status moves to `pending_payment`; manager notified

### 3. Player Registration (club_manager or player)
1. Individual player registration submitted (by manager or player directly)
2. System validates player eligibility against league rules (age, previous season status, per-league configuration)
3. Per-player fee collected at registration (if configured)
4. Player receives confirmation email and league ID

### 4. Tournament Entry (club_manager)
1. Admin opens tournament registration window
2. Club manager submits entry form for team
3. Entry fee collected immediately via Stripe
4. On successful payment: team confirmed in bracket; spot reserved
5. After bracket close: no refunds (or per tournament policy — configurable)

### 5. Season-End Reconciliation (finance)
1. Finance runs reconciliation report at season close
2. Report shows: total fees collected, total refunds issued, outstanding balances, net settled
3. Finance exports CSV for accounting
4. Season is closed; registration window locked

---

## Permissions

| Action | `league_admin` | `club_manager` | `player` | `finance` |
|--------|:-:|:-:|:-:|:-:|
| Configure fee schedule | ✓ | — | — | — |
| View all payments | ✓ | — | — | ✓ |
| View own team payments | — | ✓ | — | — |
| View own payment | — | — | ✓ | — |
| Issue refunds | — | — | — | ✓ |
| Close season reconciliation | — | — | — | ✓ |
| Export reports | ✓ | — | — | ✓ |

---

## Key Fields

| Field | Type | Description |
|-------|------|------------|
| `season_id` | UUID | Season this payment belongs to |
| `tenant_id` | UUID | League tenant |
| `payer_id` | UUID | User or team paying |
| `fee_type` | Enum | `team_registration` \| `player_registration` \| `tournament_entry` \| `dues` |
| `amount` | Integer (cents) | Payment amount; stored in smallest currency unit |
| `currency` | String | `usd` (default) |
| `status` | Enum | `pending` \| `captured` \| `refunded` \| `failed` \| `waived` |
| `gateway_reference` | String | Stripe payment intent ID or ACH reference |
| `invoice_number` | String | Auto-generated invoice number for ACH flows |
| `due_date` | Date | Payment due date (for invoice flows) |
| `paid_at` | Timestamp | Payment capture timestamp |

---

## Failure Cases

| Failure | System Response |
|---------|----------------|
| Card declined | Stripe returns decline code; user presented with error; retry with different payment method |
| Payment times out | Intent expires after 24 hours; team/player status reverts to `pending_payment` |
| Partial fee (split payment across players) | Supported — batch registration allows individual player payments within a team registration |
| Refund after close | Finance-only action; requires manual override with documented reason |
| Duplicate submission | System checks for existing active registration before creating new payment intent |
| ACH return (NSF) | Payment reverts to `failed`; manager notified; team status reverts to `pending_payment` |

---

## Reports

| Report | Audience | Frequency | Format |
|--------|----------|-----------|--------|
| Season payment summary | `league_admin`, `finance` | On demand + season close | PDF, CSV |
| Team payment detail | `club_manager` | On demand | PDF |
| Outstanding balance report | `league_admin`, `finance` | On demand | CSV |
| Refund log | `finance` | On demand | CSV |
| Reconciliation report | `finance` | Season close | PDF + CSV |

---

## MVP Scope

- Team and player registration with fee collection via Stripe (card only)
- Invoice generation for ACH (manual follow-up)
- Payment status tracking (pending, confirmed, failed)
- Basic confirmation emails
- Season-end reconciliation CSV export

## Future Scope

- Automatic ACH via Plaid for club-level payments
- Late fees and deadline enforcement automation
- Split payment (player-pays-own-fee mode)
- Scholarship and waiver workflow
- Multi-currency (for international expansion)
- Onchain payment receipt hooks (Capital Markets OS phase)

---

## APIs and Services Touched

- `POST /api/leagues/{id}/seasons/{id}/registrations` — create registration
- `POST /api/payments/intents` — create Stripe payment intent
- `GET /api/payments/{id}/status` — poll status
- `POST /api/payments/{id}/refund` — issue refund (finance role)
- `GET /api/leagues/{id}/seasons/{id}/reconciliation` — reconciliation report
- Stripe Webhooks: `payment_intent.succeeded`, `payment_intent.payment_failed`, `charge.dispute.created`

---

## Security and Audit Notes

- Payment card data never stored in FTH systems — handled exclusively by Stripe
- Every payment status change writes to the immutable event log
- Refunds require `finance` role and write an audit entry with actor ID and reason
- PCI-DSS compliance maintained via Stripe scope isolation
- All payment amounts stored in cents (integer) to avoid floating-point precision errors
