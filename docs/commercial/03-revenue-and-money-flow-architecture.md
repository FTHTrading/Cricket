# FutureTech Georgia Cricket Infrastructure Platform
## Revenue and Money Flow Architecture

`docs/commercial/03-revenue-and-money-flow-architecture.md`  
**Owner:** FutureTech Holding Company · **Version:** 1.0 · **Date:** April 2026

---

## Purpose

This document maps every revenue category in the FutureTech Georgia Cricket Infrastructure Platform: who pays, who receives funds, what systems process the transaction, what operational dependencies exist, and whether the revenue stream is suitable for later tokenization or capital structuring.

It is a working commercial architecture document — not a financial projection, not a guaranteed model, not a prospectus.

---

## Money Flow Map

```
CRICKET ECOSYSTEM PARTICIPANTS
 Players · Teams · Fans · Academies · Sponsors · Vendors · Premium Members
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│              FUTURETCH PAYMENTS CORE                            │
│  Collection → Processing → Settlement → Distribution           │
└────────────────────────────┬────────────────────────────────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
   LEAGUE OS           VENUE OS         REPORTING / AUDIT
   Payments Core       Commerce Core    Revenue Records
          │                  │                  │
          ▼                  ▼                  ▼
   League / Club       Venue Operator    Sponsor Dashboards
   Settlement          Settlement        Partner Reports
          │                  │                  │
          └──────────────────┼──────────────────┘
                             ▼
                   CAPITAL MARKETS OS (later stage)
               SPV Structures · Preferred Returns
               (only after: rights clear, data exists, counsel engaged)
```

---

## Revenue Stream Detail

### 1. League Participation Fees

| Field | Detail |
|-------|--------|
| Description | Season registration fees paid by teams to participate in organized league competition |
| Who pays | Team managers / club operators |
| Who receives | League organization; FTH takes platform fee |
| Key systems | League OS — registration module, payment rails, season account management |
| Operational dependencies | Season format defined; team eligibility verified; schedule generated |
| Tokenization suitability | **Not suitable** — operational fee with no capital structure applicability |
| Offchain / Onchain | Fully offchain; standard payment processing |

---

### 2. Player Registration Fees

| Field | Detail |
|-------|--------|
| Description | Individual player registration fees for league participation and membership |
| Who pays | Individual players or their team managers |
| Who receives | League organization; FTH takes platform fee |
| Key systems | League OS — player registration, identity, eligibility |
| Operational dependencies | Identity verification; eligibility rules configured; team association confirmed |
| Tokenization suitability | **Not suitable** — operational, recurring, high-volume small transactions |
| Offchain / Onchain | Fully offchain |

---

### 3. Tournament and Event Registration

| Field | Detail |
|-------|--------|
| Description | Entry fees for one-off tournaments, cups, and special events outside regular season |
| Who pays | Teams or individual participants |
| Who receives | Tournament organizer; FTH takes platform fee |
| Key systems | League OS — event registration, bracket/format management, payment rails |
| Operational dependencies | Event format defined; ground secured; max entries set |
| Tokenization suitability | **Not suitable** — episodic, event-level small transactions |
| Offchain / Onchain | Fully offchain |

---

### 4. Membership Dues

| Field | Detail |
|-------|--------|
| Description | Annual or monthly recurring membership fees — general and premium tiers |
| Who pays | Players, fans, community members |
| Who receives | League / club / venue operator; FTH takes platform fee |
| Key systems | Venue OS + League OS — membership wallet, recurring billing, benefit management |
| Operational dependencies | Membership tiers defined; benefits configured; CRM linked |
| Tokenization suitability | **Conditionally suitable (later stage)** — recurring revenue stream; could support SPV structures after stabilization |
| Offchain / Onchain | Offchain initially; onchain optional for founding-member or premium NFT-equivalents in later phase |

---

### 5. Academy and Camp Revenue

| Field | Detail |
|-------|--------|
| Description | Program fees for cricket academies, youth camps, coaching clinics, and training programs |
| Who pays | Families and individual participants |
| Who receives | Academy operator (may be FTH, a partner, or independent); FTH takes platform fee |
| Key systems | League OS — academy enrollment, program management, tuition billing |
| Operational dependencies | Program schedule set; coaches credentialed; capacity limits configured |
| Tokenization suitability | **Conditionally suitable (later stage)** — stable, recurring, facility-linked; candidate for training-facility SPV |
| Offchain / Onchain | Offchain; onchain possible in structured SPV context |

---

### 6. Ticketing Revenue

| Field | Detail |
|-------|--------|
| Description | Per-event admission fees for league matches and special events |
| Who pays | General public and registered members (members may pay reduced or zero) |
| Who receives | Venue operator; FTH takes platform and processing fees |
| Key systems | Venue OS — ticketing, access control, QR/mobile admission |
| Operational dependencies | Venue confirmed; capacity and seating map configured; ground access infrastructure available |
| Tokenization suitability | **Not suitable as primary** — high volume, low per-unit value; could contribute to aggregate venue revenue for SPV |
| Offchain / Onchain | Fully offchain; onchain possible for premium or founding-member ticket bundles |

---

### 7. Concessions and Vendor Revenue

| Field | Detail |
|-------|--------|
| Description | Food, beverage, and merchandise sales at events; revenue share or flat vendor licensing fees |
| Who pays | Event attendees (end consumers); vendors pay licensing or commission |
| Who receives | Vendor (primary); venue operator (commission or fixed fee); FTH takes platform fee on settlement |
| Key systems | Venue OS — vendor management, POS integration, settlement engine |
| Operational dependencies | Vendor agreements in place; POS terminals or integrations configured; settlement schedule defined |
| Tokenization suitability | **Not suitable** — high-volume, low-margin operational revenue |
| Offchain / Onchain | Fully offchain |

