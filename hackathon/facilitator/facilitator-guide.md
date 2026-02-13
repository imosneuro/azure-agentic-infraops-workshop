# Facilitator Guide

> **For hackathon coaches and facilitators only.**

## Event Overview

| Aspect      | Details                               |
| ----------- | ------------------------------------- |
| Duration    | 6 hours (10:00 - 16:00)               |
| Team Size   | 3-6 members per team                  |
| Teams       | Flexible based on cohort              |
| Format      | Challenge-based, full 7-step workflow |
| Skill Level | Azure portal familiar, new to IaC     |

## Your Role

1. **Guide, don't solve** — Help teams find answers, don't write their code
2. **Monitor progress** — Check in with each team every 15-20 minutes
3. **Unblock quickly** — Don't let teams stall for more than 5 minutes on setup issues
4. **Encourage experimentation** — There's no single "correct" architecture
5. **Celebrate learning** — The goal is understanding, not perfection

---

## Coaching Philosophy

**Answer questions with questions.** Your goal is to help teams develop problem-solving skills, not
to provide direct solutions.

### Coaching Phrases to Use

| Situation                    | Say This                                        |
| ---------------------------- | ----------------------------------------------- |
| Team asks how to fix error   | "What does the error message tell you?"         |
| Team asks for solution       | "What have you tried so far?"                   |
| Team stuck on agent prompt   | "How would you prompt the agent to solve this?" |
| Team unsure about decision   | "What business requirement drives this?"        |
| Team asks "Should we use X?" | "What would you try? What are the tradeoffs?"   |

### When to Provide Direct Help

Only intervene directly when:

- **Environment issues** (authentication, tool failures)
- **Time-critical blocks** (team stalled >5 minutes on setup)
- **Factual information** ("Which region supports zone redundancy?")

**Remember**: Struggle leads to learning. Let teams work through challenges with guidance, not
solutions.

---

## Pre-Event Setup

### Governance Policies (Optional but Recommended)

Deploy Azure Policies to create realistic governance constraints. Teams will encounter real policy errors!

```powershell
# Check current governance status
.\scripts\hackathon\Get-GovernanceStatus.ps1 -SubscriptionId "<sub-id>"

# Deploy hackathon policies (checks for existing before creating)
.\scripts\hackathon\Setup-GovernancePolicies.ps1 -SubscriptionId "<sub-id>"

# After event: Remove policies
.\scripts\hackathon\Remove-GovernancePolicies.ps1 -SubscriptionId "<sub-id>"
```

**Policies deployed:**

| Policy                  | Effect | Forces                                     |
| ----------------------- | ------ | ------------------------------------------ |
| Allowed locations       | Deny   | Only `swedencentral`, `germanywestcentral` |
| Require Environment tag | Deny   | Must tag all resources                     |
| Require Project tag     | Deny   | Must tag all resources                     |
| SQL Azure AD-only auth  | Deny   | No SQL passwords                           |
| Storage HTTPS only      | Deny   | `supportsHttpsTrafficOnly: true`           |
| Storage min TLS 1.2     | Deny   | `minimumTlsVersion: 'TLS1_2'`              |
| Storage no public blob  | Deny   | `allowBlobPublicAccess: false`             |
| App Service HTTPS       | Deny   | `httpsOnly: true`                          |

> ⚠️ **Note**: Policies take 5-15 minutes to become effective after deployment.

---

## Schedule

📅 **See [AGENDA.md](../AGENDA.md) for the full schedule overview.**

> **Event runs 10:00 - 16:00** (6 hours with 30-min lunch)

---

## Block-by-Block Facilitator Notes

### Block 1: Intro (10:00 - 10:30)

**Facilitator Actions:**

- Welcome teams, introduce coaching approach ("We'll guide, not solve")
- Verify environment setup with each team
- Explain 8-challenge structure and showcase finale

**Setup Check Script:**

```bash
az account show --query "{Subscription:name}" -o table
bicep --version
echo "✅ Ready!"
```

### Block 2: Challenge 1 - Requirements (10:30 - 11:20)

**Duration**: 50 minutes

**Coaching Tips:**

- Ask: "What questions would you ask the customer?"
- Prompt teams to quantify NFRs (SLA, RTO, RPO, peak load)
- Encourage detailed requirement capture — it drives architecture

