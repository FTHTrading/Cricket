# Module Spec: Sponsorship Reporting
## FutureTech Georgia Cricket Infrastructure Platform

`docs/product/08-module-spec-sponsorship-reporting.md`  
**Owner:** FTH Product · **Version:** 1.0 · **Date:** April 2026

---

## Objective

Give sponsors and venue/league operators a measurable, verifiable record of sponsorship inventory delivered and commercial value activated — converting subjective sponsorship relationships into data-backed, renewable commercial products.

---

## Users

| Role | Use Case |
|------|----------|
| `venue_operator` / `league_admin` | Configure inventory; upload activation evidence; generate sponsor reports |
| `sponsor_partner` | View own dashboard; download post-event reports; track contract status |
| `finance` | View billing status; issue invoices; track payment against contract |
| `platform_admin` | Manage sponsor accounts; configure inventory categories across tenants |

---

## Workflows

### 1. Sponsor Onboarding (venue_operator / league_admin)
1. Admin creates sponsor account and contract record
2. Contract record includes: sponsor entity, start/end dates, total contract value, payment schedule, inventory entitlements
3. Sponsor receives login credentials and dashboard access (read-only to own data)
4. System generates invoice schedule based on payment terms

### 2. Inventory Configuration (venue_operator / league_admin)
1. Admin maps available sponsor inventory across categories:
   - pitch-side signage (location, size, visibility tier)
   - digital display placements (screen, frequency)
   - jersey/kit placements
   - event naming (title sponsor, presenting sponsor, category sponsor)
   - social and digital placements
   - on-site activation areas
2. Each inventory item tagged with: type, event scope (per event, season, or year), estimated impressions, assigned sponsor
3. Inventory assignments linked to sponsor contract record

### 3. Event Activation Logging (venue_operator / league_admin)
1. Before each event: admin confirms which inventory items are active for this event
2. During/after event: admin uploads activation evidence (photos, video clips, screenshot)
3. Admin logs actual delivery: was the placement live, was the activation complete, were there issues?
4. Attendance count entered (from ticketing system — auto-populated if Venue OS ticketing is live)
5. System calculates: estimated event impressions = placement tier × attendance count

### 4. Post-Event Sponsor Report (auto-generated)
1. System generates post-event report within the reporting window (configurable; default 48 hours after event)
2. Report includes:
   - event name, date, attendance
   - inventory delivered (with photo evidence)
   - estimated impressions per placement
   - contract delivery percentage (actual vs. contracted)
   - YTD contract delivery status
3. Report published to sponsor dashboard and emailed to sponsor contact
4. Admin reviews before publish (optional gating)

### 5. Sponsor Dashboard (sponsor_partner — self-serve)
- View current contract status
- View all event reports for the current contract period
- Download individual event reports (PDF)
- Download YTD summary report (PDF, CSV)
- View upcoming events where their placements are scheduled

### 6. Billing and Payment (finance)
1. Finance generates invoice per payment schedule
2. Invoice sent to sponsor billing contact via email
3. Payment tracked as: `pending` → `paid` → `overdue`
4. Overdue payments trigger automated reminder at 7, 14, and 30 days
5. Finance marks payment received and reconciles against contract total

---

## Permissions

| Action | `platform_admin` | `venue_operator` / `league_admin` | `sponsor_partner` | `finance` |
|--------|:-:|:-:|:-:|:-:|
| Create sponsor account | ✓ | ✓ | — | — |
| Configure inventory | ✓ | ✓ | — | — |
| Log event activation | — | ✓ | — | — |
| Upload evidence | — | ✓ | — | — |
| View own dashboard | — | — | ✓ | — |
| Download own reports | — | — | ✓ | — |
| View all sponsor data | ✓ | ✓ | — | ✓ |
| Generate invoices | — | — | — | ✓ |
| Mark payment received | — | — | — | ✓ |

---

## Key Fields

### Sponsor Contract

| Field | Type | Description |
|-------|------|-------------|
| `contract_id` | UUID | Unique contract identifier |
| `tenant_id` | UUID | League or venue tenant |
| `sponsor_entity_id` | UUID | Sponsor company account |
| `contract_value` | Integer (cents) | Total contract value |
| `start_date` / `end_date` | Date | Contract term |
| `payment_schedule` | JSON | Array of `{due_date, amount}` |
| `inventory_items` | UUID[] | Linked inventory placement records |
| `status` | Enum | `active` \| `completed` \| `cancelled` \| `in_dispute` |

