# Digital Securities Readiness Notes
## Reference Architecture for Compliant Onchain Instruments

`docs/technology/12-digital-securities-readiness-notes.md`  
**Owner:** FutureTech Holding Company · **Version:** 1.0 · **Date:** April 2026  
**Classification:** Internal planning and reference only

---

## Read This First

> **The `contracts/AtlantaCricketToken.sol` file in this repository is a reference implementation. It is not production-ready. It has not been audited. It does not represent an active or intended securities offering.**
>
> **This document exists to map the distance between the current codebase and a compliant, production-ready digital securities deployment — so that FutureTech can make an informed decision about whether and when to cross that distance.**

That distance is significant. It involves legal, regulatory, technical, and commercial prerequisites that do not yet exist for this platform. This document enumerates them plainly.

---

## What ERC-3643 (T-REX) Is

ERC-3643, the T-REX (Token for Regulated EXchanges) standard, is the leading approach for compliant onchain securities in EVM ecosystems. It extends ERC-20 with an identity and compliance layer that:

- Restricts token transfers to verified, KYC/AML-cleared identity holders
- Embeds transfer rules at the contract level (not just in TOS)
- Supports regulatory compliance across multiple jurisdictions
- Creates a linked registry of identity claims managed by a Trusted Claims Issuer (TCI)
- Provides forced transfer, recovery, and freeze mechanisms required by regulators

This makes ERC-3643 substantially more suitable for regulated securities than raw ERC-20 or standard ERC-721 tokens.

---

## Current Contract Status

**File:** `contracts/AtlantaCricketToken.sol`

| Attribute | Status |
|-----------|--------|
| Standard | Partially references ERC-3643 architecture |
| Audit | None — unaudited |
| Legal review | None |
| KYC/AML integration | Not implemented |
| Identity registry | Not implemented |
| Transfer compliance module | Not implemented |
| Multi-jurisdiction compliance rules | Not implemented |
| Offering registration (Reg D / Reg CF / Reg A+) | Not filed |
| Regulatory review | Not conducted |
| Production-readiness | No |

This contract should be treated strictly as a technical design reference while the architecture is thought through.

---

## Production Requirements Checklist

Before any ERC-3643-based digital securities offering can legally proceed, the following minimum conditions must all be satisfied. This is not an exhaustive legal checklist — it is the minimum floor for beginning a proper process.

### Legal Prerequisites

- [ ] Engagement of qualified U.S. securities counsel (securities regulatory specialist, not general corporate)
- [ ] Offering structure legally determined (Reg D 506(b) or 506(c); Reg CF; Reg A+; or exchange-listed)
- [ ] Determination that the intended instrument is or is not a security under the Howey Test (with counsel)
- [ ] Operating entity with clear legal structure (LLC, C-Corp, LP) established for the SPV or issuer
- [ ] Clear description of what rights the token represents (revenue share, equity, debt, or other) formalized in legal agreements, not only in smart contracts
- [ ] Transfer restriction mechanics validated by counsel and confirmed as compliant with applicable securities exemptions
- [ ] State Blue Sky compliance reviewed for all target investor states
- [ ] CIK registered with SEC if proceeding under Reg A+ or other registered offering path

### KYC/AML Prerequisites

- [ ] Accredited investor verification process implemented (for Reg D 506(c)) — includes income/net worth documentation and third-party verification
- [ ] AML/KYC screening provider integrated (e.g., Jumio, Onfido, Persona, or equivalent)
- [ ] Trusted Claims Issuer (TCI) for ERC-3643 identity registry defined and operationalized
- [ ] On-chain identity claims linked to off-chain verified identities (off-chain verification, on-chain claim assertion)
- [ ] Ongoing identity monitoring process defined (sanctions, PEP screening, watchlist monitoring)

### Technical Prerequisites

- [ ] ERC-3643-compliant smart contract implementation (not the current reference contract)
- [ ] Smart contract audit by recognized audit firm (e.g., Trail of Bits, OpenZeppelin, Halborn, Certik, or equivalent)
- [ ] Identity registry contract deployed and tested with TCI infrastructure
- [ ] Transfer compliance module implementing all applicable rules (accredited investor gating, holding period enforcement, volume limits)
- [ ] Forced transfer and recovery mechanism tested with a simulated regulatory freeze scenario
- [ ] Upgrade path and governance mechanism for contract updates post-deployment
- [ ] Custody solution defined — who holds tokens on behalf of investors, how key custody works
- [ ] Disaster recovery and key rotation procedure documented
- [ ] On-chain oracle solution (if revenue distributions are token-linked) tested for manipulation resistance

### Commercial Prerequisites

- [ ] Specific revenue stream or asset already generating measurable, stable cash flows
- [ ] Operating rights legally documented — FTH has a legal right to commercialize the specific revenue stream being tokenized
- [ ] Investor relations process defined (reporting cadence, distribution schedule, token holder communications)
- [ ] Secondary market strategy defined — is there an ATS or no secondary market? (significant legal implications)
- [ ] Liquidation and wind-down mechanics defined in offering documents

### Offering Documentation Prerequisites

