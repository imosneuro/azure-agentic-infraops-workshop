# Changelog

All notable changes to **Agentic InfraOps Microhack** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Version policy:** 1.0.0 will be tagged after the first workshop is successfully delivered.
> Until then, the project evolves under 0.x.x pre-release versions.

## [Unreleased]

---

## [0.9.0] - 2026-02-18

### Added

- **README visual overhaul** — dark-gradient capsule-render hero banner with workshop subtitle
- **Tech stack badge row** — GitHub Copilot · Claude · GPT Codex · Azure Bicep · AVM · WAF · VS Code Dev Container
- **Hand-drawn Mermaid pipeline** — 7-step flowchart (Comic Sans + basis curve); Conductor node added;
  Step 3 marked as optional with dashed border
- **Microhack challenge table** — 8 challenges with focus area and ⭐ difficulty ratings,
  surfaced as primary visible content
- **Upstream sync automation** — scheduled authoritative sync with preflight summary and hands-off merge controls
- **Copilot sub-PR auto-merge** — guarded workflow with multi-strategy superseded PR detection
- **Azure Policy prerequisite callout** in Challenge 3 implementation guide

### Changed

- README trimmed from 665 → ~400 lines — collapsible deep-dives, merged duplicate sections, removed Best Practices fold
- Workshop/microhack content promoted to primary visible position above all collapsible folds
- Contributing and License sections merged into one fold

### Fixed

- Mermaid node labels — replaced `\n` escape with single-line `·` separator; labels now render correctly on GitHub

---

## [0.8.0] - 2026-02-16

### Added

- **Upstream sync** from `jonathan-vella/azure-agentic-infraops` — agent definitions, skills,
  instructions, and MCP config aligned with source
- **docs-writer skill** — updated repo-architecture, doc-standards, and freshness-checklist references
- **Automated versioning workflow** — GitHub Actions detects bump type from conventional commits,
  updates VERSION.md and CHANGELOG.md, creates tags and releases

### Changed

- Repository terminology standardized from "hackathon" → "microhack" across all files
- AGENDA.md restructured with single-source timing and simplified schedule

### Removed

- Stale docs: `dev-containers.md`, `quickstart.md`, `quota-requirements.md`, `scenario-brief.md`,
  `team-role-cards.md`, `guides/automated-versioning.md`, `guides/development-workflow.md`
- Hacker-board assets removed from workshop repo (feature deferred)

---

## [0.7.0] - 2026-02-14

### Added

- **Team leaderboard app** — PRD, API spec, Deploy to Azure button, mandatory auth, attendee registration
- **App backlog** — ops readiness features (F9, F10), Gantt chart project plan, F11 rubric templates
- **Facilitator materials** — expanded guide with WAF-aligned scoring rubric (105 base + 25 bonus points)

### Changed

- Team leaderboard consolidated to `westeurope` region
- Leaderboard documentation reorganized for accuracy

---

## [0.6.0] - 2026-02-11

### Added

- **Documentation overhaul** — `getting-started.md`, `workshop-prep.md`, `guides/contributing.md`,
  `troubleshooting.md`, `copilot-guide.md`, `GLOSSARY.md`, `docs/README.md`
- **Freshness checker script** — `scripts/check-docs-freshness.mjs`
- **VERSION.md** — explicit version tracking
- **Commitlint integration** — conventional commit enforcement via `commitlint.config.js` + lefthook

### Changed

- `package.json` — updated repository metadata
- `CONTRIBUTING.md` — fixed broken links

---

## [0.5.0] - 2026-02-01

### Added

- **Challenge 8: Partner Showcase** — present and defend infrastructure decisions
- **Challenge 7: As-Built Documentation** — full audit trail challenge
- **Challenge 6: Load Testing** — performance validation challenge
- **8-challenge microhack structure** — expanded from 6 to 8 challenges
- **Scoring scripts** — `Score-Team.ps1`, `Get-Leaderboard.ps1`, `Cleanup-MicrohackResources.ps1`
- **Quick reference cards** and team role definitions

