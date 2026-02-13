<!-- markdownlint-disable MD033 MD041 -->

<a id="readme-top"></a>

<div align="center">

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow?style=for-the-badge)
![Step](https://img.shields.io/badge/Step-6%20of%207-blue?style=for-the-badge)
![Cost](https://img.shields.io/badge/Est.%20Cost-$9.05%2Fmo-purple?style=for-the-badge)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjonathan-vella%2Fazure-agentic-infraops-workshop%2Fmain%2Finfra%2Fbicep%2Fteam-leaderboard%2Fazuredeploy.json)

# 🏗️ team-leaderboard

**Serverless hackathon scoring dashboard using Azure Static Web Apps with managed Functions and Azure Table Storage.**

[View Architecture](#-architecture) · [View Artifacts](#-generated-artifacts) · [View Progress](#-workflow-progress)

</div>

---

## 📋 Project Summary

| Property           | Value                      |
| ------------------ | -------------------------- |
| **Created**        | 2026-02-12                 |
| **Last Updated**   | 2026-02-13 (Step 6)        |
| **Region**         | westeurope (all resources) |
| **Environment**    | prod                       |
| **Estimated Cost** | ~$9.05/month               |
| **AVM Coverage**   | 100% (4/4 resources)       |

---

## ✅ Workflow Progress

```
[██████████████░░░] 86% Complete
```

| Step | Phase        |                                    Status                                     | Artifact                                                            |
| :--: | ------------ | :---------------------------------------------------------------------------: | ------------------------------------------------------------------- |
|  1   | Requirements |     ![Done](https://img.shields.io/badge/-Done-success?style=flat-square)     | [01-requirements.md](./01-requirements.md)                          |
|  2   | Architecture |     ![Done](https://img.shields.io/badge/-Done-success?style=flat-square)     | [02-architecture-assessment.md](./02-architecture-assessment.md)    |
|  3   | Design       |     ![Done](https://img.shields.io/badge/-Done-success?style=flat-square)     | [03-des-cost-estimate.md](./03-des-cost-estimate.md), [diagrams](.) |
|  4   | Bicep Plan   |     ![Done](https://img.shields.io/badge/-Done-success?style=flat-square)     | [04-implementation-plan.md](./04-implementation-plan.md)            |
|  5   | Bicep Code   |     ![Done](https://img.shields.io/badge/-Done-success?style=flat-square)     | [05-implementation-reference.md](./05-implementation-reference.md)  |
|  6   | Deploy       |     ![Done](https://img.shields.io/badge/-Done-success?style=flat-square)     | [06-deployment-summary.md](./06-deployment-summary.md)              |
|  7   | As-Built     | ![Pending](https://img.shields.io/badge/-Pending-lightgrey?style=flat-square) | —                                                                   |

---

## 🏛️ Architecture

![Architecture Diagram](./03-des-diagram.png)

### Key Resources

| Resource             | Type                                       | SKU          | Region     |
| -------------------- | ------------------------------------------ | ------------ | ---------- |
| Static Web App       | `Microsoft.Web/staticSites`                | Standard     | westeurope |
| Storage Account      | `Microsoft.Storage/storageAccounts`        | Standard_LRS | westeurope |
| Application Insights | `Microsoft.Insights/components`            | —            | westeurope |
| Log Analytics        | `Microsoft.OperationalInsights/workspaces` | PerGB2018    | westeurope |

### Key Design Decisions

- **Mandatory GitHub OAuth** — No anonymous access, writer/reader roles
- **Single region** — All resources in `westeurope` to eliminate latency
- **4 storage tables** — Teams, Attendees, Scores, Awards
- **9 required tags** — Azure Policy Deny enforces on resource group
- **Shared key disabled** — MCAPSGov Modify policy; use managed identity

---

## 📄 Generated Artifacts

### Step 1 — Requirements

- [01-requirements.md](./01-requirements.md)

### Step 2 — Architecture

- [02-architecture-assessment.md](./02-architecture-assessment.md)

### Step 3 — Design

- [03-des-cost-estimate.md](./03-des-cost-estimate.md)
- [03-des-diagram.py](./03-des-diagram.py) / [.png](./03-des-diagram.png)
- [03-des-user-flow.py](./03-des-user-flow.py) / [.png](./03-des-user-flow.png)
- [03-des-user-flow-simple.py](./03-des-user-flow-simple.py) / [.png](./03-des-user-flow-simple.png)

### Step 4 — Implementation Planning

- [04-governance-constraints.md](./04-governance-constraints.md) / [.json](./04-governance-constraints.json)
- [04-implementation-plan.md](./04-implementation-plan.md)
- [04-preflight-check.md](./04-preflight-check.md)
- [04-dependency-diagram.py](./04-dependency-diagram.py) / [.png](./04-dependency-diagram.png)
- [04-runtime-diagram.py](./04-runtime-diagram.py) / [.png](./04-runtime-diagram.png)

### Step 5 — Bicep Code

- [05-implementation-reference.md](./05-implementation-reference.md)
- [`infra/bicep/team-leaderboard/`](../../infra/bicep/team-leaderboard/) — Bicep templates
  - `main.bicep` — Orchestration with phased deployment
  - `main.bicepparam` — Parameter file (prod defaults)
  - `deploy.ps1` — PowerShell deployment script
  - `modules/log-analytics.bicep` — AVM 0.15.0
  - `modules/storage.bicep` — AVM 0.31.0
  - `modules/app-insights.bicep` — AVM 0.7.1
  - `modules/static-web-app.bicep` — AVM 0.9.3

### Step 6 — Deploy

- [06-deployment-summary.md](./06-deployment-summary.md)
- Deployment: `team-leaderboard-20260213171523` — **Succeeded** (57s)
- Resource Group: `rg-team-leaderboard-prod` (westeurope)
- SWA URL: `https://purple-bush-029df9903.4.azurestaticapps.net`

### App Handoff Artifacts

- [app/app-prd.md](./app/app-prd.md) — Product Requirements Document (features, data model, roles)
- [app/app-design.md](./app/app-design.md) — Dedicated UI/UX design specification for the app
- [app/app-handoff-checklist.md](./app/app-handoff-checklist.md) — Step-by-step wiring guide for the app repo
- [app/api-spec.md](./app/api-spec.md) — Full API specification (endpoints, schemas, errors)
- [app/app-scaffold.md](./app/app-scaffold.md) — Recommended folder structure and starter code
- [app/staticwebapp.config.json](./app/staticwebapp.config.json) — Auth, routes, and security headers
- [`azuredeploy.json`](../../infra/bicep/team-leaderboard/azuredeploy.json) — ARM template for Deploy to Azure button

---

## 🚀 Quick Start

```powershell
cd infra/bicep/team-leaderboard
./deploy.ps1 -CostCenter "hackathon" -TechnicalContact "team@contoso.com"
```

See [05-implementation-reference.md](./05-implementation-reference.md) for full deployment options.

---

## 🔗 Related Resources

- [Azure Static Web Apps Documentation](https://learn.microsoft.com/azure/static-web-apps/)
- [Azure Verified Modules Index](https://aka.ms/avm/index)
- [SWA Authentication & Authorization](https://learn.microsoft.com/azure/static-web-apps/authentication-authorization)
- [Azure Table Storage](https://learn.microsoft.com/azure/storage/tables/table-storage-overview)

---

<p align="right">(<a href="#readme-top">back to top</a>)</p>
