# FutureTech Georgia Cricket Infrastructure Platform
## Ancillary Capital Markets Framework

`docs/capital-markets/06-ancillary-capital-markets-framework.md`  
**Owner:** FutureTech Holding Company · **Version:** 1.0 · **Date:** April 2026

---

## Critical Framing

**Read this before any other section.**

The capital markets framework is the last layer of the FutureTech platform, not the first. It is activated only after:

1. FutureTech has established operating systems (League OS and Venue OS) with real transaction volume
2. Commercial rights have been legally documented and confirmed
3. Cash flows are measurable, auditable, and attributable to specific assets or programs
4. Securities counsel has been engaged and has reviewed the proposed structure
5. All offering gating criteria have been satisfied

**Nothing in this document represents a live securities offering, an active fundraise, or a commitment to launch any capital structure.**

The ERC-3643 contract in this repository is a reference implementation. It has not been audited. It is not production-ready. It will not be deployed without a professional security audit and full compliance stack.

This framework exists so that when FutureTech reaches the point of capital readiness, the architecture is already documented, reviewed, and gated correctly — rather than rushed to market prematurely.

---

## 1. Why Capital Markets Is the Third Layer

The sequence matters because the commercial logic is sequential, not parallel.

```
LAYER 1 — OPERATIONS
  League OS + Venue OS deployed and processing transactions
       │  (creates: data, relationships, operating history)
       ▼
LAYER 2 — MONETIZATION
  Revenue systems optimized; recurring streams established
       │  (creates: measurable cash flows, auditable performance)
       ▼
LAYER 3 — CAPITAL MARKETS
  Rights documented; counsel engaged; gating criteria met
       │  (creates: financeable structures with defensible inputs)
       ▼
  Ancillary SPV structures + optional digital securities
```

Attempting to reverse this sequence — launching capital structures before operating data exists — produces two outcomes: legal exposure and credibility loss. Both are avoidable.

---

## 2. SPV Candidate Analysis

The following asset categories are potential SPV candidates when gating criteria are met. None are active.

### A. Premium Suite SPV

| Attribute | Detail |
|-----------|--------|
| Asset description | Revenue-sharing rights in premium suite inventory at a partner venue |
| Cash flow source | Suite licensing fees, per-event hospitality packages, annual suite contracts |
| Investor profile | Accredited investors (Reg D 506(c)) — institutional and high-net-worth |
| Rights prerequisite | Suite inventory rights legally documented with venue operator; revenue attribution defined |
| Operating data prerequisite | Minimum 1 full season of suite occupancy and revenue data |
| Offering type | Preferred membership units with defined distribution priority |
| Distribution trigger | Suite revenue collected; platform fee and venue operator share deducted; remaining distributed per waterfall |
| Digital securities applicability | High — clear revenue attribution, institutional buyer, defined asset |

---

### B. Hospitality and F&B SPV

| Attribute | Detail |
|-----------|--------|
| Asset description | Revenue participation rights in hospitality and food-and-beverage operations at a partner venue |
| Cash flow source | Hospitality package sales, premium F&B revenue, catering contracts |
| Investor profile | Accredited investors (Reg D 506(c)) |
| Rights prerequisite | Commercial rights to hospitality and F&B revenue streams formally documented |
| Operating data prerequisite | Minimum 1 full season across at least 10 events |
| Offering type | Preferred units with revenue-share distribution |
| Digital securities applicability | Moderate — good revenue signals but higher operational variability |

---

### C. Academy and Training Facility SPV

| Attribute | Detail |
|-----------|--------|
| Asset description | Revenue and/or leasehold participation rights in a dedicated cricket academy or training facility |
| Cash flow source | Program tuition, camp fees, contract coaching, facility rental |
| Investor profile | Accredited investors initially; Reg CF potential after stabilization |
| Rights prerequisite | Facility lease or ownership established; program licensing documented |
| Operating data prerequisite | 2+ years of program enrollment and tuition data |
| Offering type | Preferred units; possible Reg CF community offering post-stabilization |
| Digital securities applicability | Moderate — community-relevant; could support broader retail structure |

---

### D. Event-Linked Finance Structures

| Attribute | Detail |
|-----------|--------|
| Asset description | Short-duration preferred units linked to revenue from a specific event series or season |
| Cash flow source | Ticket sales, sponsorship activations, vendor commissions from defined event pool |
| Investor profile | Accredited investors |
| Rights prerequisite | Event operating rights and venue access formally documented |
| Operating data prerequisite | Prior event history demonstrating attendance and revenue baseline |
| Offering type | Event-linked preferred units with defined maturity or payoff date |
| Digital securities applicability | High — clean cash flow attribution; defined timeline |

---

### E. Sponsor Receivables and Media-Linked Commercial Structures

| Attribute | Detail |
|-----------|--------|
| Asset description | Advance against confirmed multi-year sponsorship or media contract receivables |
| Cash flow source | Annual sponsor payments; media rights licensing fees |
| Investor profile | Institutional |
| Rights prerequisite | Multi-year sponsor or media contracts in place and assignable |
| Operating data prerequisite | Minimum 1 contracted season of sponsor payment history |
| Offering type | Senior preferred notes or revenue participation certificates |
| Digital securities applicability | Moderate — possible but requires clean legal structure for receivables assignment |

---

### F. Founding-Member Premium Programs

| Attribute | Detail |
|-----------|--------|
| Asset description | Premium founding-member units granting persistent access rights, revenue participation, and governance rights at a venue or league |
| Cash flow source | Annual membership dues; premium event access fees |
| Investor profile | Mixed — community members, HNW individuals, corporate accounts |
| Rights prerequisite | Membership rights defined and venue access confirmed |
| Operating data prerequisite | First season of membership enrollment and renewal data |
| Offering type | Reg CF or Reg A+ after stabilization; Reg D in initial phase |
| Digital securities applicability | High — well-suited for ERC-3643 transfer-restricted preferred units |

---

## 3. Compliant Reg D Framework (Reference)

Any offering launched under this framework must comply with the following:

| Requirement | Standard |
|-------------|----------|
| Offering regulation | SEC Reg D Rule 506(c) for accredited investors only |
| Accreditation verification | Third-party verification mandatory — no self-certification |
| General solicitation | Permitted under 506(c); all advertising must include required legends |
| Form D filing | Required within 15 days of first sale |
| Blue sky filings | State notice filings required in each state where investors reside |
| Transfer restrictions | 12-month minimum lockup; transfer agent registered |
| KYC / AML | Required at subscription and wallet verification |
| Disclosure document | Private Placement Memorandum reviewed by securities counsel |
| Investor communications | Plain-English risk disclosures required; no guaranteed return language |

Post-stabilization pathways:
- **Reg CF:** Community access, up to $5M, requires FINRA-registered funding portal
- **Reg A+:** Broad public access, up to $75M, requires SEC qualification (Tier 2)

Offerings are never blended. Each offering opens only after the prior phase closes and all gating criteria are met.

---

## 4. ERC-3643 Reference Architecture

The `contracts/AtlantaCricketToken.sol` file demonstrates a permissioned security token based on the ERC-3643 (T-REX) standard.

**What ERC-3643 provides:**
- Permissioned transfers — only verified wallets can hold or receive tokens
- On-chain identity registry linked to KYC/AML verification
- Compliance officer roles with freeze, force-transfer, and pause capabilities
- Lockup period enforcement at the contract level
- Onchain cap table management and distribution records

**Current contract status:**

| Attribute | Status |
|-----------|--------|
| Contract file | Reference implementation only |
| Security audit | Not completed — required before production |
| ONCHAINID integration | Not integrated — required for full ERC-3643 compliance |
| Production readiness | Not ready |
| Legal review | Not completed |

**Production deployment requirements:**
1. Full ERC-3643 (T-REX) framework with ONCHAINID identity verification
2. Professional security audit by a recognized smart contract auditing firm
3. Legal review confirming onchain token structure matches offering documents
4. Transfer agent registered with SEC or exemption confirmed
5. All Reg D gating criteria satisfied before any token is issued

---

## 5. Pre-Launch Readiness Checklist

Before any capital structure is activated, each item must be confirmed:

- [ ] Commercial rights legally documented (venue, league, or program-specific)
- [ ] Minimum required operating data available (per SPV candidate requirements above)
- [ ] Securities counsel engaged and retainer in place
- [ ] Private Placement Memorandum drafted and reviewed
- [ ] Investor accreditation verification process configured
- [ ] Form D filing prepared
- [ ] State blue sky filings identified and prepared
- [ ] Transfer agent arrangement confirmed
- [ ] KYC/AML process integrated (at wallet or subscription level)
- [ ] Smart contract audited (if digital securities structure)
- [ ] ONCHAINID or equivalent identity verification integrated (if onchain)
- [ ] Lockup period and transfer restriction enforcement confirmed
- [ ] Investor communication templates reviewed for compliance language
- [ ] No guaranteed return language anywhere in marketing materials
- [ ] Regulatory counsel has signed off on launch readiness

This checklist is not exhaustive. It is the minimum floor, not the ceiling.

---

## 6. What Changes When Capital Markets OS Is Live

When the capital-markets layer is fully activated:

- FTH's payment and settlement infrastructure becomes the distribution engine for SPV cash flows
- Onchain records supplement (not replace) offchain ledger as an audit mechanism
- Partner dashboards gain a capital-markets reporting view (SPV performance, distribution history)
- Reporting module produces investor-grade quarterly distribution reports
- The data flywheel from Layers 1 and 2 directly inputs into SPV performance reporting

The operating platform does not change. The capital markets layer runs on top of it, using the same revenue data — just structured differently for investor reporting and distribution.

---

*FutureTech Holding Company · Capital Markets Reference Framework*  
*This document does not constitute a securities offering, investment advice, or legal opinion.*  
*All capital structures require qualified securities counsel review before any launch.*
