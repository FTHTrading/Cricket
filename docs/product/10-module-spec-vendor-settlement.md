# Module Spec: Vendor Settlement
## FutureTech Georgia Cricket Infrastructure Platform

`docs/product/10-module-spec-vendor-settlement.md`  
**Owner:** FTH Product · **Version:** 1.0 · **Date:** April 2026

---

## Objective

Manage the onboarding, sales tracking, commission calculation, and payment settlement for concession vendors, merchandise operators, and other on-site service vendors at cricket events — replacing manual cash reconciliation with a structured, auditable settlement system.

---

## Users

| Role | Use Case |
|------|----------|
| `venue_operator` | Onboard vendors; configure commission rates; review settlement; approve distribution |
| `vendor` | View own sales summary; receive settlement statement; access payment status |
| `finance` | Run settlement close; approve distributions; manage disputes; generate reports |
| `platform_admin` | Multi-tenant vendor account management |

---

## Vendor Types

| Type | Description | Settlement Model |
|------|-------------|-----------------|
| Concession vendor | Foodand beverage at event | Gross revenue × venue commission rate → vendor receives remainder |
| Merchandise vendor | Cricket merchandise, branded goods | Fixed stall fee, or gross revenue × commission |
| Ancillary service vendor | Photography, equipment rental, other services | Fixed fee or commission per agreement |
| Partner vendor | Sponsor-linked vendor with preferential rate | Per sponsor contract terms |

---

## Workflows

### 1. Vendor Onboarding (venue_operator)
1. Venue operator creates vendor account: company name, contact, tax ID, bank/payout details
2. Operator assigns vendor to one or more events (or season-level)
3. Operator sets commission structure: flat fee (pre-payment), revenue share percentage, or hybrid
4. Vendor receives login credentials and dashboard access
5. Operator confirms vendor setup is complete for event (checklist item before event go-live)

### 2. Sales Reporting — Vendor Input (vendor)
1. After event close, vendor submits gross sales report via dashboard form
2. Sales report includes: product categories, gross revenue, transaction count, cash vs. card breakdown
3. Vendor uploads supporting documentation if required (printout, POS report)
4. Submission locked after reporting window closes (configurable; default: 24 hours after event end)

### 3. Sales Verification (venue_operator)
1. Venue operator reviews vendor's submitted sales report
2. If a POS integration is active (Square, Toast): system auto-imports vendor sales data and flags discrepancies vs. vendor submission
3. Operator marks submission as `verified` or requests correction
4. If discrepancy: vendor is notified with specific line item that doesn't match; vendor may resubmit with explanation

### 4. Settlement Calculation (automated after verification)
Once all vendor submissions for an event are verified, system runs settlement:

```
Vendor Gross Revenue (submitted + verified)
    – Platform processing fee (if card sales processed through FTH Payments Core)
    – Venue commission (per agreed rate or flat fee)
    = NET PAYABLE TO VENDOR
```

Settlement recap generated for each vendor and for the venue operator (showing total commission collected from all vendors).

### 5. Distribution Approval (finance)
1. Finance reviews settlement calculation for each vendor
2. Finance approves or flags individual vendor settlements
3. On approval: ACH payment initiated via Stripe Connect or bank transfer instruction generated
4. Vendor receives settlement statement via email and in dashboard
5. Settlement event logged as closed

### 6. Vendor Dashboard (vendor — self-serve)
- View event settlement history
- Download settlement statements (PDF)
- View upcoming events they are assigned to
- Update bank/payout details (triggers re-verification)
- View YTD total payments received

---

## Permissions

| Action | `platform_admin` | `venue_operator` | `vendor` | `finance` |
|--------|:-:|:-:|:-:|:-:|
| Create vendor account | ✓ | ✓ | — | — |
| Assign vendor to event | ✓ | ✓ | — | — |
| Submit sales report | — | — | ✓ | — |
| Verify sales report | ✓ | ✓ | — | — |
| View own settlement | — | — | ✓ | — |
| View all settlements | ✓ | ✓ | — | ✓ |
| Approve distribution | ✓ | — | — | ✓ |
| Initiate payment | ✓ | — | — | ✓ |
| Dispute resolution | ✓ | ✓ | — | ✓ |
| Generate reports | ✓ | ✓ | — | ✓ |

---

## Key Fields

### Vendor Account

| Field | Type | Description |
|-------|------|-------------|
| `vendor_id` | UUID | Unique vendor identifier |
| `tenant_id` | UUID | Venue tenant |
| `company_name` | String | Legal entity name |
| `tax_id` | String | EIN or SSN (encrypted at rest) |
| `payout_method` | Enum | `stripe_connect` \| `ach_manual` \| `check` |
| `stripe_connect_id` | String | Stripe Connect account ID (if applicable) |
| `status` | Enum | `pending_verification` \| `active` \| `suspended` |

### Vendor Event Assignment

