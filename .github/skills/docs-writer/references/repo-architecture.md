# Repo Architecture Reference

> For use by the `docs-writer` skill. Last verified: 2026-02-09.

## Workspace Root Structure

```text
azure-agentic-infraops-workshop/
├── .github/
│   ├── agents/              # 9 agent definitions + 3 subagents
│   │   └── _subagents/      # Validation subagents (lint, what-if, review)
│   ├── skills/              # 8 skill definitions (incl. docs-writer)
│   │   └── azure-artifacts/templates/ # 16 artifact templates
│   ├── instructions/        # 15 file-type instruction files
│   └── workflows/           # 5 CI/automation workflows
├── .sync-config.json        # Upstream sync file classification
├── agent-output/{project}/  # Agent-generated artifacts (01-07)
├── docs/                    # User-facing documentation (15 files)
│   └── guides/              # Workflow and versioning guides
├── hackathon/               # 6-hour hands-on hackathon materials
├── infra/bicep/             # Bicep module library
├── mcp/azure-pricing-mcp/   # Azure Pricing MCP server
└── scripts/                 # Validation and automation scripts
```

## Agent Inventory (9 Primary + 3 Subagents)

### Primary Agents

| Agent | File | Model | Step | Artifacts |
| --- | --- | --- | --- | --- |
| InfraOps Conductor | `infraops-conductor.agent.md` | Opus 4.6 | All | Orchestration |
| Requirements | `requirements.agent.md` | Opus 4.6 | 1 | `01-requirements.md` |
| Architect | `architect.agent.md` | Opus 4.6 | 2 | `02-architecture-assessment.md` |
| Design | `design.agent.md` | Sonnet 4.5 | 3 | `03-des-*.{py,png,md}` |
| Bicep Plan | `bicep-plan.agent.md` | Opus 4.6 | 4 | `04-implementation-plan.md` |
| Bicep Code | `bicep-code.agent.md` | Sonnet 4.5 | 5 | Bicep in `infra/bicep/` |
| Deploy | `deploy.agent.md` | Sonnet 4.5 | 6 | `06-deployment-summary.md` |
| Diagnose | `diagnose.agent.md` | Sonnet 4.5 | — | Diagnostic reports |
| Sync Reviewer | `sync-reviewer.agent.md` | Sonnet 4.5 | — | Sync validation PRs |

### Validation Subagents (in `_subagents/`)

| Subagent | File | Purpose |
| --- | --- | --- |
| bicep-lint-subagent | `bicep-lint-subagent.agent.md` | Syntax validation |
| bicep-whatif-subagent | `bicep-whatif-subagent.agent.md` | Deployment preview |
| bicep-review-subagent | `bicep-review-subagent.agent.md` | AVM code review |

### Shared Knowledge (via Skills)

All shared context previously in `_shared/` is now consolidated into skills:

| Skill | Replaces |
| --- | --- |
| `azure-defaults` | `defaults.md`, `avm-pitfalls.md`, `research-patterns.md`, `service-lifecycle-validation.md` |
| `azure-artifacts` | `documentation-styling.md`, all template H2 structures |

## Skill Catalog (8 Skills)

| Skill | Folder | Category | Triggers |
| --- | --- | --- | --- |
| `azure-adr` | `azure-adr/` | Document Creation | "create ADR", "document decision" |
| `azure-artifacts` | `azure-artifacts/` | Artifact Generation | "generate documentation" |
| `azure-defaults` | `azure-defaults/` | Azure Conventions | "azure defaults", "naming" |
| `azure-diagrams` | `azure-diagrams/` | Document Creation | "create diagram" |
| `docs-writer` | `docs-writer/` | Documentation | "update the docs" |
| `git-commit` | `git-commit/` | Tool Integration | "commit" |
| `github-operations` | `github-operations/` | Workflow | "create issue", "create PR", "gh command" |
| `make-skill-template` | `make-skill-template/` | Meta | "create skill" |

