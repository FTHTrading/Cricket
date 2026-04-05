# Contributing to Atlanta Cricket RWA

Thank you for your interest in contributing to the Atlanta Cricket RWA tokenization project.

## ⚠️ Securities Law Notice

This repository contains structural planning documents for a **regulated securities offering**.
All contributions must comply with applicable securities laws and regulations.

**Do NOT submit changes that:**
- Alter offering terms, pricing, or token economics without legal review
- Modify compliance controls or transfer restrictions in smart contracts
- Add marketing language that could constitute a general solicitation
- Include investor-identifiable information or confidential deal data

## How to Contribute

### 1. Documentation Improvements

- Fix typos, formatting, or broken links
- Improve clarity of existing explanations
- Add missing cross-references between documents

### 2. Smart Contract Enhancements

- Bug fixes or security improvements to reference contracts
- Additional compliance modules (lockup, jurisdiction, max holders)
- Test coverage improvements
- Gas optimization suggestions

### 3. Financial Model Feedback

- Identify calculation errors or inconsistencies
- Suggest additional sensitivity scenarios
- Propose comparable venue data for revenue validation

## Process

1. **Fork** the repository
2. **Create a branch** for your changes (`git checkout -b feature/your-feature`)
3. **Make your changes** following existing formatting conventions
4. **Test** any smart contract changes thoroughly
5. **Submit a Pull Request** with a clear description of changes

## Code Style

### Markdown Documents
- Use ATX-style headers (`#`, `##`, `###`)
- Tables must be pipe-delimited with alignment
- Financial figures use `$X.XM` format consistently
- Version numbers in document headers must stay consistent

### Solidity Contracts
- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use NatSpec comments for all public functions
- Maintain role-based access control patterns
- All state changes must emit events

## Review Process

All PRs require review. Changes affecting:
- **Financial terms** → Requires legal counsel sign-off
- **Smart contract logic** → Requires security review
- **Offering structure** → Requires compliance review
- **Documentation only** → Standard review

## Questions?

Open an issue or reach out to the maintainers.

---

**© 2026 FTH Trading / Atlanta Cricket Holdings**
