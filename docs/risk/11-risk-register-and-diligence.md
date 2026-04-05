# FutureTech Georgia Cricket Infrastructure Platform
## Risk Register and Diligence Document

`docs/risk/11-risk-register-and-diligence.md`  
**Owner:** FutureTech Holding Company · **Version:** 1.0 · **Date:** April 2026

---

## Purpose

This document identifies the material operational, commercial, legal, and execution risks associated with the FutureTech Georgia Cricket Infrastructure Platform. It is maintained as a live document and updated as risk status changes.

---

## Risk Register

### 1. Venue Dependence

| Attribute | Detail |
|-----------|--------|
| **Risk** | FTH's Venue OS deployment depends on access to a partner venue with operating capability |
| **Why it matters** | LaGrange Cricket Grounds targets Q1 2027 opening, subject to approvals. If opening is delayed, the most commercially significant Venue OS pilot is deferred. |
| **Mitigation** | Build League OS in parallel without venue dependency. Pursue secondary venue pilots at existing Gwinnett-area grounds. Do not sequence the entire platform around LaGrange opening date. |
| **Owner** | FTH Strategy |
| **Status** | Active — LaGrange timeline not yet confirmed by FTH |
| **Next action** | Identify Atlanta metro venues suitable for Venue OS pilot independent of LaGrange timeline |

---

### 2. Partnership Ambiguity

| Attribute | Detail |
|-----------|--------|
| **Risk** | Conversations with APL, LaGrange, and metro clubs may not formalize into operating agreements on expected timelines |
| **Why it matters** | Without a confirmed partner, pilots cannot launch. Without pilots, capital readiness cannot begin. |
| **Mitigation** | Scope at least one pilot around FTH's own internal league footprint (APL co-location) where FTH can act without a separate partner agreement. Pilot the sponsorship reporting or league registration module within the existing APL context. |
| **Owner** | FTH Business Dev |
| **Status** | Active — no formal partner agreements exist as of April 2026 |
| **Next action** | Advance LaGrange and APL conversations; define minimum viable partner agreement needed to launch first pilot |

---

### 3. Rights Ownership Uncertainty

| Attribute | Detail |
|-----------|--------|
| **Risk** | Commercial rights at APL and with any venue partner may not be as available or transferable as assumed |
| **Why it matters** | Building operating systems that depend on rights FTH does not hold creates commercial and legal exposure |
| **Mitigation** | Legal review of APL operating agreements and any venue partnership agreements before building commercial products on their foundation. Do not assume rights; confirm them. |
| **Owner** | FTH Legal |
| **Status** | Active — legal review not yet initiated |
| **Next action** | Engage counsel to review APL structure and FTH's operating role; document what FTH can commercially offer without additional rights grants |

---

### 4. Venue Construction and Opening Timing Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | LaGrange Cricket Grounds opening timeline (Q1 2027 target) may shift due to permitting, construction, or funding delays |
| **Why it matters** | FTH's highest-profile Venue OS deployment opportunity depends on this timeline |
| **Mitigation** | FTH cannot control or de-risk LaGrange's timeline; FTH can control its own exposure. Do not commit engineering resources to LaGrange-specific Venue OS build until at least a conditional operating agreement is in place. |
| **Owner** | FTH Strategy |
| **Status** | Monitoring |
| **Next action** | Establish contact with LaGrange; assess actual construction status as of Q2 2026 |

---

### 5. Sponsor Concentration Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | Early sponsorship revenue may be highly concentrated in 1–2 sponsors, creating fragility |
| **Why it matters** | Loss of a single large sponsor in Year 1 creates a revenue cliff and undermines the sponsorship reporting module's commercial case |
| **Mitigation** | Build diversified sponsor inventory from the start. Design the sponsorship reporting module to support multiple sponsors across inventory categories rather than single-sponsor exclusivity deals. |
| **Owner** | FTH Business Dev |
| **Status** | Future — not yet material |
| **Next action** | At sponsor pipeline development stage (Phase 3), target minimum 4 sponsors across different categories |

---

### 6. Platform Adoption Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | Leagues, clubs, and venues may resist adopting new operating software — particularly if they have informal systems that work for them |
| **Why it matters** | Adoption is the entire commercial thesis. A platform that no one uses generates no data, no revenue, and no path to capital structures. |
| **Mitigation** | Design for minimal disruption to existing workflows in MVP. Offer export-compatible data formats for clubs with existing tools. Pilot one module at a time rather than requiring full-platform adoption upfront. Mobile-first UX is non-negotiable. |
| **Owner** | FTH Product |
| **Status** | Active design constraint |
| **Next action** | Conduct user interviews with 3–5 league admins and club managers before finalizing UX specifications |

---