### Inventory Item

| Field | Type | Description |
|-------|------|-------------|
| `item_id` | UUID | Inventory item identifier |
| `type` | Enum | `signage` \| `digital` \| `kit` \| `naming` \| `social` \| `activation_area` |
| `location_description` | String | Plain-language placement description |
| `visibility_tier` | Enum | `premium` \| `standard` \| `secondary` |
| `scope` | Enum | `per_event` \| `season` \| `annual` |
| `estimated_impressions_per_event` | Integer | Baseline estimate from tier |
| `assigned_sponsor_id` | UUID | Sponsor contract linked |

### Event Activation Record

| Field | Type | Description |
|-------|------|-------------|
| `activation_id` | UUID | Record identifier |
| `event_id` | UUID | Event this activation belongs to |
| `item_id` | UUID | Inventory item activated |
| `delivered` | Boolean | Was the placement live? |
| `delivery_notes` | String | Issues or partial delivery notes |
| `evidence_urls` | String[] | S3 links to photos/video |
| `actual_attendance` | Integer | Event attendance count |
| `actual_impressions` | Integer | Calculated: `attendance × tier_multiplier` |
| `logged_by` | UUID | Admin user who logged the activation |
| `logged_at` | Timestamp | Logging timestamp |

---

## Impression Tier Multipliers (Defaults — Configurable)

| Visibility Tier | Multiplier Logic |
|-----------------|-----------------|
| Premium | attendance × 1.5 (high-visibility placement; assumed repeated exposure) |
| Standard | attendance × 1.0 |
| Secondary | attendance × 0.5 |

These are operational estimates, not guaranteed metrics. All reports include the methodology used. Sponsors are informed at contract signing that impression figures are estimates based on attendance and placement tier, not independently audited.

---

## Failure Cases

| Failure | Response |
|---------|----------|
| Event report not filed within window | System flags report as overdue; admin notified; no report published to sponsor until filed |
| Evidence upload fails | Admin sees upload error; retries supported; activation record held open until evidence uploaded |
| Sponsor dashboard access issue | Support ticket workflow; admin can resend login; access logs reviewed |
| Contract underdelivered | System flags delivery percentage below threshold (configurable; default: 90%); admin is notified; make-good inventory may be configured |
| Payment overdue | Automated reminder sequence; after 30 days, finance escalation alert |
| Dispute logged by sponsor | Contract status moves to `in_dispute`; manual review workflow; no further invoices until resolved |

---

## Reports

| Report | Audience | Frequency | Format |
|--------|----------|-----------|--------|
| Post-event activation report | `sponsor_partner`, `venue_operator` | Per event | PDF |
| YTD delivery summary | `sponsor_partner`, `venue_operator`, `finance` | On demand | PDF, CSV |
| Contract billing status | `finance` | On demand | CSV |
| Overdue payment report | `finance` | Weekly | CSV |
| Sponsor portfolio summary | `venue_operator`, `league_admin` | On demand | PDF |

---

## MVP Scope

- Sponsor account and contract creation
- Manual inventory assignment
- Event activation logging with photo upload
- Auto-generated post-event report (PDF)  
- Sponsor self-serve dashboard (read-only)
- Basic invoice generation and payment tracking

## Future Scope

- Integration with ticketing for automatic attendance pull into activation records
- Automated event report delivery without admin intervention
- Category exclusivity enforcement (prevent conflicting sponsor assignments)
- Multi-year contract management with annual renewal workflows
- Aggregated sponsor performance benchmarks across platform (anonymized)
- Real-time dashboard with live event impression tracking

---

## APIs and Services Touched

- `POST /api/sponsors` — create sponsor account
- `POST /api/sponsors/{id}/contracts` — create contract
- `GET /api/sponsors/{id}/contracts/{id}/dashboard` — sponsor self-serve view
- `POST /api/events/{id}/activations` — log event activation
- `POST /api/activations/{id}/evidence` — upload evidence (S3 presigned URL)
- `GET /api/contracts/{id}/report?event_id={id}` — generate event report
- `GET /api/contracts/{id}/ytd-report` — YTD summary

---

## Security and Audit Notes

- Sponsor accounts have read-only access strictly scoped to their own contract data
- Photo/video evidence uploaded via S3 presigned URLs; not stored in application database
- All activation log entries are immutable — edits create a new version record, not an overwrite
- Invoice and payment records write to the immutable event log
- Impression calculation methodology is documented in every report (no opaque numbers delivered to sponsors)