| Field | Type | Description |
|-------|------|-------------|
| `assignment_id` | UUID | Assignment record |
| `vendor_id` | UUID | Assigned vendor |
| `event_id` | UUID | Event |
| `commission_type` | Enum | `percentage` \| `flat_fee` \| `hybrid` |
| `commission_rate` | Decimal | Percentage (e.g., 0.15 = 15%) |
| `flat_fee` | Integer (cents) | Fixed stall or access fee |
| `reporting_deadline` | Timestamp | Deadline for vendor to submit sales report |

### Sales Report

| Field | Type | Description |
|-------|------|-------------|
| `report_id` | UUID | Report record |
| `assignment_id` | UUID | Linked event assignment |
| `gross_revenue` | Integer (cents) | Total gross sales |
| `card_revenue` | Integer (cents) | Card sales (auto-verified if POS integrated) |
| `cash_revenue` | Integer (cents) | Cash sales (manual; harder to verify) |
| `transaction_count` | Integer | Number of transactions |
| `status` | Enum | `draft` \| `submitted` \| `verified` \| `disputed` |
| `submitted_at` | Timestamp | Submission timestamp |
| `verified_by` | UUID | Venue operator who verified |
| `verified_at` | Timestamp | Verification timestamp |

### Settlement Record

| Field | Type | Description |
|-------|------|-------------|
| `settlement_id` | UUID | Settlement record |
| `report_id` | UUID | Source sales report |
| `gross_revenue` | Integer (cents) | Verified gross |
| `platform_fee` | Integer (cents) | FTH processing fee |
| `venue_commission` | Integer (cents) | Venue's commission |
| `net_payable` | Integer (cents) | Amount to vendor |
| `status` | Enum | `pending_approval` \| `approved` \| `paid` \| `disputed` |
| `approved_by` | UUID | Finance user who approved |
| `paid_at` | Timestamp | Payment disbursement timestamp |
| `payment_reference` | String | ACH or Stripe transfer reference |

---

## Failure Cases

| Failure | Response |
|---------|----------|
| Vendor misses reporting deadline | System flags assignment as `overdue`; vendor notified; venue operator can extend deadline with override or close settlement with $0 report |
| Sales report discrepancy vs. POS data | System flags discrepancy; operator asked to reconcile; vendor can resubmit; final settlement uses verified figures |
| ACH payment fails (NSF or bank issue) | Payment returned; vendor and finance notified; vendor must update payout details; payment retried after update |
| Vendor disputes settlement amount | Settlement moves to `disputed`; manual review workflow; finance logs resolution outcome |
| Tax ID not verified | Vendor cannot receive payments until tax verification complete; operator is notified |
| Vendor cash revenue unverifiable | System flags cash revenue as `unverified`; operator notes override decision in audit log |

---

## Reports

| Report | Audience | Frequency | Format |
|--------|----------|-----------|--------|
| Post-event vendor settlement summary | `venue_operator`, `finance` | Per event | PDF, CSV |
| Individual vendor settlement statement | `vendor` | Per event | PDF |
| YTD vendor payments | `finance` | On demand | CSV |
| Commission collection summary | `venue_operator`, `finance` | Per event + season | PDF, CSV |
| Vendor dispute log | `finance` | On demand | CSV |
| Tax document support (1099 prep) | `finance` | Annual | CSV |

---

## MVP Scope

- Vendor account creation and event assignment
- Manual sales report submission by vendor
- Basic settlement calculation (percentage commission)
- Finance approval workflow
- Settlement statement PDF generation
- Manual ACH instruction (no automated Stripe Connect in MVP)

## Future Scope

- Stripe Connect for automated vendor payouts (no manual bank instructions)
- POS integration (Square, Toast) for automatic sales data import
- Cash vs. card split enforcement (require card percentage minimum)
- Multi-event seasonal vendor contracts with aggregated settlement
- Vendor performance analytics (busiest categories, top-revenue vendors by event type)
- 1099 export automation for annual tax filing
- International vendor support (multi-currency)

---

## APIs and Services Touched

- `POST /api/vendors` — create vendor account
- `POST /api/events/{id}/vendor-assignments` — assign vendor to event
- `POST /api/vendor-assignments/{id}/sales-reports` — submit sales report
- `PUT /api/sales-reports/{id}/verify` — verify report (venue_operator)
- `GET /api/events/{id}/settlements` — view event settlement summary
- `POST /api/settlements/{id}/approve` — approve distribution (finance)
- `GET /api/vendors/{id}/settlements` — vendor self-serve history
- Stripe Connect API: account creation, transfer initiation

---

## Security and Audit Notes

- Vendor tax IDs stored encrypted at rest; access restricted to `finance` and `platform_admin`
- Bank account details (routing/account numbers) never stored in application database — routed through Stripe Connect or encrypted external store
- All settlement approval actions write to the immutable event log with actor ID, timestamp, and settlement ID
- Cash revenue submissions are flagged in reports as `self-reported, unverified` — operators are made aware of verification limitations
- Settlement records are write-once; amendments create a new version record referencing the original
- 1099-eligible vendor payments tracked automatically; export produced for annual tax compliance review