**Common Issues:**

| Issue                | Solution                    |
| -------------------- | --------------------------- |
| Agent not responding | Reload VS Code window       |
| Vague requirements   | Ask "What SLA? What's RTO?" |

### Block 3: Challenge 2 - Architecture (11:20 - 12:10)

**Duration**: 50 minutes

**Coaching Tips:**

- Ask: "Which Well-Architected pillar does this address?"
- Encourage cost estimation using Azure Pricing MCP
- Prompt: "How would you justify this service choice to the customer?"

**Common Issues:**

No common issues — monitor Pricing MCP functionality.

### 🍽️ Lunch Break (12:10 - 12:40)

**Duration**: 30 minutes

### Block 4: Challenge 3 - Implementation & Deployment (12:40 - 13:50)

**Duration**: 70 minutes (includes Bicep plan + code + deployment + Mermaid diagram)

**Coaching Tips:**

- Ask: "What module structure would make this maintainable?"
- Prompt: "How does your naming convention ensure uniqueness?"
- Encourage Mermaid flowchart for deployment workflow visualization

**Common Issues:**

| Issue                   | Solution               |
| ----------------------- | ---------------------- |
| Key Vault name too long | ≤24 chars              |
| Storage account invalid | Lowercase+numbers only |

### Block 5: ⚡ Challenge 4 - DR Curveball & Deployment (13:50 - 14:30)

**Duration**: 40 minutes

#### 📢 Announcement Script (13:50)

Stand up, get everyone's attention:

> _"ATTENTION ALL TEAMS! 📣_
>
> _We've just received urgent news from Nordic Fresh Foods headquarters!_
>
> _They've signed a major contract with a Danish restaurant chain — Smørrebrød Express — worth
> €500K annually. The board has mandated new business continuity requirements._
>
> _Your infrastructure must now support:_
>
> - _Multi-region disaster recovery_
> - _RTO of 1 hour or less_
> - _RPO of 15 minutes or less_
> - _Secondary region: germanywestcentral_
>
> _Budget has increased by €200/month to accommodate this._
>
> _You have 40 minutes to propose, plan, and DEPLOY the solution!_
>
> _Document your DR strategy in an ADR! GO GO GO!_ 🚀"

**Coaching Tips:**

- Ask: "What replication strategy meets your RPO?"
- Prompt: "How would you test failover?"
- Encourage ADR creation to document DR decision rationale

### Block 6: Challenges 5-7 - Load Test, Docs, Diagnose (14:30 - 15:15)

**Duration**: 45 minutes (3 challenges: 20 min + 20 min + 5 min)

#### Challenge 5: Load Testing (14:30 - 14:50)

**Coaching Tips:**

- Ask: "What metrics validate your SLA?"
- Prompt: "How would you simulate 500 concurrent users?"
- Encourage design agent for structured report generation

#### Challenge 6: Documentation (14:50 - 15:10)

**Coaching Tips:**

- Ask: "What would a new team member need to know?"
- Prompt: "How does design agent ensure completeness?"
- Encourage runbook creation for operational procedures

#### Challenge 7: Diagnostics (15:10 - 15:15)

**Coaching Tips:**

- Ask: "What's your troubleshooting workflow?"
- Prompt: "How would you diagnose a performance issue?"
- Encourage diagnostic runbook with monitoring queries

**Common Issues:**

| Issue                    | Solution                         |
| ------------------------ | -------------------------------- |
| Design agent too verbose | Prompt: "Create concise runbook" |
| Missing monitoring       | Use Application Insights logs    |

---

### 🎯 Presentation Prep (15:15 - 15:25)

**Facilitator Actions:**