### 7. League Fragmentation Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | The Georgia cricket market has multiple leagues and organizing bodies with different governance, formats, and stakeholder dynamics. FTH may be perceived as an APL-aligned operator and excluded by competing leagues. |
| **Why it matters** | A platform limited to APL participants has a ceiling on participation volume and commercial scale |
| **Mitigation** | Design the League OS as a neutral, multi-league platform. Establish clear governance that FTH's operating role is technology and infrastructure, not competitive or governance decision-making. Seek early adopters outside APL to establish neutrality. |
| **Owner** | FTH Strategy |
| **Status** | Strategic design constraint |
| **Next action** | Define FTH's positioning language for non-APL leagues before first partner outreach |

---

### 8. Securities Law Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | Premature or noncompliant capital-markets activity — including offering documents, investor materials, or token launches that constitute unregistered securities — creates severe legal exposure |
| **Why it matters** | SEC enforcement actions are existential for a company of FTH's stage. Reputational damage from a securities misstep undermines the operating business permanently. |
| **Mitigation** | Strict phase sequencing enforced in this repo and internally. Capital Markets OS is explicitly gated behind operating data, rights documentation, and securities counsel engagement. No offering language in any external-facing materials until counsel has reviewed. |
| **Owner** | FTH Legal + FTH Leadership |
| **Status** | Actively mitigated by repo structure |
| **Next action** | Confirm that all external outreach materials (website, proposals) consistent with this repo's disclaimer language before publication |

---

### 9. Payment and Custody Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | Handling payments for third-party leagues, vendors, and members creates fiduciary exposure if funds are held, misapplied, or subject to disputes |
| **Why it matters** | Money movement without proper legal and operational frameworks creates liability |
| **Mitigation** | Route all third-party payments through Stripe Connect or equivalent sub-account structures. FTH does not hold funds for third parties — funds flow through but land in partner accounts. Settlement timing documented in all operating agreements. |
| **Owner** | FTH Finance + FTH Legal |
| **Status** | Design constraint — addressed in Payments Core architecture |
| **Next action** | Legal review of payments flow and required money transmission licenses (if any) before MVP launch |

---

### 10. Operating Execution Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | FTH's current team may not have the bandwidth or specialized expertise to build, deploy, and operate all platform modules across the planned timeline |
| **Why it matters** | Overcommitting to multiple simultaneous pilots and builds without adequate resourcing produces poor-quality output, broken partnerships, and reputational damage |
| **Mitigation** | Strict phase sequencing. One pilot module at a time. Validate product-market fit before scaling build. Hire or contract specialists for engineering and operations before Phase 6 build begins. |
| **Owner** | FTH Leadership |
| **Status** | Active constraint |
| **Next action** | Headcount and contractor plan required before Phase 3 milestone |

---

### 11. Reputational Risk

| Attribute | Detail |
|-----------|--------|
| **Risk** | If the repo or any FTH communication overstates ownership, rights, or the status of capital-markets activity, it creates reputational damage with venue partners, league operators, and the community |
| **Why it matters** | Credibility is the primary asset in an early-stage market entry. A single misrepresentation — even if unintentional — can permanently damage relationships with the exact partners FTH is trying to win |
| **Mitigation** | All external communications reviewed against this repo's disclaimer language before release. README and partner proposal explicitly state what FTH does and does not claim. Internal team training on what can and cannot be said publicly. |
| **Owner** | FTH Leadership + FTH Marketing |
| **Status** | Actively mitigated by repo language |
| **Next action** | Formal communications policy document before any public-facing launch of this platform |

---

## Risk Summary Matrix

| Risk | Likelihood | Impact | Priority | Owner |
|------|-----------|--------|----------|-------|
| Venue dependence | Medium | High | P1 | FTH Strategy |
| Partnership ambiguity | High | High | P1 | FTH Business Dev |
| Rights ownership uncertainty | Medium | High | P1 | FTH Legal |
| Construction timing risk | Medium | Medium | P2 | FTH Strategy |
| Sponsor concentration | Low (now) | Medium | P3 | FTH Business Dev |
| Platform adoption resistance | Medium | High | P1 | FTH Product |
| League fragmentation | Medium | Medium | P2 | FTH Strategy |
| Securities law risk | Low (if gates respected) | Critical | P0 | FTH Legal |
| Payment and custody risk | Low (if Stripe model used) | High | P1 | FTH Finance |
| Operating execution risk | Medium | High | P1 | FTH Leadership |
| Reputational risk | Low (if language is controlled) | High | P1 | FTH Leadership |

---

## Diligence Notes for Partners

Any partner conducting diligence on FutureTech's operating role should note:

1. FTH's role is as a systems and infrastructure provider, not a rights holder or venue owner
2. FTH's operating agreement with APL and any other league or venue will define the specific scope of its commercial role
3. No capital structure, SPV, or securities offering is active or implied
4. All financial projections or revenue frameworks in this repo are illustrative; actual results depend on partner adoption, venue performance, and market conditions
5. Legal review of any commercial terms with FTH should include review of payments flow, data governance, and revenue-share arrangements

---

*FutureTech Holding Company · Risk Register · For internal and partner diligence use.*  
*Updated as material risk status changes. Not a legal opinion or formal risk assessment.*
