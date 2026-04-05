# FutureTech Georgia Cricket Infrastructure Platform
## Venue OS & League OS — Technical Blueprint

`docs/technology/04-venue-league-os-technical-blueprint.md`  
**Owner:** FutureTech Engineering · **Version:** 1.0 · **Date:** April 2026

---

## System Overview

```
FutureTech Admin Console
         │
         ├──── League OS ──────────────┐
         │         │                   │
         │    Teams / Players     Memberships
         │    Registration        Academy Enrollment
         │    Scheduling          Community Programs
         │    Results             Payments
         │                            │
         ├──── Venue OS ───────────────┤
         │         │                   │
         │    Ticketing           Concessions
         │    Access Control      Vendor Settlement
         │    Premium / Suites    Event Settlement
         │    Sponsorship         Partner Dashboards
         │                            │
         ├──── Payments Core ──────────┤
         │         │                   │
         │    Collection          Settlement
         │    Processing          Distribution
         │    Reconciliation      Audit Ledger
         │                            │
         └──── Reporting & Audit ─────┘
                   │
         Sponsor Dashboards
         League Reports
         Compliance Export
         (optional) Onchain Audit Hook
```

---

## 1. Service Boundaries

The platform is organized into four primary service domains:

| Service Domain | Responsibility | Consumers |
|----------------|---------------|-----------|
| **League OS** | Registration, scheduling, eligibility, league ops, academy | Leagues, clubs, players, coaches, admins |
| **Venue OS** | Ticketing, access, commerce, sponsorship, hospitality | Venue operators, sponsors, vendors, premium members |
| **Payments Core** | Collection, processing, settlement, distribution, reconciliation | All domains; external payment gateways |
| **Reporting & Audit** | Event logs, financial reports, dashboards, compliance exports | Internal ops, partner dashboards, compliance teams |

Each domain exposes a dedicated API surface. Cross-domain communication moves through internal service calls or an event bus — not direct database access.

---

## 2. Recommended Stack

### MVP Stack

| Layer | Technology |
|-------|------------|
| Backend / API | Node.js (TypeScript) or Python (FastAPI) — REST + minimal GraphQL where needed |
| Database | PostgreSQL (primary relational store) |
| Cache / session | Redis |
| Auth | Auth0 or Clerk (OAuth2/OIDC, JWT) |
| Payments | Stripe (primary); Plaid (bank ACH) |
| Email / notifications | SendGrid or AWS SES |
| Document storage | AWS S3 |
| Hosting | AWS (ECS Fargate or Elastic Beanstalk) or GCP Cloud Run |
| CI/CD | GitHub Actions |
| Monitoring | Datadog or AWS CloudWatch |
| Frontend (admin + partner dashboards) | React + TypeScript (Next.js) |

### Scale-Up Stack (Phase 6+)

| Layer | Technology |
|-------|------------|
| API Gateway | AWS API Gateway or Kong |
| Message bus | AWS SQS / SNS or Kafka (event-driven architecture) |
| Search | Elasticsearch (player, team, event search) |
| Analytics | Snowflake or BigQuery (sponsor reporting, league analytics) |
| CDN | CloudFront |
| Multi-region | AWS multi-AZ with Route 53 failover |
| Secrets management | AWS Secrets Manager or HashiCorp Vault |
| Infrastructure as code | Terraform |

---

## 3. Authentication Model

All platform access is gated by Auth0 or equivalent OIDC provider.

- Users authenticate with email/password or SSO (Google OAuth)
- JWT tokens issued at login; access tokens short-lived (15 min); refresh tokens rotated
- Every API request requires a valid bearer token
- Role claims are embedded in the JWT and verified server-side on every request
- Admin tokens never issued to frontend — all privileged operations run server-side

---

## 4. RBAC — Role-Based Access Control

| Role | Description | Permissions |
|------|-------------|------------|
| `platform_admin` | FTH internal super-admin | Full access to all tenants, all modules |
| `league_admin` | League organization administrator | Full access to own league data; no cross-league access |
| `venue_operator` | Venue management team | Full Venue OS access for their venue |
| `club_manager` | Club or team manager | Team registration, player management, results entry |
| `sponsor_partner` | Corporate sponsor | Read-only access to own sponsorship dashboard |
| `vendor` | Concession or merchandise vendor | Settlement views for own transactions |
| `member` | General member or player | Own account, registration, tickets |
| `compliance_officer` | Legal / compliance role | Read-only audit trail and financial reports |
| `finance` | FTH or operator finance team | Full financial reports; settlement management |