## Template Inventory (16 Templates)

All in `.github/skills/azure-artifacts/templates/`. Naming: `{step}-{name}.template.md`.

| Template | Artifact | Validation |
| --- | --- | --- |
| `01-requirements.template.md` | Requirements | Standard (strict) |
| `02-architecture-assessment.template.md` | WAF Assessment | Standard (strict) |
| `03-des-cost-estimate.template.md` | Design Cost Estimate | Cost validator |
| `04-governance-constraints.template.md` | Governance | Standard (strict) |
| `04-implementation-plan.template.md` | Implementation Plan | Standard (strict) |
| `04-preflight-check.template.md` | Preflight Check | Standard (strict) |
| `05-implementation-reference.template.md` | Impl Reference | Relaxed |
| `06-deployment-summary.template.md` | Deploy Summary | Standard (strict) |
| `07-ab-cost-estimate.template.md` | As-Built Cost | Cost validator |
| `07-backup-dr-plan.template.md` | Backup/DR Plan | Relaxed |
| `07-compliance-matrix.template.md` | Compliance Matrix | Relaxed |
| `07-design-document.template.md` | Design Document | Relaxed |
| `07-documentation-index.template.md` | Doc Index | Relaxed |
| `07-operations-runbook.template.md` | Ops Runbook | Relaxed |
| `07-resource-inventory.template.md` | Resource Inventory | Relaxed |
| `PROJECT-README.template.md` | Project README | — |

## Instruction File Map (15 Files)

| Instruction | Applies To (glob) |
| --- | --- |
| `agent-research-first.instructions.md` | `**/*.agent.md` |
| `agent-skills.instructions.md` | `**/.github/skills/**/SKILL.md` |
| `agents-definitions.instructions.md` | `**/*.agent.md` |
| `artifact-h2-reference.instructions.md` | `**/agent-output/**/*.md` |
| `bicep-code-best-practices.instructions.md` | `**/*.bicep` |
| `copilot-thought-logging.instructions.md` | `**` |
| `cost-estimate.instructions.md` | `**/03-des-cost-estimate.md`, etc. |
| `docs.instructions.md` | `docs/**/*.md` |
| `github-actions.instructions.md` | `.github/workflows/*.yml` |
| `governance-discovery.instructions.md` | `**/04-governance-*.md` |
| `instructions.instructions.md` | `**/*.instructions.md` |
| `markdown.instructions.md` | `**/*.md` |
| `powershell.instructions.md` | `**/*.ps1`, `**/*.psm1` |
| `prompt.instructions.md` | `**/*.prompt.md` |
| `workload-documentation.instructions.md` | `**/agent-output/**/07-*.md` |

## Artifact Flow (7-Step Workflow)

```text
Step 1          Step 2            Step 3         Step 4
Requirements → Architecture →  Design       → Planning
(01-*.md)     (02-*.md)       (03-des-*)     (04-*.md)
                                  │
                                  ├─ Diagrams (03-des-diagram.py/png)
                                  ├─ ADRs (03-des-adr-*.md)
                                  └─ Cost Estimate (03-des-cost-estimate.md)

Step 5            Step 6          Step 7
Implementation → Deploy       → Documentation
(infra/bicep/)  (06-*.md)      (07-*.md × 7 types)
(05-*.md)
```

## Key Files for Documentation Maintenance

These files contain counts, tables, or version references that need
updating when agents or skills change:

| File | Contains |
| --- | --- |
| `docs/README.md` | Agent tables, skill tables, structure tree |
| `docs.instructions.md` | Agent count/table, skill count/table |
| `VERSION.md` | Canonical version number |
| `CHANGELOG.md` | Release history |
| `README.md` (root) | Overview, project structure, tech stack |
| `.sync-config.json` | Upstream sync file tiers (autoSync/reviewSync/neverSync) |
| `docs/upstream-sync.md` | Sync documentation (file counts, PAT instructions) |

## docs/ Folder Contents

