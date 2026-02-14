# Know Before You Go

> [Current Version](../VERSION.md) | Everything you need to know before joining the microhack or exploring the repo

## Who This Is For

- **Microhack participants**: Complete the setup checklist and read the "What to Expect"
  section before event day.
- **Self-guided learners**: Follow the same setup steps to explore the agentic workflow
  at your own pace.

## What to Expect

### The Microhack in 60 Seconds

Your team will build real Azure infrastructure — from business requirements through
deployed resources — using AI agents instead of manual coding. You'll use GitHub Copilot
custom agents that understand Azure best practices, the Well-Architected Framework, and
Bicep Infrastructure as Code.

**The flow**: Requirements → Architecture → Bicep Code → Deploy → Documentation

**The twist**: Midway through, facilitators announce a curveball requirement
(multi-region disaster recovery) that forces you to adapt your architecture.

### What You'll Actually Do

| Block | You Will... |
|-------|-------------|
| Intro (30 min) | Meet your team, verify setup, learn the workflow |
| Challenges 1-2 (100 min) | Capture requirements and design architecture with AI agents |
| Challenge 3 (70 min) | Generate and deploy Bicep templates |
| Challenge 4 (40 min) | Adapt to new DR requirements (the curveball!) |
| Challenges 5-7 (45 min) | Load test, document, and diagnose |
| Challenge 8 (30 min) | Present your solution to the group |

> [!TIP]
> See the full schedule in [AGENDA.md](../microhack/AGENDA.md).

### Mindset Tips

1. **Let the agents drive** — Resist the urge to write Bicep manually. The agents
   understand Azure Verified Modules, WAF alignment, and naming conventions.
2. **Be specific in your prompts** — "Create a hub-spoke network in swedencentral
   with Application Gateway" beats "Create some infrastructure."
3. **Iterate, don't restart** — If agent output isn't right, refine in the same
   conversation rather than starting over.
4. **Read the artifacts** — Agents save their work to `agent-output/{project}/`.
   Review what was generated before moving to the next challenge.
5. **Rotate roles** — Each team member should drive at least one challenge to
   experience different agents firsthand.

---

## Required Software

### 1. Docker Desktop

GitHub Copilot custom agents run inside a Dev Container. You need Docker.

**Install:**

- **Windows/Mac**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/)

**Verify:**

```bash
docker --version
# Expected: Docker version 24.x or newer
```

**Alternatives** (if Docker Desktop licensing is an issue):