All roles are tenant-scoped. A `league_admin` for League A cannot access League B data. The multi-tenant model enforces this at the database query layer, not just the API layer.

---

## 5. Multi-Tenant Design

The platform is multi-tenant from the start. Every data record is tagged with a `tenant_id`:

- A league is a tenant
- A venue is a tenant (separate from any league that uses it)
- A joint league-venue operating agreement can result in a shared tenant scope, explicitly configured

**Multi-tenant rules:**
- Database queries always include `WHERE tenant_id = ?` — enforced at the ORM model layer
- API middleware validates that the authenticated user's tenant matches the resource being accessed
- Cross-tenant data sharing (e.g., a player registered in multiple leagues) uses a federated identity model — one user identity, multiple tenant memberships
- Tenant provisioning is an admin-only operation

---

## 6. Identity and Accounts

### User Identity

| Field | Implementation |
|-------|----------------|
| Unique identifier | UUID (database) + Auth0 sub (authentication provider) |
| Profile | Name, email, phone, date of birth, photo |
| Verification status | Email verified, phone verified, identity verified (if required) |
| Role assignments | Array of `{tenant_id, role}` pairs |
| Payment methods | Stored in Stripe (tokenized); never in FTH database |

### Entity Accounts

Beyond individual user accounts, the platform manages account objects for:
- Teams (linked to a league tenant, owned by a club manager)
- Clubs (independent entity; may span multiple leagues)
- Sponsors (linked to one or more venue/league tenants)
- Vendors (event-scoped or season-scoped)
- Members (may be users with a membership record in a venue or league tenant)

---

## 7. Payments and Settlement Architecture

All payment flows run through Payments Core. No domain processes payments directly.

```
User / Team / Sponsor Payment Intent
         │
         ▼
Payments Core (FTH)
  ├── Stripe (card processing)
  ├── Plaid / ACH (bank pull for large transactions)
  └── Manual invoice (for sponsor and suite contracts)
         │
         ▼
Transaction Ledger
  ├── Status: pending → confirmed → settled
  └── Linked to: registration, ticket, membership, vendor commission, sponsor billing
         │
         ▼
Settlement Engine
  ├── Per-event settlement run
  ├── Per-season settlement run
  ├── Vendor commission deduction
  ├── Platform fee deduction
  └── Net distribution to operator account
         │
         ▼
Distribution Ledger
  └── Audit-grade record of every distribution event
```

**Reconciliation:** Every settlement run produces a reconciliation report. Discrepancies between collected revenue and settled amounts trigger an exception queue — reviewed by finance before closing the settlement period.

**Failure handling:** Failed payments enter a retry queue with exponential backoff (3 retries, then manual review). Settlement runs do not close until all pending exceptions are cleared or manually overridden with documented reason.

---

## 8. Event and Reporting Model

Every significant state change in the platform generates an immutable event log entry:

| Event Type | Example |
|------------|---------|
| `registration.created` | Team or player registration submitted |
| `payment.captured` | Payment successfully processed |
| `ticket.admitted` | Ticket scanned and admission granted |
| `settlement.run` | End-of-event or end-of-season settlement executed |
| `sponsor.report.generated` | Sponsor performance report created |
| `member.enrolled` | Member account activated |
| `vendor.commission.paid` | Vendor settlement completed |
| `audit.export` | Compliance export generated |

Events are write-once. The event log is the source of truth for compliance and audit purposes.

**Reporting outputs:**
- End-of-event settlement report (venue operator)
- Season financial summary (league admin)
- Sponsor performance dashboard (sponsor partner — self-serve)
- Vendor settlement statement (vendor — per event)
- Compliance export (CSV or PDF — for finance and legal review)

---

## 9. Ledger and Settlement Model

The settlement engine processes settlement in two phases:

**Phase 1 — Collection close:** All payment intents for the event or period are confirmed or expired. No new revenue is credited after collection close.

**Phase 2 — Distribution run:**
1. Gross revenue confirmed
2. Platform fees deducted
3. Vendor commissions deducted (per agreed rates)
4. Sponsor reporting fees deducted (if applicable)
5. Net revenue distributed to operator account (Stripe Connect or ACH)
6. Settlement report generated and locked

The locked settlement report is write-once and cannot be modified. Disputes are handled via a separate adjustment process that references the original locked report.

