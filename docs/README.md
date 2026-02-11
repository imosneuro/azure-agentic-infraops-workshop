# Documentation

> [Current Version](../VERSION.md) | Central hub for all Agentic InfraOps Workshop documentation

## Quick Links

| Guide | Description |
| --- | --- |
| [Quickstart](quickstart.md) | Get up and running in 10 minutes |
| [Development Workflow](guides/development-workflow.md) | Branch, commit, and PR conventions |
| [Automated Versioning](guides/automated-versioning.md) | How version bumps are managed |
| [Know Before You Go](know-before-you-go.md) | Pre-event setup and what to expect |
| [Copilot Guide](copilot-guide.md) | VS Code, agents, skills, and prompting tips |
| [Scenario Brief](scenario-brief.md) | Nordic Fresh Foods business challenge |
| [Hints & Tips](hints-and-tips.md) | Challenge-specific guidance |
| [Quick Reference Card](quick-reference-card.md) | Printable one-page cheat sheet |
| [Team Role Cards](team-role-cards.md) | Driver, Navigator, Architect, Documenter |
| [Quota Requirements](quota-requirements.md) | Azure resource quota per team |
| [Troubleshooting](troubleshooting.md) | Common issues and fixes |
| [Dev Containers](dev-containers.md) | Dev container setup and customization |
| [Upstream Sync](upstream-sync.md) | How upstream changes flow to this repo |
| [Glossary](GLOSSARY.md) | Key terms and definitions |

## Agents (8 + 3 Subagents)

| Agent | Persona | Step | Model |
| --- | --- | --- | --- |
| InfraOps Conductor | 🎼 Maestro | All | Claude Opus 4.6 |
| Requirements | 📜 Scribe | 1 | Claude Opus 4.6 |
| Architect | 🏛️ Oracle | 2 | Claude Opus 4.6 |
| Design | 🎨 Artisan | 3 | Claude Sonnet 4.5 |
| Bicep Plan | 📐 Strategist | 4 | Claude Opus 4.6 |
| Bicep Code | ⚒️ Forge | 5 | Claude Sonnet 4.5 |
| Deploy | 🚀 Envoy | 6 | Claude Sonnet 4.5 |
| Diagnose | 🔍 Sentinel | — | Claude Sonnet 4.5 |

Validation subagents: `bicep-lint-subagent`, `bicep-whatif-subagent`, `bicep-review-subagent`

## Skills (8)

| Skill | Category | Purpose |
| --- | --- | --- |
| `azure-adr` | Document Creation | Architecture Decision Records |
| `azure-artifacts` | Artifact Generation | Template compliance and artifact output |
| `azure-defaults` | Azure Conventions | Naming, security, governance defaults |
| `azure-diagrams` | Document Creation | Python architecture diagrams |
| `docs-writer` | Documentation | Freshness audits and doc maintenance |
| `git-commit` | Tool Integration | Conventional commit message generation |
| `github-operations` | Workflow | Issues, PRs, Actions, releases via MCP and CLI |
| `make-skill-template` | Meta | Scaffold new skills from template |

## Project Structure

```text
├── .github/
│   ├── agents/             # 8 agent definitions + 3 subagents
│   ├── skills/             # 8 skill definitions
│   │   └── azure-artifacts/templates/  # 16 artifact templates
│   └── instructions/       # 15 file-type instruction files
├── agent-output/{project}/ # Agent-generated artifacts (01-07)
├── docs/                   # User-facing documentation (this folder)
├── hackathon/              # 6-hour hands-on hackathon materials
├── infra/bicep/            # Generated Bicep templates
├── mcp/azure-pricing-mcp/  # Azure Pricing MCP server
└── scripts/                # Validation and automation scripts
```

## Validation Commands

```bash
# Markdown lint
npm run lint:md

# Link validation (docs/ only)
npm run lint:links:docs

# Full validation suite
npm run validate:all
```
