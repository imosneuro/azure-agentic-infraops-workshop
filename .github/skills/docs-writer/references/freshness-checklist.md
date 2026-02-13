# Freshness Checklist

> For use by the `docs-writer` skill. Defines audit targets and auto-fix
> rules for detecting stale documentation.

## How to Run a Freshness Audit

1. Read `VERSION.md` to get the canonical version number.
2. Walk through each audit target below.
3. For each issue found, note: file path, line, issue, suggested fix.
4. Present all issues in a summary table.
5. Apply fixes after user confirmation (or immediately if told "fix all").

## Audit Targets

### 1. Version Number Sync

**Source of truth**: `VERSION.md` → `Current Version: X.Y.Z`

**Files to check**:

| File                                        | What to look for                   |
| ------------------------------------------- | ---------------------------------- |
| `docs/*.md`                                 | `> Version X.Y.Z` in header line   |
| `.github/instructions/docs.instructions.md` | Version in header template example |

**Auto-fix**: Replace old version string with current from `VERSION.md`.

### 2. Agent Count and Table

**Source of truth**: List `.github/agents/*.agent.md` files
(exclude `_subagents/` directory).

**Expected count**: derive dynamically from filesystem at audit time.

**Files to check**:

| File                                        | What to verify                                       |
| ------------------------------------------- | ---------------------------------------------------- |
| `docs/README.md`                            | `## Agents (N + 3 Subagents)` heading and table rows |
| `.github/instructions/docs.instructions.md` | `### Agents (N total)` and table                     |
| `docs/README.md` project structure          | `# N agent definitions` comment                      |

**Auto-fix**: Update count in heading. Add missing agents to table
matching the existing column format. Remove entries for agents that
no longer exist.

### 3. Skill Count and Table

**Source of truth**: List `.github/skills/*/` directories
(exclude `README.md` file).

**Expected count**: derive dynamically from filesystem at audit time.

**Files to check**:

| File                                        | What to verify                         |
| ------------------------------------------- | -------------------------------------- |
| `docs/README.md`                            | `## Skills (N)` heading and table rows |
| `.github/instructions/docs.instructions.md` | `### Skills (N total)` and table       |
| `docs/README.md` project structure          | `# N skill definitions` comment        |

**Auto-fix**: Update count in heading. Add missing skills to the
appropriate category table. Remove entries for deleted skills.

### 4. Prohibited References

**Rule**: Removed agents must not be referenced in live docs.

**Banned patterns**:

- `docs/reference/`
- `docs/getting-started.md`
- `azure-workload-docs`
- `azure-deployment-preflight`
- `gh-cli` (skill)
- `github-issues` (skill)
- `github-pull-requests` (skill)
- `orchestration-helper`
- `.github/templates/` (old path; now `.github/skills/azure-artifacts/templates/`)
- `docs/copilot-tips.md` (replaced by `docs/copilot-guide.md`)
- `hackathon/participant/copilot-guide.md` (moved to `docs/copilot-guide.md`)
- `hackathon/participant/pre-work-checklist.md` (absorbed into `docs/know-before-you-go.md`)
- `hackathon/participant/scenario-brief.md` (moved to `docs/scenario-brief.md`)
- `hackathon/participant/hints-and-tips.md` (moved to `docs/hints-and-tips.md`)
- `hackathon/participant/quick-reference-card.md` (moved to `docs/quick-reference-card.md`)
- `hackathon/participant/team-role-cards.md` (moved to `docs/team-role-cards.md`)
- `hackathon/participant/quota-requirements.md` (moved to `docs/quota-requirements.md`)

**Banned agent names in hackathon docs** (`hackathon/**/*.md`):

- `docs` agent (renamed to `design`)
- `diagram` agent (replaced by `design` agent + `azure-diagrams` skill)
- `plan` agent (renamed to `requirements`)

**Files to check**: All `docs/**/*.md`, `hackathon/**/*.md`, `README.md`, `CONTRIBUTING.md`.

**Auto-fix**: Replace with the correct skill reference
(see `references/doc-standards.md` → Prohibited References table).

### 5. Deprecated Path Links

