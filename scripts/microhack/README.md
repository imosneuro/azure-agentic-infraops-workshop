# Microhack Scripts

> **For facilitators only** — Scripts to manage governance, scoring, and cleanup during the microhack.

## Running Scripts in Dev Container (Linux)

Since the dev container runs on Linux, use `pwsh` to execute PowerShell scripts:

```bash
# From the repository root
pwsh -File scripts/microhack/<script-name>.ps1 [parameters]

# Or navigate to the folder first
cd scripts/microhack
pwsh -File ./<script-name>.ps1 [parameters]
```

---

## Script Reference

### Pre-Event Setup

#### Setup-GovernancePolicies.ps1

Deploys Azure Policies that force teams to handle real compliance constraints.

```bash
# Preview what will be deployed (recommended first)
pwsh -File scripts/microhack/Setup-GovernancePolicies.ps1 \
  -SubscriptionId "<subscription-id>" \
  -WhatIf

# Deploy policies
pwsh -File scripts/microhack/Setup-GovernancePolicies.ps1 \
  -SubscriptionId "<subscription-id>"
```

**Policies deployed:**

| Policy                                                        | Effect |
| ------------------------------------------------------------- | ------ |
| Allowed locations (swedencentral, germanywestcentral, global) | Deny   |
| Require Environment tag                                       | Deny   |
| Require Project tag                                           | Deny   |
| SQL Azure AD-only auth                                        | Deny   |
| Storage HTTPS only                                            | Deny   |
| Storage min TLS 1.2                                           | Deny   |
| Storage no public blob                                        | Deny   |
| App Service HTTPS                                             | Deny   |

---

#### Get-GovernanceStatus.ps1

Check current policy assignments and compliance status.

```bash
# Check all policies
pwsh -File scripts/microhack/Get-GovernanceStatus.ps1 \
  -SubscriptionId "<subscription-id>"

# Check only microhack policies
pwsh -File scripts/microhack/Get-GovernanceStatus.ps1 \
  -SubscriptionId "<subscription-id>" \
  -MicrohackOnly
```

---

### During the Microhack

#### Score-Team.ps1

Score a team's submission based on WAF-aligned criteria (105 base + 25 bonus points).

```bash
# Score without Azure deployment verification
pwsh -File scripts/microhack/Score-Team.ps1 \
  -TeamName "freshconnect" \
  -SkipAzureCheck

# Score with Azure deployment verification
pwsh -File scripts/microhack/Score-Team.ps1 \
  -TeamName "freshconnect" \
  -ResourceGroupName "rg-freshconnect-dev-swc"
```

**Output:** Results saved to `agent-output/<team>/score-results.json`

---

#### Get-Leaderboard.ps1

Display the microhack leaderboard based on team scores.

```bash
# Table format (default)
pwsh -File scripts/microhack/Get-Leaderboard.ps1

# Markdown format
pwsh -File scripts/microhack/Get-Leaderboard.ps1 -OutputFormat Markdown

# JSON format
pwsh -File scripts/microhack/Get-Leaderboard.ps1 -OutputFormat Json
```

---

### Post-Event Cleanup

#### Remove-GovernancePolicies.ps1

Remove microhack policy assignments.

```bash
# Preview what will be removed
pwsh -File scripts/microhack/Remove-GovernancePolicies.ps1 \
  -SubscriptionId "<subscription-id>" \
  -WhatIf

# Remove policies
pwsh -File scripts/microhack/Remove-GovernancePolicies.ps1 \
  -SubscriptionId "<subscription-id>"
```

---

#### Cleanup-MicrohackResources.ps1

Delete resource groups created during the microhack.

```bash
# Preview all matching resource groups
pwsh -File scripts/microhack/Cleanup-MicrohackResources.ps1 -WhatIf

# Clean up a specific team
pwsh -File scripts/microhack/Cleanup-MicrohackResources.ps1 \
  -TeamName "freshconnect"

# Clean up all teams (with confirmation)
pwsh -File scripts/microhack/Cleanup-MicrohackResources.ps1

# Clean up all teams (no prompts)
pwsh -File scripts/microhack/Cleanup-MicrohackResources.ps1 -Force
```

---

## Quick Reference

| Task                | Command                                                                                                                                       |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Get subscription ID | `az account show --query id -o tsv`                                                                                                           |
| Check policies      | `pwsh -File scripts/microhack/Get-GovernanceStatus.ps1 -SubscriptionId "..." -MicrohackOnly`                                                  |
| Score all teams     | `Get-ChildItem ./agent-output -Directory \| ForEach-Object { pwsh -File scripts/microhack/Score-Team.ps1 -TeamName $_.Name -SkipAzureCheck }` |
| Show leaderboard    | `pwsh -File scripts/microhack/Get-Leaderboard.ps1`                                                                                            |

> [!TIP]
> For live events, the **Team Leaderboard web app** provides a browser-based alternative to these scripts. See [`agent-output/team-leaderboard/app/app-prd.md`](../../agent-output/team-leaderboard/app/app-prd.md).

---

## Troubleshooting

| Issue                     | Solution                                                              |
| ------------------------- | --------------------------------------------------------------------- |
| `command not found: pwsh` | PowerShell should be pre-installed in dev container. Try `which pwsh` |
| `az: command not found`   | Azure CLI should be pre-installed. Try `az login`                     |
| Permission denied         | Ensure you have Owner role on the subscription                        |
| Policy not taking effect  | Wait 5-15 minutes after deployment                                    |