- [Rancher Desktop](https://rancherdesktop.io/)
- [Podman Desktop](https://podman-desktop.io/)
- [Colima](https://github.com/abiosoft/colima) (macOS/Linux)

---

### 2. Visual Studio Code

**Install:** [VS Code](https://code.visualstudio.com/) (version 1.100+)

**Required Extensions:**

| Extension | ID | Purpose |
|---|---|---|
| Dev Containers | `ms-vscode-remote.remote-containers` | Run Dev Container |
| GitHub Copilot | `github.copilot` | AI assistance |
| GitHub Copilot Chat | `github.copilot-chat` | Agent interactions |
| Bicep | `ms-azuretools.vscode-bicep` | Bicep language support |
| Azure Account | `ms-vscode.azure-account` | Azure authentication |

**Install all at once:**

```bash
code --install-extension ms-vscode-remote.remote-containers
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension ms-azuretools.vscode-bicep
code --install-extension ms-vscode.azure-account
```

---

### 3. Git

**Install:**

- **Windows**: [Git for Windows](https://gitforwindows.org/)
- **Mac**: `brew install git` or Xcode Command Line Tools
- **Linux**: `sudo apt install git` or equivalent

**Verify:**

```bash
git --version
# Expected: git version 2.40 or newer
```

---

## Required Accounts

### 1. GitHub Account with Copilot Pro+ or Enterprise

> [!WARNING]
> This microhack requires **GitHub Copilot Pro+** or **GitHub Copilot Enterprise**.
> Custom agents are **NOT available** on Copilot Free, Copilot Pro, or Copilot Business.

**Plan compatibility:**

| Plan | Custom Agents | Microhack Compatible |
|---|---|---|
| Copilot Free | No | No |
| Copilot Pro | No | No |
| Copilot Business | No | No |
| **Copilot Pro+** | **Yes** | **Yes** |
| **Copilot Enterprise** | **Yes** | **Yes** |

Compare plans: [GitHub Copilot Plans](https://github.com/features/copilot/plans)

**Using Azure billing for Copilot**: If your organization uses Azure, you can pay
for GitHub Copilot through your Azure subscription.
See [Connect Azure subscription to GitHub billing][azure-billing].

**Verify your plan:**

1. Go to [github.com/settings/copilot](https://github.com/settings/copilot)
2. Confirm your subscription shows **Pro+** or **Enterprise**
3. Ensure "Copilot Chat in the IDE" is enabled

Setup guide: [VS Code Copilot Setup](https://code.visualstudio.com/docs/copilot/setup)

---

### 2. Azure Subscription

> [!WARNING]
> This is a **Bring-Your-Own-Subscription** event. No Azure subscriptions
> will be provided.

**Compatible subscription types:**

| Subscription Type | Compatible |
|---|---|
| Azure in CSP | Yes |
| Enterprise Agreement (EA) | Yes |
| Pay As You Go | Yes |
| Visual Studio subscription | Yes |
| Azure Free Account (with Credit Card) | Yes |
| **Azure Pass** | **No** |

FAQ: [Azure account options](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account)

**Requirements:**

- **Owner** access on the subscription (required for Azure Policy in governance
  challenges)
- Sufficient quota for microhack resources — see
  [Quota Requirements](quota-requirements.md)
- A subscription can be shared across teams if quota permits

> [!TIP]
> A single subscription can support multiple teams as long as the combined
> resource requirements stay within
> [Azure subscription limits][azure-limits].

**Verify:**

```bash
az login
az account list --output table
```

You should see at least one subscription where you have Owner access.

---

## Pre-Event Setup (30-45 Minutes)

Complete these steps **before** the microhack to avoid network congestion on the day.

### Clone the Repository

```bash
git clone https://github.com/jonathan-vella/azure-agentic-infraops-workshop.git
cd azure-agentic-infraops-workshop
code .
```

### Build the Dev Container

Building takes 3-5 minutes. Do this ahead of time:

1. Open the cloned repo in VS Code
2. Press `F1` → type "Dev Containers: Reopen in Container"
3. Wait for the container to build (watch the progress in the terminal)
4. Once complete, verify tools are installed:

```bash
az version        # Expected: 2.50+
bicep --version   # Expected: 0.20+
pwsh --version    # Expected: 7+
```

### Authenticate with Azure

While in the Dev Container:

```bash
az login
az account set --subscription "<your-subscription-id>"
az account show --query "{Name:name, SubscriptionId:id, TenantId:tenantId}" -o table
```

### Enable Custom Agents

Open VS Code Settings (`Ctrl+,`) and add:

```json
{
  "github.copilot.chat": {
    "customAgentInSubagent": {
      "enabled": true
    }
  }
}
```

### Network Requirements

Ensure your network allows connections to:

| Service | Domains | Ports |
|---|---|---|
| GitHub | `github.com`, `api.github.com` | 443 |
| GitHub Copilot | `copilot.github.com`, `*.githubusercontent.com` | 443 |
| Azure | `*.azure.com`, `*.microsoft.com`, `login.microsoftonline.com` | 443 |
| Docker | `docker.io`, `registry-1.docker.io` | 443 |

---

## Checklist Summary

Print this or keep it open on event day:

- [ ] **Docker Desktop** installed and running
- [ ] **VS Code** 1.100+ with required extensions
- [ ] **Git** installed (2.40+)
- [ ] **GitHub account** with Copilot Pro+ or Enterprise
- [ ] **Azure subscription** with Owner access
- [ ] **Repository cloned** locally
- [ ] **Dev Container built** (F1 → Reopen in Container)
- [ ] **Azure CLI authenticated** (`az login` successful)
- [ ] **Custom agents enabled** (VS Code setting)
- [ ] **Network access** verified (no proxy issues)

---

## First 10 Minutes on Event Day

When you arrive:

1. Open VS Code → Reopen in Container (if not already running)
2. Verify Azure auth: `az account show`
3. Open Copilot Chat (`Ctrl+Alt+I`) → confirm agents appear in the dropdown
4. Read the [Scenario Brief](scenario-brief.md) to understand the business challenge
5. Assign team roles using [Team Role Cards](team-role-cards.md)

---

## Troubleshooting Quick Fixes

| Problem | Fix |
|---------|-----|
| Docker won't start | **Windows**: ensure WSL 2 is enabled. **Mac**: check virtualization. Restart Docker. |
| Copilot not working | Sign out and back in with the correct GitHub account. Reload VS Code. |
| Azure CLI login fails | Use device code flow: `az login --use-device-code` |
| Dev Container build fails | `F1` → "Dev Containers: Rebuild Container Without Cache". Check Docker has 4 GB+ RAM. |
| Agents not in dropdown | Verify `customAgentInSubagent` is enabled. Reload VS Code window. |

For more detailed fixes, see [Troubleshooting](troubleshooting.md).

---

## References

- [Scenario Brief](scenario-brief.md) — The Nordic Fresh Foods business challenge
- [Copilot Guide](copilot-guide.md) — VS Code, agents, skills, and instructions
- [Quick Reference Card](quick-reference-card.md) — Printable one-page cheat sheet
- [Quota Requirements](quota-requirements.md) — Azure resource quota per team
- [Microhack AGENDA](../microhack/AGENDA.md) — Full schedule with block timing

[azure-billing]: https://docs.github.com/en/billing/how-tos/set-up-payment/connect-azure-sub
[azure-limits]: https://learn.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits
