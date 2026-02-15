# HackerBoard App

![Type](https://img.shields.io/badge/Type-Application-blue)
![Status](https://img.shields.io/badge/Status-Planning-yellow)
![Platform](https://img.shields.io/badge/Platform-Azure%20SWA-purple)
![Runtime](https://img.shields.io/badge/Runtime-Node.js%2020-green)

> Browser-based scoring, validation, and leaderboard for microhack events.
> Replaces manual JSON handling and script-only scoring with a live web UI.

---

## What This App Does

Teams submit their own scores through a web form or JSON upload. Admins
(facilitators) review and approve submissions before they appear on the
public leaderboard. The app also handles attendee registration, random
team assignment, and award presentation — all behind GitHub OAuth.

## Architecture

```
Azure Static Web Apps (Standard)
├── SPA Frontend (React + TypeScript + Tailwind)
├── Managed Azure Functions (/api/*)
│   └── Node.js 20 LTS
├── GitHub OAuth (built-in SWA auth)
└── Azure Table Storage (6 tables)
    ├── Rubrics
    ├── Teams
    ├── Attendees
    ├── Scores
    ├── Submissions
    └── Awards
```

Infrastructure is **already deployed**. This folder contains the design
documents and specifications — the app team builds the SPA and API
functions against these specs.

## Features (F1–F11)

| #    | Feature                          | Role            |
| ---- | -------------------------------- | --------------- |
| F1   | Team Score Submission Form       | Member          |
| F2   | Live Leaderboard                 | All             |
| F3   | Grading Display                  | All             |
| F4   | Award Categories                 | Admin + All     |
| F5   | GitHub OAuth Authentication      | All             |
| F6   | JSON Score Upload                | Member          |
| F7   | Attendee Registration            | All             |
| F8   | Admin Validation & Override      | Admin           |
| F9   | Attendee Bulk Entry              | Admin           |
| F10  | Random Team Assignment           | Admin           |
| F11  | Configurable Rubric Templates    | Admin           |

## User Roles

| Role       | SWA Role       | Capabilities                                      |
| ---------- | -------------- | ------------------------------------------------- |
| **Admin**  | `admin`        | Review submissions, override scores, assign awards, manage teams and attendees |
| **Member** | `member`       | Submit own-team scores, upload JSON, view leaderboard, register profile |
| Anonymous  | (blocked)      | Redirected to GitHub login                        |

## Documents in This Folder

| File                                                   | Purpose                              |
| ------------------------------------------------------ | ------------------------------------ |
| [app-prd.md](./app-prd.md)                             | Product requirements (F1–11)        |
| [api-spec.md](./api-spec.md)                           | Full API specification (14 endpoints)|
| [app-design.md](./app-design.md)                       | UI/UX design and component model     |
| [app-scaffold.md](./app-scaffold.md)                   | Recommended folder structure         |
| [app-handoff-checklist.md](./app-handoff-checklist.md) | Infrastructure wiring steps          |
| [staticwebapp.config.json](./staticwebapp.config.json) | Auth, routes, and security headers   |
| [backlog.md](./backlog.md)                           | Project plan and task tracker         |

## Quick Start (Local Development)

> Prerequisites: Node.js 20 LTS, [SWA CLI](https://github.com/Azure/static-web-apps-cli),
> [Azurite](https://learn.microsoft.com/azure/storage/common/storage-use-azurite) for
> local Table Storage emulation.

```bash
# 1. Clone the app repo (separate from this infra repo)
git clone <your-app-repo-url>
cd hacker-board-app

# 2. Install dependencies
npm install
cd api && npm install && cd ..

# 3. Start Azurite for local Table Storage
azurite --silent --location .azurite &

# 4. Start SWA dev server
swa start src --api-location api

# 5. Open http://localhost:4280
```

For mock data mode (no Azure connection needed), set `USE_MOCK_DATA=true`
in your environment before starting.

## API Endpoints

| Endpoint                    | Methods              | Auth          |
| --------------------------- | -------------------- | ------------- |
| `/api/teams`                | GET, POST, PUT, DEL  | admin (write) |
| `/api/teams/assign`         | POST                 | admin         |
| `/api/scores`               | GET, POST            | admin (write) |
| `/api/attendees`            | GET                  | admin         |
| `/api/attendees/me`         | GET, POST            | authenticated |
| `/api/attendees/bulk`       | POST                 | admin         |
| `/api/awards`               | GET, POST, PUT       | admin (write) |
| `/api/upload`               | POST                 | member        |
| `/api/submissions`          | GET                  | admin         |
| `/api/submissions/validate` | POST                 | admin         |
| `/api/rubrics`              | GET, POST            | admin (write) |
| `/api/rubrics/active`       | GET                  | authenticated |

Full request/response schemas in [api-spec.md](./api-spec.md).

## Scoring Model

> The scoring model is configurable via rubric templates (F11). The values
> below are the **default rubric** that ships with the app. Admins can upload
> a custom `rubric.md` to define different categories, criteria, and grading
> scales for each microhack event.

| Category                | Points | Grade Scale (of 105 base) |
| ----------------------- | ------ | ------------------------- |
| Requirements & Planning | 20     | ≥ 90% → OUTSTANDING      |
| Architecture Design     | 25     | ≥ 80% → EXCELLENT        |
| Implementation Quality  | 25     | ≥ 70% → GOOD             |
| Deployment Success      | 10     | ≥ 60% → SATISFACTORY     |
| Load Testing            | 5      | < 60% → NEEDS IMPROVEMENT|
| Documentation           | 5      |                           |
| Diagnostics             | 5      |                           |
| Partner Showcase        | 10     |                           |
| **Base Total**          | **105**|                           |
| Bonus (4 items)         | +25 max|                           |

Definitive scoring criteria: [Scoring Rubric](../../../microhack/facilitator/scoring-rubric.md)

## Current Status

The app is in the **planning phase**. See [backlog.md](./backlog.md) for the
full backlog, milestones, and TDD implementation plan.

## Related Resources

- [Infrastructure README](../README.md)
- [Infrastructure Requirements](../01-requirements.md)
- [Architecture Assessment](../02-architecture-assessment.md)
- [Deployment Summary](../06-deployment-summary.md)
- [Scoring Rubric](../../../microhack/facilitator/scoring-rubric.md)