---

### 8. Suite and Hospitality Revenue

| Field | Detail |
|-------|--------|
| Description | Premium box, suite, and hospitality package fees — per-event or season-long |
| Who pays | Corporate buyers and high-net-worth individuals |
| Who receives | Venue operator; FTH takes platform and commerce fees |
| Key systems | Venue OS — premium inventory, reservation, billing, access, hospitality management |
| Operational dependencies | Premium inventory physically built; pricing and benefit structure defined; CRM for account management |
| Tokenization suitability | **Well-suited for later-stage structuring** — high per-unit value, clear revenue attribution, institutional buyer profile; primary SPV candidate |
| Offchain / Onchain | Offchain initially; onchain via preferred unit SPV in Capital Markets OS phase |

---

### 9. Sponsorship Revenue

| Field | Detail |
|-------|--------|
| Description | Brand placement, naming, and activation fees paid by corporate sponsors for league and venue inventory |
| Who pays | Corporate sponsors |
| Who receives | League organization and/or venue operator; FTH takes platform fee for reporting and inventory management |
| Key systems | Venue OS + League OS — sponsorship inventory management, activation tracking, performance reporting dashboards |
| Operational dependencies | Inventory map defined; sponsor activation requirements documented; measurement methodology agreed |
| Tokenization suitability | **Conditionally suitable (later stage)** — sponsorship receivables could support structured commercial products after multi-season history |
| Offchain / Onchain | Offchain; receivables financing is purely offchain |

---

### 10. Naming-Rights-Adjacent Commercial Products

| Field | Detail |
|-------|--------|
| Description | Exclusivity fees, category sponsorships, and long-term brand partnership agreements linked to venue or league naming |
| Who pays | Anchor corporate partners |
| Who receives | Venue operator or league organization (rights holder); FTH earns platform-layer fees |
| Key systems | Venue OS — long-term contract management, exclusivity enforcement, reporting |
| Operational dependencies | Rights clearly documented; naming rights holder contractually established; exclusivity categories defined |
| Tokenization suitability | **Not suitable until rights are clearly held and documented** — naming-rights-linked cash flows are a premium SPV input, not a starting point |
| Offchain / Onchain | Offchain; structured finance product possible after multi-year history |

---

### 11. Event-Day Settlement Products

| Field | Detail |
|-------|--------|
| Description | Full end-of-event financial settlement — all revenue collected, all vendor commissions paid, net distribution to operator |
| Who pays | N/A — this is a settlement and distribution function, not a new revenue source |
| Who receives | All parties per agreed distribution rules |
| Key systems | Venue OS — event settlement engine, audit trail, distribution ledger |
| Operational dependencies | All upstream revenue systems configured and processing before settlement runs |
| Tokenization suitability | **Settlement infrastructure, not a tokenizable revenue stream** |
| Offchain / Onchain | Offchain; onchain audit hook possible for compliance-grade reporting |

---

### 12. Media, Content, and Data Products

| Field | Detail |
|-------|--------|
| Description | Licensing of cricket content, data feeds, streaming rights, and analytics products |
| Who pays | Media partners, league data licensees, analytics platforms |
| Who receives | Rights holder (league organization or venue operator); FTH earns platform and data infrastructure fees |
| Key systems | League OS — data exports, API access, content metadata; later-stage media module |
| Operational dependencies | Rights ownership documented; content production infrastructure in place; data governance framework established |
| Tokenization suitability | **Later-stage, rights-dependent** — media and data rights are premium SPV inputs after rights and revenues are established |
| Offchain / Onchain | Offchain initially; media rights receivables could be structured in later phases |

---

## Summary: Offchain vs. Onchain Notes

| Revenue Category | Initial Settlement | Onchain Applicability |
|------------------|--------------------|----------------------|
| League / player fees | Offchain | None |
| Tournament registration | Offchain | None |
| Membership dues | Offchain | Later — premium founding-member tokens |
| Academy revenue | Offchain | Later — training facility SPV |
| Ticketing | Offchain | Later — premium bundle tokens |
| Concessions | Offchain | None |
| Suite / hospitality | Offchain | **Primary SPV candidate** |
| Sponsorship | Offchain | Later — receivables structuring |
| Naming-rights commercial | Offchain | Later — rights-gated structured product |
| Event settlement | Offchain | Audit hooks possible |
| Media / data | Offchain | Later — rights-gated |

**Rule:** All revenue streams begin offchain. Onchain applicability is evaluated only after the stream is legally clean, metrically established, and the rights are documented. No stream moves onchain without securities counsel review and full gating compliance.

---

## Revenue Capture Dependencies

The platform can only capture revenue where the following conditions hold:

| Condition | Required For |
|-----------|-------------|
| Ticketing system live and integrated with venue access | Ticketing, premium access, member admissions |
| Vendor agreements and POS integration complete | Concessions, merchandise |
| Sponsorship inventory map approved by rights holder | Sponsorship, naming-rights reporting |
| Suite and premium inventory physically available | Suite / hospitality revenue |
| League season and format officially structured | League fees, tournament registration, player fees |
| Academy programs scheduled and coaches in place | Academy revenue |
| Media rights formally documented | Media / data products |

---

*FutureTech Holding Company · Commercial Architecture Document · For internal and partner use only.*  
*This document does not constitute a financial model, projection, or offering document.*
