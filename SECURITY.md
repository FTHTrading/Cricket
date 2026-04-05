# Security Policy

## ⚠️ Important Notice

The smart contracts in this repository are **reference implementations only** and are
**NOT intended for production deployment**. Production deployment requires:

- Full ERC-3643 (T-REX) framework integration
- ONCHAINID identity verification system
- Professional security audit by a recognized firm
- Formal verification of critical paths
- Comprehensive test coverage (unit, integration, fuzzing)

## Supported Versions

| Version | Status |
|:--------|:-------|
| v2.0 (current) | Active development — reference only |
| v1.0 | Superseded — do not use |

## Reporting a Vulnerability

If you discover a security vulnerability in any smart contract code or
documentation that could expose sensitive information:

### For Smart Contract Issues

1. **DO NOT** open a public issue
2. Email: [security contact to be established]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Suggested fix (if any)

### For Documentation Issues

- If the issue does not expose sensitive data, open a regular GitHub issue
- If it exposes confidential financial or investor information, email directly

## Response Timeline

| Action | Timeframe |
|:-------|:----------|
| Acknowledgment | Within 48 hours |
| Initial assessment | Within 5 business days |
| Fix deployment | Depends on severity |
| Public disclosure | After fix is verified |

## Scope

### In Scope
- Smart contract vulnerabilities (reentrancy, access control, overflow)
- Transfer restriction bypass possibilities
- Identity verification circumvention
- Compliance rule violations in contract logic
- Information leakage in documentation

### Out of Scope
- Issues in third-party dependencies (report to those projects)
- Theoretical attacks requiring >51% hash power
- Social engineering attacks
- Issues in non-deployed reference code that are clearly documented

## Acknowledgments

We appreciate responsible disclosure and will acknowledge security researchers
who report valid vulnerabilities (with their permission).

---

**© 2026 FTH Trading / Atlanta Cricket Holdings**