---

## 10. External Integrations

| Integration | Purpose | Priority |
|-------------|---------|----------|
| Stripe | Card payment processing, Stripe Connect for operator payouts | P0 — MVP required |
| Auth0 | Authentication and identity | P0 — MVP required |
| SendGrid / AWS SES | Email notifications and receipts | P0 — MVP required |
| AWS S3 | Document and media storage | P0 — MVP required |
| Plaid | ACH / bank pull for large invoices | P1 — Phase 3 |
| Salesforce / HubSpot | CRM sync for sponsor and member accounts | P1 — Phase 3 |
| QR / NFC ticketing hardware | Gate access at venue events | P1 — Phase 3 |
| POS systems (Square, Toast) | Concession and vendor point-of-sale | P1 — Phase 3 |
| Scoring / results APIs | Live match result ingestion | P2 — optional |
| Onchain audit bridge | Write settlement hashes to public chain | P3 — Capital Markets OS phase |

---

## 11. Security Controls

| Control | Implementation |
|---------|----------------|
| API authentication | JWT bearer tokens, verified server-side on every request |
| HTTPS everywhere | TLS 1.2 minimum; HSTS enforced |
| Payment security | PCI-DSS compliant via Stripe; FTH never stores raw card data |
| Data encryption at rest | AWS RDS encrypted storage; S3 server-side encryption |
| Secret management | AWS Secrets Manager; no secrets in environment variables or source code |
| Dependency scanning | GitHub Dependabot + Snyk |
| SQL injection prevention | Parameterized queries enforced at ORM layer |
| XSS prevention | React (auto-escaping); Content-Security-Policy headers |
| Rate limiting | Per-IP and per-user rate limits on all public endpoints |
| Audit logging | All admin actions logged with user ID, timestamp, and action detail |
| Penetration testing | Required before any public launch; annual thereafter |

---

## 12. Compliance Notes

- **GDPR / CCPA:** User data export and deletion endpoints required for compliance. Data retention policies set per tenant.
- **PCI-DSS:** All card data handled exclusively through Stripe. FTH infrastructure is out-of-scope for PCI audit.
- **Financial reporting:** Settlement reports must be immutable and timestamped for accounting compliance.
- **Securities-adjacent:** If any tenant uses the platform for accredited-investor-linked transactions (Capital Markets OS phase), those workflows require additional legal gating before activation. The technical infrastructure does not prevent premature activation — the process controls must.
- **Multi-jurisdictional:** Platform is initially Georgia / U.S.-focused. Expansion to international markets requires legal review of data residency, payment rails, and compliance requirements per jurisdiction.

---

## 13. Data Model Outline

### Core Entities

```
tenant
  ├── id, name, type (league | venue | combined), status
  └── settings, billing_plan

user
  ├── id, email, name, phone, dob, auth_provider_sub
  └── roles[] → {tenant_id, role}

team
  ├── id, tenant_id, name, manager_user_id
  └── players[] → user[]

registration
  ├── id, tenant_id, team_id or user_id, season_id
  ├── type (team | player | individual)
  ├── status (pending | confirmed | cancelled)
  └── payment_id → payment

payment
  ├── id, tenant_id, user_id or entity_id
  ├── amount, currency, gateway_reference
  ├── status (pending | captured | refunded | failed)
  └── linked_to (registration | ticket | membership | invoice)

ticket
  ├── id, tenant_id, event_id, user_id
  ├── tier (general | member | premium)
  ├── status (issued | admitted | cancelled)
  └── payment_id

membership
  ├── id, tenant_id, user_id
  ├── tier, start_date, end_date
  ├── benefits[], status
  └── recurring_payment_schedule

sponsorship
  ├── id, tenant_id, sponsor_entity_id
  ├── contract_value, start_date, end_date
  ├── inventory_items[] → {type, placement, schedule}
  └── performance_log[]

settlement
  ├── id, tenant_id, event_id or period
  ├── gross_revenue, platform_fee, vendor_commissions, net_distributed
  ├── status (open | closed | disputed)
  └── distribution_record[]

event_log
  ├── id, tenant_id, event_type, actor_user_id
  ├── payload (JSON), timestamp
  └── (write-once; no update or delete)
```

---

*FutureTech Engineering · Technical Blueprint · Internal working document.*  
*Subject to revision as product definition evolves. Not a binding architecture commitment.*