### Changed

- Microhack duration updated from 5 hours to 6 hours
- Challenge point values revised for expanded structure

---

## [0.4.0] - 2026-01-30

### Added

- **Multi-agent architecture** — InfraOps Conductor orchestrating 7 specialized agents
- **Diagnostic agent** — `diagnose` / Sentinel for resource health and troubleshooting
- **Validation subagents** — `bicep-lint-subagent`, `bicep-whatif-subagent`, `bicep-review-subagent`
- **Azure Pricing MCP add-on** — `mcp/azure-pricing-mcp/` for real-time SKU cost estimates
- **Agent skills system** — 8 reusable skills: `azure-adr`, `azure-artifacts`, `azure-defaults`,
  `azure-diagrams`, `docs-writer`, `git-commit`, `github-operations`, `make-skill-template`

### Changed

- Agents migrated to `.github/agents/*.agent.md` format with frontmatter model selection
- Instructions system introduced under `.github/instructions/`

---

## [0.3.0] - 2026-01-27

### Added

- **Bicep Code agent** — AVM-first Bicep template generation
- **Deploy agent** — Azure provisioning with what-if preview
- **As-Built agent** — Step 7 documentation suite generation
- **Mandatory approval gates** — 3 human-in-the-loop checkpoints (Plan · Pre-Deploy · Post-Deploy)
- **Sample outputs** — `agent-output/_sample/` with full 01–07 artifact template set

### Changed

- Context conservation pattern adopted — each agent runs in its own isolated context window
- Preflight validation (lint · what-if · review) added before every deployment

---

## [0.2.0] - 2026-01-25

### Added

- **Requirements agent** — structured requirements capture
- **Architect agent** — WAF assessment and cost estimation
- **Design agent** — architecture diagrams and ADRs (optional step)
- **Bicep Plan agent** — governance discovery and phased implementation planning
- **InfraOps Conductor** — master orchestrator for the full 7-step workflow
- **Numbered artifact system** — `01-requirements.md` through `07-*.md` per project
- **Governance discovery subagent** — Azure Policy constraint detection
- **Cost estimate subagent** — pricing isolation from Architect context window

---

## [0.1.0] - 2026-01-22

### Added

- **Repository forked** from `jonathan-vella/azure-agentic-infraops` as workshop baseline
- **6-challenge microhack structure** — 5-hour hands-on training program
- **Challenge materials** (1–6) covering requirements → architecture → implementation
  → DR curveball → load testing → showcase
- **Participant materials** — scenario brief (Nordic Fresh Foods), pre-work checklist, hints and tips
- **Facilitator materials** — guide, WAF-aligned scoring rubric, solution reference
- **AGENDA.md** — detailed schedule with absolute timing (10:00–15:00)
- **Microhack invitation** and feedback form
- **Dev Container** — pre-configured with Azure CLI, Bicep, PowerShell 7+, Python 3.10+

---

## [0.0.1] - 2026-01-20

### Added

- **Initial scaffolding** — repository created as workshop derivative of the upstream Agentic InfraOps project
- **Core directory structure** — `.github/`, `agent-output/`, `docs/`, `infra/bicep/`, `microhack/`, `scripts/`
- **Base README** — project overview, quick start, and microhack introduction
- **LICENSE** — MIT
- **package.json** — project metadata and Node.js tooling baseline

---

## Version Numbering

- **MAJOR** (1.x.x): First workshop successfully delivered
- **MINOR** (x.x.0): New challenges, agents, or significant feature additions
- **PATCH** (x.x.x): Bug fixes, documentation improvements, timing corrections

## Links

- [VERSION.md](VERSION.md)
- [GitHub Releases](https://github.com/jonathan-vella/azure-agentic-infraops-workshop/releases)