| File | Purpose |
| --- | --- |
| `README.md` | Documentation hub with quick links |
| `quickstart.md` | 10-minute getting started guide |
| `know-before-you-go.md` | Pre-event setup and day-of orientation |
| `copilot-guide.md` | Copilot modes, agents, skills, and prompting |
| `scenario-brief.md` | Nordic Fresh Foods business scenario |
| `hints-and-tips.md` | Collapsible hints per challenge |
| `quick-reference-card.md` | Printable one-page reference |
| `team-role-cards.md` | Driver, Navigator, Architect, Documenter |
| `quota-requirements.md` | Azure quota per team |
| `troubleshooting.md` | Common issues and fixes |
| `dev-containers.md` | Dev container setup |
| `GLOSSARY.md` | Terms and definitions |
| `upstream-sync.md` | How upstream changes flow to this repo |
| `guides/development-workflow.md` | Branch, commit, and PR conventions |
| `guides/automated-versioning.md` | Automated version bump guide |

## hackathon/ Folder Contents

| Path | Purpose |
| --- | --- |
| `hackathon/README.md` | Hackathon hub — overview, schedule, scoring |
| `hackathon/AGENDA.md` | Detailed 6-hour schedule with block timing |
| `hackathon/feedback-form.md` | Post-event participant feedback survey |
| `hackathon/workshop-invitation.md` | Event invitation / marketing document |
| `hackathon/challenges/README.md` | Challenge index with flow diagram |
| `hackathon/challenges/challenge-1-requirements.md` | Requirements capture (requirements agent) |
| `hackathon/challenges/challenge-2-architecture.md` | Architecture design (architect agent) |
| `hackathon/challenges/challenge-3-implementation.md` | Bicep implementation (bicep-plan, bicep-code, deploy) |
| `hackathon/challenges/challenge-4-dr-curveball.md` | DR curveball (mid-event surprise) |
| `hackathon/challenges/challenge-5-load-testing.md` | Load testing with k6 |
| `hackathon/challenges/challenge-6-documentation.md` | Workload documentation (design agent) |
| `hackathon/challenges/challenge-7-diagnostics.md` | Troubleshooting card (diagnose agent) |
| `hackathon/challenges/challenge-8-partner-showcase.md` | Partner presentation role-play |
| `hackathon/participant/README.md` | Redirect — points all participant docs to `docs/` |
| `hackathon/facilitator/README.md` | Facilitator materials index |
| `hackathon/facilitator/facilitator-guide.md` | Schedule, curveball script, coaching tips |
| `hackathon/facilitator/scoring-rubric.md` | WAF-aligned scoring (105+25 pts) |
| `hackathon/facilitator/solution-reference.md` | Expected outputs, patterns, commands |

## Skill Discovery & Auto-Invocation

Skills are discovered by VS Code Copilot via **description keyword matching**
in the SKILL.md frontmatter — not through `tools:` arrays in agent definitions.

### Agent-Referenced Skills

These skills are explicitly referenced in agent body text via mandatory
"Read skills FIRST" instructions:

| Skill | Referenced By |
| --- | --- |
| `azure-defaults` | all 8 primary agents |
| `azure-artifacts` | requirements, architect, bicep-plan, deploy, conductor |
| `azure-diagrams` | design, architect agents |
| `azure-adr` | design agent |
| `github-operations` | conductor, bicep-plan agents |

### General-Purpose Skills

Discovered purely by prompt keyword matching — no agent explicitly
references them:

- `git-commit` — Triggered by "commit", "git commit" prompts
- `docs-writer` — Triggered by "update docs", "check staleness" prompts
- `make-skill-template` — Triggered by "create skill", "new skill" prompts

### Instruction Files (Separate Mechanism)

Instruction files (`.github/instructions/*.instructions.md`) load automatically
via `.gitattributes` `applyTo` globs — this is a distinct mechanism from skill
discovery. Instructions are file-type-scoped rules, not invokable skills.