**Rule**: No live doc should link to removed directories.

**Check**: Grep all in-scope markdown files for links to non-existent paths.

**Auto-fix**: Remove the link or replace with the current equivalent.

### 6. Instruction File Table Sync

**Source of truth**: List `.github/instructions/*.instructions.md` files.

**Expected count**: derive dynamically from filesystem at audit time.

**Files to check**: Only relevant if `docs/README.md` or the root
`README.md` lists instruction files.

**Auto-fix**: Update count and table entries.

### 7. Template Inventory Sync

**Source of truth**: List `.github/skills/azure-artifacts/templates/*.template.md` files.

**Expected count**: derive dynamically from filesystem at audit time.

**Files to check**: Only relevant if documentation references
template counts.

**Auto-fix**: Update count reference.

### 8. Hackathon Agent References

**Rule**: All hackathon files must reference only current agent names.

**Files to check**: All `hackathon/**/*.md`.

**Verify**:

| Pattern                           | Should be                                      |
| --------------------------------- | ---------------------------------------------- |
| `\`docs\`` agent                  | `\`design\`` agent                             |
| `\`diagram\`` agent               | `\`design\``agent (with`azure-diagrams` skill) |
| `\`plan\``agent (not`bicep-plan`) | `\`requirements\`` agent                       |
| `.github/templates/`              | `.github/skills/azure-artifacts/templates/`    |

**Auto-fix**: Replace old agent names with current names.
Add brief context about the agent's role where helpful.

### 9. Hackathon Duration and Team Count

**Source of truth**: `hackathon/AGENDA.md` schedule (10:00-16:00 = 6 hours).

**Files to check**:

| File                                         | What to verify                 |
| -------------------------------------------- | ------------------------------ |
| `hackathon/workshop-invitation.md`           | Duration says "6 hours"        |
| `hackathon/feedback-form.md`                 | Duration says "6-hour"         |
| `hackathon/facilitator/facilitator-guide.md` | Block timing matches AGENDA.md |

**Team policy**: Verify all files use the same team-size and team-count policy.

**Auto-fix**: Replace incorrect duration/team counts.

### 11. Hackathon Scoring and Tooling Alignment

**Source of truth**: `hackathon/facilitator/scoring-rubric.md`

**Files to check**:

| File                                                   | What to verify                                       |
| ------------------------------------------------------ | ---------------------------------------------------- |
| `hackathon/README.md`                                  | Base points and scoring narrative align with rubric  |
| `hackathon/AGENDA.md`                                  | Challenge points align with rubric                   |
| `hackathon/challenges/challenge-8-partner-showcase.md` | Showcase points and format align with rubric         |
| `scripts/hackathon/Score-Team.ps1`                     | Category weights and fields align with rubric        |
| `scripts/hackathon/Get-Leaderboard.ps1`                | Display columns/denominators align with script model |

**Auto-fix**: Update docs, scripts, and leaderboard formatting as one change set.

### 10. Upstream Sync Configuration

**Source of truth**: `.sync-config.json` at workspace root.

**Files to check**:

| File                                    | What to verify                                    |
| --------------------------------------- | ------------------------------------------------- |
| `docs/upstream-sync.md`                 | File tier counts match `.sync-config.json` arrays |
| `docs/upstream-sync.md`                 | PAT instructions match current GitHub UI          |
| `.github/agents/sync-reviewer.agent.md` | neverSync file list matches config                |
| `.github/workflows/sync-upstream.yml`   | Uses `secrets.SYNC_PAT` correctly                 |

**Auto-fix**: Update file counts and tier listings in `docs/upstream-sync.md`.

## Summary Table Template

When reporting audit results, use this format:

```markdown
| #   | File                 | Line | Issue                                   | Fix            |
| --- | -------------------- | ---- | --------------------------------------- | -------------- |
| 1   | docs/README.md       | 42   | Agent count says 6, actual is 8         | Update heading |
| 2   | docs.instructions.md | 34   | Missing `design` and `conductor` agents | Add table rows |
```

## Known Issues

No fixed known-issues snapshot. Freshness checks are expected to run against
the current filesystem and scripts at audit time.