- [ ] Private Placement Memorandum (PPM) or Regulation A+ Offering Circular drafted by securities counsel
- [ ] Subscription agreement with appropriate investor representations drafted
- [ ] Token Terms and Conditions as a legal supplement coordinating smart contract mechanics with legal rights
- [ ] Risk factor disclosures reviewed and finalized
- [ ] All materials reviewed for material omissions under securities anti-fraud rules

---

## ERC-3643 Architecture Reference

The following shows the components of a production ERC-3643 deployment. FutureTech's reference contract addresses only the base token layer.

```
Production ERC-3643 Stack
│
├── TREX Factory
│     └── Deploys token + registry + compliance + identity components
│
├── Identity Registry
│     ├── Identity Store (addresses ↔ identity claims)
│     ├── Trusted Issuers Registry (who can issue claims)
│     └── Claim Topics Registry (what claims are required)
│
├── Compliance Module
│     ├── Transfer restriction rules (accredited-investor-only, etc.)
│     ├── Holding period enforcement
│     └── Volume and concentration limits
│
├── Token Contract (ERC-3643)
│     ├── Standard ERC-20 interface
│     ├── Transfer overrides (compliance module call on every transfer)
│     ├── Forced transfer (regulatory)
│     ├── Freeze wallet (regulatory)
│     └── Recovery (lost wallet)
│
└── Agent / TCI Layer
      ├── Trusted Claims Issuer (KYC verification → on-chain claim)
      └── Token Agent (forced operations with regulatory authority)
```

The current `contracts/AtlantaCricketToken.sol` must be substantially rebuilt against this architecture, not extended from its current state.

---

## Offering Structure Options

| Structure | Investor Type | Max Raise | Disclosure | Best For |
|-----------|-------------|-----------|------------|----------|
| Reg D 506(b) | Accredited + up to 35 sophisticated | Unlimited | Private (no filing, no general solicitation) | Smallest initial raise, fastest |
| Reg D 506(c) | Accredited only | Unlimited | Private (filing required; general solicitation allowed) | Wider outreach to accredited investors |
| Reg CF | Any (retail + accredited) | $5M/12 months | Public filing (Form C) | Community round, retail investors |
| Reg A+ Tier 1 | Any | $20M/12 months | SEC qualified, state Blue Sky required | Larger retail offering |
| Reg A+ Tier 2 | Any | $75M/12 months | SEC qualified, no state Blue Sky required | Largest compliant raise without full registration |

For FTH's ancillary SPV structures at current stage, **Reg D 506(c)** is the most likely path for an initial activation — accredited investors only, general solicitation permitted after filing.

---

## Readiness Gate Enforcement

This platform enforces the following gate:

```
Phase 1: Operate (League OS + Venue OS live, generating data)
    │
    ▼
Phase 2: Monetize (revenue streams stable, rights documented)
    │
    ▼
Phase 3: Package (SPV structure defined, counsel engaged)
    │
    ▼
Phase 4: Prepare (PPM drafted, KYC system ready, audit complete)
    │
    ▼
Phase 5: Offer (if and only if all above gates satisfied)
```

**No external investor communications, roadshows, or token marketing of any kind begin before Phase 4 is complete.**

---

## What the Current Codebase Needs Before Production

1. **Rebuild the contract** from scratch against the ERC-3643 T-REX reference implementation (available at `github.com/TokenySolutions/T-REX`)
2. **Integrate the identity registry** — full Trusted Claims Issuer infrastructure, not just the base token
3. **Implement compliance module** with at minimum: accredited investor gating, one-year holding period (Reg D Rule 144), and freeze/recovery mechanics
4. **Third-party audit** — at minimum one recognized auditor before any mainnet deployment
5. **Legal review of the contract** by securities counsel who can confirm the on-chain mechanics match the legal rights stated in the offering documents
6. **Testnet deployment** followed by extended testing before any mainnet consideration

---

## Honest Timeline Assessment

Given the prerequisites above, **no realistic timeline for a production compliant digital securities offering is less than 12–18 months from a standing start** — assuming legal, commercial, and technical work proceeds in parallel.

FutureTech's current state is: standing start.

This is not a problem. It means the sequencing in this repo (operate first, capital markets later) is correct. Building towards this capability while running real operations is the right approach.

---

## References and Resources

- ERC-3643 (T-REX) specification: [eip-3643.org](https://eip-3643.org)
- TokenySolutions T-REX reference implementation: [github.com/TokenySolutions/T-REX](https://github.com/TokenySolutions/T-REX)
- SEC Regulation D FAQ: [sec.gov/info/smallbus/secg/regulation-d-amendments-secg.htm](https://www.sec.gov/info/smallbus/secg/regulation-d-amendments-secg.htm)
- Reg CF overview: [sec.gov/smallbusiness/exemptofferings/regcrowdfunding](https://www.sec.gov/smallbusiness/exemptofferings/regcrowdfunding)
- ATS (Alternative Trading System) framework: consult securities counsel for secondary market implications

---

*FutureTech Holding Company · Digital Securities Readiness Notes · Planning reference only.*  
*Not legal advice. Not an offering. Consult qualified securities counsel before any capital-markets activity.*
