# Changelog

All notable changes to **Agentic InfraOps Hackathon** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-11

### Added

- **Documentation overhaul** — created missing docs (quickstart, troubleshooting, copilot-tips,
  dev-containers, glossary, docs README), freshness checker script, VERSION.md
- **Automated versioning system** — GitHub Actions workflow for version management
  - Auto-detects version bump type from conventional commits
  - Updates VERSION.md and CHANGELOG.md automatically
  - Creates Git tags and GitHub releases
  - See [docs/guides/automated-versioning.md](docs/guides/automated-versioning.md) for usage guide
- **Commitlint integration** — Enforces conventional commit format
  - Configured via commitlint.config.js
  - Runs automatically on commit via lefthook
  - Supports feat:, fix:, docs:, chore:, and breaking changes

### Changed

- **package.json** — Updated repository metadata and reset version to 1.0.0
- **README.md** — Fixed stale skill/agent counts and removed references to deleted skills
- **CONTRIBUTING.md** — Fixed broken links to development workflow guide
- **docs-writer references** — Updated repo-architecture, doc-standards, and freshness-checklist
  to match the actual workshop repo structure

---

> **Pre-reset history** — entries below are from the upstream fork before the
> workshop baseline was established at 1.0.0.

## [0.1.1] - 2026-01-22 (pre-reset)

### Added

- expand upstream sync to include config files and automation
- add hackathon proofreading prompt
- create single-source AGENDA.md and reduce duplication
- add hackathon scripts README and fix governance policies
- add Challenge 6 Partner Showcase and hackathon invitation
- add Azure Policy governance constraints
- add 5-hour hands-on hackathon package

### Changed

- standardize formatting and improve clarity in proofreading prompt
- simplify prerequisites check for Dev Container/Codespaces

### Fixed

- change auto-version to create PR instead of direct push (#7)
- use cat instead of sed for CHANGELOG insertion (#5)
- correct hackathon duration to 5 hours (#4)
- upgrade to softprops/action-gh-release@v2 (#2)
- hide curveball details in AGENDA.md
- adjust lunch to 35min and add 15min presentation prep
- update schedule timing with 10am start and lunch break
- correct repo root path calculation in hackathon scripts
- resolve MD013 line length violations

## [0.1.0] - 2026-01-22 (pre-reset)

### Fixed

- **Timing consistency across hackathon documentation** - Fixed relative timing to absolute times
  - Changed README.md schedule from relative (0:00-5:00) to absolute (10:00-15:00) matching AGENDA.md
  - Updated curveball announcement timing from "4:15" to "13:20" across all files
  - Corrected challenge durations to match AGENDA.md:
    - Challenge 1: 40 min → 45 min
    - Challenge 2: 40 min → 45 min
    - Challenge 3: 40 min → 45 min
  - Fixed facilitator/README.md curveball timing reference
- **Agent name formatting standardization** - Consistent backtick formatting for agent names
  - Changed "Plan Agent" to "`plan` Agent" in challenge-1-requirements.md
  - Changed "Bicep Plan Agent" to "`bicep-plan` Agent" in challenge-3-implementation.md
  - Updated hints-and-tips.md section headers to use backtick formatting
  - Added bold formatting to **plan** agent reference in AGENDA.md

## [0.0.1] - 2026-01-22 (pre-reset)

### Added

- **5-hour hackathon** - Complete hands-on training program
  - 6 challenges covering full Infrastructure as Code workflow
  - Team-based learning (3-4 members per team, 20-24 participants)
  - Real Azure deployment with scoring and leaderboard
- **Challenge materials** - Six comprehensive challenge documents
  - Challenge 1: Requirements Gathering (45 min, 20 points)
  - Challenge 2: Architecture Assessment (45 min, 25 points)
  - Challenge 3: Bicep Implementation (45 min, 25 points)
  - Challenge 4: Multi-Region DR Curveball (20 min, 10 points)
  - Challenge 5: Load Testing (15 min, 5 points)
  - Challenge 6: Partner Showcase (40 min, unscored)
- **Participant materials** - Complete pre-work and reference documentation
  - Scenario brief: Nordic Fresh Foods business challenge
  - Pre-work checklist with Docker, VS Code, and Azure setup
  - Hints and tips for architecture and cost optimization
  - Quick reference card for common commands and patterns
  - Team role cards for Requirements Lead, Architect, Developer, Ops Engineer
- **Facilitator materials** - Comprehensive coaching and scoring guides
  - Detailed facilitator guide with timing and troubleshooting
  - WAF-aligned scoring rubric (105 base + 25 bonus points)
  - Solution reference with expected outputs and patterns
  - PowerShell scoring scripts for automated evaluation
- **Hackathon invitation** - Marketing material for participant recruitment
- **AGENDA.md** - Detailed schedule with 10:00-15:00 absolute timing
- **Feedback form** - Post-hackathon evaluation mechanism

### Changed

- **Hackathon format** - Designed for partner enablement and customer demonstrations
  - SI partners delivering Azure projects
  - IT Pros learning Infrastructure as Code
  - Customers evaluating agentic workflows
- **Curveball challenge** - Mid-hackathon surprise requirement at 13:20
  - Tests adaptability to changing requirements (real-world simulation)
  - Multi-region DR requirement increases budget from €500 to €700/month

## Version Numbering

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to hackathon structure or challenge flow
- **MINOR**: New challenges, scenarios, or significant hackathon enhancements
- **PATCH**: Bug fixes, documentation improvements, timing corrections

## Links

- [VERSION.md](VERSION.md) - Detailed version history
- [GitHub Releases](https://github.com/jonathan-vella/azure-agentic-infraops-workshop/releases)