- Remind teams of the 4-min pitch + 2-min Q&A format
- Share the [Presentation Template](../challenges/challenge-8-partner-showcase.md#what-to-present)
- Assign team pairings (see below)
- Set up presentation area (projector, timer)

### Block 7: Challenge 8 - Partner Showcase 🎤 (15:25 - 15:55)

**Duration**: 30 minutes (up to 6 teams × 4 min + transitions)

#### Presentation Setup

Pair teams for the role-play:

| Presenting (Partner) | Challenging (Customer) |
| -------------------- | ---------------------- |
| Team 1               | Team 2                 |
| Team 2               | Team 3                 |
| Team 3               | Team 4                 |
| Team 4               | Team 5                 |
| Team 5               | Team 6                 |
| Team 6               | Team 1                 |

#### 📢 Announcement Script (15:25)

> _"Time for Challenge 8 — the Partner Showcase! 🎤_
>
> _Each team will present their FreshConnect solution. You are now the **Partner** pitching to
> Nordic Fresh Foods._
>
> _When you're not presenting, you'll play the **Customer** — asking tough but fair questions!_
>
> _Format: 4 min pitch + 2 min Q&A + 30 sec transition._
>
> _Team 1, you're up first!"_

> **Tip**: Keep presentations moving! Use a visible timer.

#### Facilitator Feedback Focus

After each presentation, briefly comment on:

| Area                | Look For                                         |
| ------------------- | ------------------------------------------------ |
| **Clarity**         | Was the solution easy to understand?             |
| **Justification**   | Were decisions well-reasoned?                    |
| **WAF Alignment**   | Reliability, security, cost, operations covered? |
| **Professionalism** | How would this land with a real customer?        |

### Wrap-up (15:55 - 16:00)

```powershell
# Score all teams
Get-ChildItem .\agent-output -Directory | ForEach-Object {
    .\scripts\hackathon\Score-Team.ps1 -TeamName $_.Name -SkipAzureCheck -ShowcaseScore 0
}

# Display leaderboard
.\scripts\hackathon\Get-Leaderboard.ps1
```

- Share key learnings from presentations
- Announce final leaderboard
- Remind teams to clean up resources

---

## Scoring

### Automated Scoring

```powershell
# Individual team
.\scripts\hackathon\Score-Team.ps1 -TeamName "freshconnect" -ResourceGroupName "rg-freshconnect-dev-swc"

# All teams
Get-ChildItem .\agent-output -Directory | Where-Object { $_.Name -ne ".gitkeep" } | ForEach-Object {
    .\scripts\hackathon\Score-Team.ps1 -TeamName $_.Name -SkipAzureCheck -ShowcaseScore 0
}

# Leaderboard
.\scripts\hackathon\Get-Leaderboard.ps1
```

### Manual Verification (Bonus Points)

| Bonus              | How to Verify                              |
| ------------------ | ------------------------------------------ |
| Zone Redundancy    | Portal → App Service Plan → Zone redundant |
| Private Endpoints  | Portal → SQL/Storage → Networking          |
| Multi-Region       | Resources in `germanywestcentral`          |
| Managed Identities | Portal → App Service → Identity            |

---

## Common Errors

### Authentication

| Error                 | Solution                         |
| --------------------- | -------------------------------- |
| `AADSTS50076`         | Use `az login --use-device-code` |
| `AuthorizationFailed` | Check subscription access        |

### Bicep

| Error    | Solution                      |
| -------- | ----------------------------- |
| `BCP035` | Missing required parameter    |
| `BCP037` | Wrong property or API version |

### Deployment

| Error              | Solution                 |
| ------------------ | ------------------------ |
| `QuotaExceeded`    | Try different region/SKU |
| `NameNotAvailable` | Use uniqueSuffix pattern |
| Zone redundancy    | Use P1v3+ SKU            |

---

## Team Progress Tracker

| Team | C1  | C2  | C3  | C4  | C5  | C6  | C7  | C8  | Deploy | Bonus |
| ---- | --- | --- | --- | --- | --- | --- | --- | --- | ------ | ----- |
| 1    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 2    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 3    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 4    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 5    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 6    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |

Legend: ⬜ Not started | 🔄 In progress | ✅ Complete

> **Note**: C8 (Partner Showcase) is facilitator-scored (0-10) via `-ShowcaseScore`.

---

## Emergency Procedures

### Copilot Down

1. Announce to all teams
2. Use template files in `.github/skills/azure-artifacts/templates/`
3. Extend time if needed

### Azure Issues

1. Check [status.azure.com](https://status.azure.com)
2. Try `germanywestcentral` region
3. Focus on Bicep generation if widespread

### Team Falls Behind

1. Offer direct help
2. Let them skip Challenge 3 design artifacts
3. Remind: learning > completion

---

## Post-Event

Remind teams:

```bash
az group delete --name rg-freshconnect-dev-swc --yes --no-wait
```

Collect feedback on what worked and what didn't.
