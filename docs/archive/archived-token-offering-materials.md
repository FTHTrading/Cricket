# ARCHIVED: Token Offering Materials

`docs/archive/archived-token-offering-materials.md`  
**Status:** ARCHIVED — superseded April 2026  
**Reason for archival:** These materials described ACS-S (Atlanta Cricket Stadium Series) token structures tied to the stadium ownership thesis. That thesis has been retired. The token offering was never launched and was never reviewed by securities counsel.

---

> ⚠️ **ARCHIVE NOTICE**
>
> The token offering materials below have been retired. The ACS-S token offering described here was **never launched, never offered to investors, and never reviewed by qualified securities counsel**. These materials are preserved strictly for internal reference. They must not be used in any external communication.
>
> Any future digital securities activity will follow the gated, counsel-reviewed framework documented at [`docs/technology/12-digital-securities-readiness-notes.md`](../technology/12-digital-securities-readiness-notes.md) and [`docs/capital-markets/06-ancillary-capital-markets-framework.md`](../capital-markets/06-ancillary-capital-markets-framework.md).

---

## ACS-S Token Overview (Prior Design)

**Token Name:** ACS-S (Atlanta Cricket Stadium Series)  
**Standard:** ERC-3643 (T-REX) — reference architecture  
**Chain:** Ethereum mainnet (intended)  
**Status:** Reference design only — never deployed

| Parameter | Prior Target |
|-----------|-------------|
| Total supply | 50,000,000 ACS-S |
| Reserved: team and founders | 10,000,000 (20%) |
| Reserved: platform and operations | 8,000,000 (16%) |
| Reserved: future ecosystem | 7,000,000 (14%) |
| Public / investor allocation | 25,000,000 (50%) |
| Offering size | ~$35M (at $1.40/token implied) |
| Offering structure | Reg D 506(c) — accredited investors only |
| Transfer restrictions | 12-month lock; accredited transfer gating |
| Distribution mechanism | Quarterly revenue distributions |

---

## ACS-S Waterfall (Prior Design)

The prior design described the following distribution waterfall:

```
Gross Stadium Revenue
    │
    ├── Operating Expenses (debt service, OpEx, maintenance)
    │
    ├── Reserve Fund (12 months OpEx)
    │
    ├── Senior Debt Service
    │
    ├── Mezzanine Returns
    │
    └── Distributable Cash
              │
              ├── 60% → ACS-S token holders (pro rata by tokens held)
              └── 40% → FutureTech equity (retained)
```

---

## Why These Materials Were Retired

| Issue | Detail |
|-------|--------|
| Stadium asset does not exist | The underlying revenue stream (stadium operations) is not established |
| Rights not confirmed | The commercial revenue it claims to distribute is not legally secured by FTH |
| No legal review | No qualified securities counsel reviewed these token structures before they were documented |
| No PPM | No Private Placement Memorandum has been drafted |
| No investor verification | No KYC/AML or accredited investor verification infrastructure was in place |
| No audit | The smart contract (`AtlantaCricketToken.sol`) has not been audited |
| No secondary market plan | The prior design left secondary liquidity undefined |

Any one of these issues would be disqualifying for a legitimate launch. All of them together represent an offering that was significantly under-designed.

---

## What Was Carried Forward

| Element | Status in Current Repo |
|---------|----------------------|
| ERC-3643 (T-REX) as the correct standard | Maintained — see `12-digital-securities-readiness-notes.md` |
| Reg D 506(c) as offering vehicle | Maintained as reference path in capital markets framework |
| Pro-rata distribution mechanics | Preserved as structural concept in `06-ancillary-capital-markets-framework.md` |
| Transfer restriction model | Preserved as architectural requirement in `12-digital-securities-readiness-notes.md` |
| Smart contract reference | Retained at `contracts/AtlantaCricketToken.sol` — explicitly labeled as reference only |

---

## Specific Contract Status

**File:** `contracts/AtlantaCricketToken.sol`

The contract file is retained in this repository as a technical reference. It demonstrates:
- ERC-3643 structural intent
- Token parameter patterns
- Distribution and restriction hooks

It does **not**:
- Constitute a production-ready deployment
- Represent a reviewed or audited implementation
- Carry any legal authority or offering status
- Define a live or imminent offering

A production digital securities deployment requires a full rebuild against the T-REX reference implementation, a third-party audit, and legal review of off-chain/on-chain mechanics alignment. See `12-digital-securities-readiness-notes.md` for full requirements.

---

## Path Forward for Compliant Token Activity

If and when FutureTech determines that a compliant digital securities offering is appropriate for a specific, rights-gated, revenue-generating SPV, the process begins here:

1. Identify which specific revenue stream justifies structure
2. Engage securities counsel
3. Define offering type (most likely Reg D 506(c) initially)
4. Draft formal PPM with counsel
5. Build or procure ERC-3643 compliant smart contract
6. Audit the contract
7. Deploy identity registry and KYC infrastructure
8. File Form D (Reg D) with SEC
9. Launch investor outreach to verified accrediteds only
10. Ongoing compliance monitoring

**Steps 1–10 are all prerequisites. This repo is currently at Step 0.**

---

*These archived materials are preserved for internal reference only. No ACS-S token has been offered, sold, or deployed. All references to tokenized offerings are historical research materials, not current intentions or live programs.*
