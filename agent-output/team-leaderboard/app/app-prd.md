# Product Requirements Document — Team Leaderboard App

![Type](https://img.shields.io/badge/Type-PRD-blue)
![Status](https://img.shields.io/badge/Status-Ready-brightgreen)
![Audience](https://img.shields.io/badge/Audience-App%20Dev%20Team-green)

> **Audience**: Application development team building the frontend + API for the hackathon leaderboard.
> Infrastructure is already deployed — this document defines _what the app must do_, not how the infra works.

---

## Product Overview

### Purpose

A live, interactive web application where each team submits its own scores and admin reviewers
validate them before leaderboard publication. Replaces manual JSON handling and script-only
scoring with a browser-based submission and review workflow.

### Problem, Users, Value

| Item        | Summary |
| ----------- | ------- |
| **Problem** | Scoring currently depends on manual JSON preparation and facilitator-side script execution, which slows leaderboard updates and creates avoidable data-entry errors. |
| **Users**   | **Team members** submit only their own team scores and uploads. **Admins** review, approve or reject submissions, and can manually override published scores when needed. |
| **Value**   | Reduces scoring turnaround, removes direct JSON file editing from normal operations, and keeps leaderboard updates traceable through an approval workflow. |

### Success Criteria

| Criteria                       | Target                               |
| ------------------------------ | ------------------------------------ |
| All 8 features functional      | F1–F8 as listed below                |
| GitHub authentication enforced | No anonymous access                  |
| Response time                  | < 2 seconds for any page load        |
| Concurrent users               | Up to 50                             |
| Monthly cost                   | < $10/mo (infra already provisioned) |

### Architecture Context

The app runs on **Azure Static Web Apps (Standard)** with **managed Azure Functions** (Node.js) for the API layer and **Azure Table Storage** for persistence. All infrastructure is already deployed. The app team only needs to build the SPA frontend and API functions.

```
┌─────────────────────────────────────────────────┐
│          Azure Static Web Apps (Standard)        │
│                                                   │
│  ┌─────────────┐     ┌──────────────────────┐   │
│  │  SPA         │     │  Managed Functions   │   │
│  │  Frontend    │────▶│  /api/*              │   │
│  └─────────────┘     └──────────┬───────────┘   │
│                                  │               │
│  GitHub OAuth (built-in)         │               │
└──────────────────────────────────┼───────────────┘
                                   │
                         ┌─────────▼──────────┐
                         │  Azure Table        │
                         │  Storage             │
                         │  5 tables            │
                         └────────────────────┘
```

---

## Features

### F1 — Team Score Submission Form

| Attribute       | Detail                                                                                 |
| --------------- | -------------------------------------------------------------------------------------- |
| **Priority**    | Must-Have                                                                              |
| **Role**        | Team member only                                                                       |
| **Description** | Form for team members to submit scores for their own team across all 8 categories + 4 bonus items |

**Acceptance Criteria:**

1. Team is derived from the signed-in user profile (no cross-team selector)
2. Form displays all 8 scored categories with individual criterion fields
3. Each criterion has a numeric input constrained to its max points
4. Bonus items are toggleable checkboxes with point values auto-calculated
5. Partner Showcase (category 8) has a manual 0–10 input
6. Form validates totals before submission (category subtotals ≤ max)
7. On submit, payload is saved as a pending submission via `/api/upload`
8. Success notification confirms the submission requires admin validation

**Scoring Structure:**

| #   | Category                | Points  | Criteria Count         |
| --- | ----------------------- | ------- | ---------------------- |
| 1   | Requirements & Planning | 20      | 5 × 4 pts              |
| 2   | Architecture Design     | 25      | 5 × 5 pts              |
| 3   | Implementation Quality  | 25      | 5 × 5 pts              |
| 4   | Deployment Success      | 10      | 4 criteria (2+4+2+2)   |
| 5   | Load Testing            | 5       | 3 criteria (2+1+2)     |
| 6   | Documentation           | 5       | 3 criteria (2+2+1)     |
| 7   | Diagnostics             | 5       | 3 criteria (2+2+1)     |
| 8   | Partner Showcase        | 10      | 5 criteria (3+2+2+2+1) |
|     | **Base Total**          | **105** |                        |

**Bonus Items (+25 max):**

| Enhancement        | Points | Input Type |
| ------------------ | ------ | ---------- |
| Zone Redundancy    | +5     | Checkbox   |
| Private Endpoints  | +5     | Checkbox   |
| Multi-Region DR    | +10    | Checkbox   |
| Managed Identities | +5     | Checkbox   |

### F2 — Live Leaderboard

| Attribute       | Detail                                        |
| --------------- | --------------------------------------------- |
| **Priority**    | Must-Have                                     |
| **Role**        | Admin + Team member                           |
| **Description** | Real-time ranking of all teams by total score |

**Acceptance Criteria:**

1. Displays a ranked table of all teams sorted by total score (descending)
2. Each row shows: rank, team name, base score (out of 105), bonus score, total, grade
3. Grade badge uses the grading scale (see below)
4. Auto-refreshes every 30 seconds (or via WebSocket/polling)
5. Clicking a team row expands to show category breakdown
6. Responsive layout — works on mobile devices during live events

**Grading Scale:**

| Percentage of 105 | Grade                |
| ----------------- | -------------------- |
| ≥ 90%             | 🏆 OUTSTANDING       |
| ≥ 80%             | 🥇 EXCELLENT         |
| ≥ 70%             | 🥈 GOOD              |
| ≥ 60%             | 🥉 SATISFACTORY      |
| < 60%             | 📚 NEEDS IMPROVEMENT |

### F3 — Grading Display

| Attribute       | Detail                                                                  |
| --------------- | ----------------------------------------------------------------------- |
| **Priority**    | Must-Have                                                               |
| **Role**        | Admin + Team member                                                     |
| **Description** | Each team shows calculated grade based on percentage of 105 base points |

**Acceptance Criteria:**

1. Grade is computed as `(baseScore / 105) × 100` to determine percentage
2. Grade badge color matches tier (gold, silver, bronze, etc.)
3. Displayed on leaderboard and individual team detail view
4. Recalculates immediately when scores are updated

### F4 — Award Categories

| Attribute       | Detail                                   |
| --------------- | ---------------------------------------- |
| **Priority**    | Must-Have                                |
| **Role**        | Admin (assign), Admin + Team member (view) |
| **Description** | Display and assign special award winners |

**Acceptance Criteria:**

1. Five award categories displayed in a dedicated Awards section:
   - 🏆 Best Overall — Highest total score
   - 🛡️ Security Champion — Best security implementation
   - 💰 Cost Optimizer — Best cost efficiency
   - 📐 Best Architecture — Most WAF-aligned design
   - 🚀 Speed Demon — First team to deploy successfully
2. Admins can assign each award to a team via dropdown
3. Awards are persisted to the Awards table via `/api/awards`
4. Award badges displayed on the leaderboard next to winning teams

### F5 — Authentication (GitHub OAuth)

| Attribute       | Detail                                                   |
| --------------- | -------------------------------------------------------- |
| **Priority**    | Must-Have                                                |
| **Role**        | All users                                                |
| **Description** | GitHub authentication is mandatory — no anonymous access |

**Acceptance Criteria:**

1. All routes require authentication (enforced via `staticwebapp.config.json`)
2. Unauthenticated users are redirected to `/.auth/login/github`
3. After login, SWA provides `/.auth/me` with user claims (GitHub username, roles)
4. Role-based UI: admins see validation and management controls; members see own-team submit flows
5. Logout via `/.auth/logout`
6. Roles (`admin`, `member`) assigned via SWA role invitations in Azure Portal

**SWA Auth Flow:**

```
User → SWA → /.auth/login/github → GitHub OAuth → callback → /.auth/me → App
```

### F6 — JSON Score Upload

| Attribute       | Detail                                                                    |
| --------------- | ------------------------------------------------------------------------- |
| **Priority**    | Must-Have                                                                 |
| **Role**        | Team member only                                                          |
| **Description** | Upload `score-results.json` for the signed-in member's own team only     |

**Acceptance Criteria:**

1. Drag-and-drop or file browse to upload a `score-results.json` file
2. App validates the JSON structure matches the expected schema
3. Team name in uploaded JSON must match the member's assigned team
4. Preview table shows parsed scores before submit
5. Confirm/cancel dialog before creating a pending submission
6. Submitted payload is stored with `Pending` status and not yet in leaderboard totals
7. Admin approves/rejects submission; only approved payloads are written to Scores table
8. Error handling for malformed JSON or missing required fields

**Expected JSON Structure (from `Score-Team.ps1`):**

```json
{
  "TeamName": "team-name",
  "Timestamp": "2026-02-13T12:00:00Z",
  "Categories": {
    "Requirements": { "Score": 18, "MaxPoints": 20, "Criteria": { ... } },
    "Architecture": { "Score": 22, "MaxPoints": 25, "Criteria": { ... } },
    ...
  },
  "Bonus": {
    "ZoneRedundancy": { "Points": 5, "Verified": true },
    ...
  },
  "Total": { "Base": 95, "Bonus": 15, "Grand": 110, "MaxBase": 105 },
  "Grade": "OUTSTANDING"
}
```

### F7 — Attendee Registration

| Attribute       | Detail                                                      |
| --------------- | ----------------------------------------------------------- |
| **Priority**    | Must-Have                                                   |
| **Role**        | All authenticated users (own profile); Admins (manage all) |
| **Description** | Authenticated users register their profile linked to a team |

**Acceptance Criteria:**

1. After first login, users are prompted to register (first name, surname, team number)
2. Registration form pre-fills GitHub username from `/.auth/me`
3. Data stored in Attendees table with `gitHubUsername` as PartitionKey
4. Members can update only their own profile
5. Admins can view and manage all attendee records
6. Team number links to the Teams table for team roster display

### F8 — Admin Validation & Manual Override

| Attribute       | Detail                                                                 |
| --------------- | ---------------------------------------------------------------------- |
| **Priority**    | Must-Have                                                              |
| **Role**        | Admin only                                                             |
| **Description** | Admin validates team submissions, can reject with reason, and can override scores manually |

**Acceptance Criteria:**

1. Admin queue shows pending submissions with team, submitter, timestamp, and parsed totals
2. Approve action writes normalized criterion records into Scores table
3. Reject action requires a reason and stores review metadata
4. Admin can manually update approved scores via `/api/scores` override flow
5. Reviewer identity and timestamps are stored for auditability
6. Leaderboard only reflects approved or manually overridden scores

---

## User Roles & Permissions Matrix

| Action                      | Admin | Team member        | Anonymous  |
| --------------------------- | ----- | ------------------ | ---------- |
| View leaderboard            | ✅    | ✅                 | ❌ Blocked |
| View team detail            | ✅    | ✅ (own team only) | ❌         |
| Submit own team scores      | ❌    | ✅                 | ❌         |
| Upload own team JSON        | ❌    | ✅                 | ❌         |
| Validate/reject submissions | ✅    | ❌                 | ❌         |
| Manual score override       | ✅    | ❌                 | ❌         |
| Assign awards               | ✅    | ❌                 | ❌         |
| Manage teams                | ✅    | ❌                 | ❌         |
| Register profile            | ✅    | ✅ (own only)      | ❌         |
| View all attendees          | ✅    | ❌                 | ❌         |

---

## Data Model

### Table Storage Design

All data persists in Azure Table Storage (`stteamleadpromn2ksi`). Shared key access is disabled — the API must use managed identity with the **Storage Table Data Contributor** role.

#### Teams Table

| Field          | Type                | Key | Description                      |
| -------------- | ------------------- | --- | -------------------------------- |
| `PartitionKey` | string              | PK  | Fixed: `"team"`                  |
| `RowKey`       | string              | RK  | Team name (e.g., `"team-alpha"`) |
| `teamName`     | string              |     | Display name                     |
| `teamMembers`  | string (JSON array) |     | Array of GitHub usernames        |
| `createdAt`    | datetime            |     | ISO 8601 timestamp               |

#### Attendees Table

| Field          | Type     | Key | Description                  |
| -------------- | -------- | --- | ---------------------------- |
| `PartitionKey` | string   | PK  | GitHub username              |
| `RowKey`       | string   | RK  | Fixed: `"profile"`           |
| `firstName`    | string   |     | First name                   |
| `surname`      | string   |     | Surname                      |
| `teamNumber`   | int32    |     | Team number (1-based)        |
| `registeredAt` | datetime |     | First registration timestamp |
| `updatedAt`    | datetime |     | Last update timestamp        |

#### Scores Table

| Field          | Type     | Key | Description                                                        |
| -------------- | -------- | --- | ------------------------------------------------------------------ |
| `PartitionKey` | string   | PK  | Team name                                                          |
| `RowKey`       | string   | RK  | `"{category}_{criterion}"` (e.g., `"Requirements_ProjectContext"`) |
| `category`     | string   |     | Category name                                                      |
| `criterion`    | string   |     | Criterion name                                                     |
| `points`       | int32    |     | Awarded points                                                     |
| `maxPoints`    | int32    |     | Maximum possible points                                            |
| `scoredBy`     | string   |     | GitHub username of scorer                                          |
| `timestamp`    | datetime |     | When scored                                                        |

#### Submissions Table

| Field             | Type     | Key | Description                                |
| ----------------- | -------- | --- | ------------------------------------------ |
| `PartitionKey`    | string   | PK  | Team name                                  |
| `RowKey`          | string   | RK  | Submission ID (GUID)                       |
| `submittedBy`     | string   |     | GitHub username of submitter               |
| `submittedAt`     | datetime |     | Submission timestamp                       |
| `status`          | string   |     | `Pending`, `Approved`, or `Rejected`       |
| `reviewedBy`      | string   |     | Admin username who validated               |
| `reviewedAt`      | datetime |     | Review timestamp                           |
| `reviewReason`    | string   |     | Required when rejected                     |
| `payloadJson`     | string   |     | Original JSON payload for audit and replay |
| `calculatedTotal` | int32    |     | Parsed grand total for queue sorting       |

#### Awards Table

| Field          | Type     | Key | Description                            |
| -------------- | -------- | --- | -------------------------------------- |
| `PartitionKey` | string   | PK  | Fixed: `"award"`                       |
| `RowKey`       | string   | RK  | Award category (e.g., `"BestOverall"`) |
| `teamName`     | string   |     | Winning team name                      |
| `assignedBy`   | string   |     | GitHub username of assigner            |
| `timestamp`    | datetime |     | When assigned                          |

---

## API Contract Summary

All endpoints are under `/api/` and require authentication. See [api-spec.md](./api-spec.md) for full request/response schemas.

| Endpoint                    | Methods                | Role                                                | Purpose                              |
| --------------------------- | ---------------------- | --------------------------------------------------- | ------------------------------------ |
| `/api/teams`                | GET, POST, PUT, DELETE | GET: authenticated; POST/PUT/DELETE: admin          | Team CRUD                            |
| `/api/attendees`            | GET, POST, PUT         | GET (all): admin; GET (own)/POST/PUT: authenticated | Attendee registration                |
| `/api/scores`               | GET, POST            | GET: authenticated; POST: admin                     | Approved score retrieval + override  |
| `/api/awards`               | GET, POST, PUT         | GET: authenticated; POST/PUT: admin                 | Award assignment                     |
| `/api/upload`               | POST                   | member                                              | Own-team JSON submission             |
| `/api/submissions`          | GET                    | admin                                               | Pending submission queue             |
| `/api/submissions/validate` | POST                   | admin                                               | Approve/reject submission            |

---

## UI Wireframes (Conceptual)

### Home / Leaderboard View

```
┌─────────────────────────────────────────────────┐
│  🏆 Team Leaderboard          [User] [Logout]   │
├─────────────────────────────────────────────────┤
│                                                   │
│  Rank │ Team         │ Score │ Grade │ Awards    │
│  ─────┼──────────────┼───────┼───────┼────────── │
│   1   │ Team Alpha   │ 95    │ 🏆    │ 🏆 📐    │
│   2   │ Team Beta    │ 88    │ 🥇    │ 🛡️       │
│   3   │ Team Gamma   │ 75    │ 🥈    │          │
│   4   │ Team Delta   │ 62    │ 🥉    │ 🚀       │
│                                                   │
│  [Score Entry] [Upload JSON] [Awards] [Register] │
└─────────────────────────────────────────────────┘
```

### Score Submission Form (Team Member)

```
┌─────────────────────────────────────────────────┐
│  📝 Score Entry                                   │
│                                                   │
│  Team: My Team (auto-resolved)                      │
│                                                   │
│  Requirements (20 pts)                            │
│    Project context:    [__] / 4                    │
│    Functional reqs:    [__] / 4                    │
│    NFRs:               [__] / 4                    │
│    Compliance:         [__] / 4                    │
│    Budget:             [__] / 4                    │
│                        Subtotal: 18/20            │
│                                                   │
│  ... (more categories)                            │
│                                                   │
│  Bonus                                            │
│    [✓] Zone Redundancy      +5                    │
│    [ ] Private Endpoints    +5                    │
│    [ ] Multi-Region DR      +10                   │
│    [✓] Managed Identities   +5                    │
│                                                   │
│  Total: 95/105 + 10 bonus = 105                   │
│  Grade: 🏆 OUTSTANDING (90.5%)                    │
│                                                   │
│  [Submit Scores]                                  │
└─────────────────────────────────────────────────┘
```

---

## Coding Agent Prompt (Adapted for Team Leaderboard)

Use this prompt when implementing the leaderboard UI so the generated app matches both the
target visual style and this project's functional scope.

### Prompt

You are a senior frontend engineer building the Team Leaderboard app for this repository.

Use the supplied reference screenshot as visual direction for layout, hierarchy, spacing,
and card/table composition. Recreate the same modern leaderboard feel, but implement against
the requirements in this PRD (`app-prd.md`) and the API contract in `api-spec.md`.

### Objective

Build a production-ready, responsive SPA that:

- Matches the visual structure of the reference leaderboard view
- Implements functional requirements F1-F8 in this PRD
- Supports role-based UI (`admin`, `member`) with GitHub auth context
- Integrates with `/api/teams`, `/api/scores`, `/api/awards`, `/api/attendees`, `/api/upload`,
  `/api/submissions`, and `/api/submissions/validate`
- Is accessible (WCAG 2.1 AA), reusable, and backend-integration ready

Do not implement pixel-perfect hacks. Use scalable layout primitives.

### Tech Stack

- React (latest stable)
- TypeScript
- Tailwind CSS (dark mode via `class` strategy)
- Headless UI only when needed (tabs/dropdowns/dialog)
- Lucide or Heroicons for icons
- Context API for theme and auth/session state
- No external UI component frameworks

### UI Scope and Mapping to PRD

Implement the following surfaces first:

1. Top navigation with search, filter tabs, notifications, theme toggle, user menu
2. Champions spotlight (top 3 teams) powered by leaderboard totals
3. Metric highlight cards (tips/activity/streak/rank deltas)
4. Main leaderboard table with expandable row details

Then add the required workflow surfaces from PRD features:

- F1 Team score submission form (member only)
- F4 Awards management section (admin assign, all view)
- F6 JSON score upload with own-team enforcement and preview
- F7 Attendee registration/profile view
- F8 Admin validation queue and manual score override

### Data and Behavior Requirements

- Drive leaderboard ranking from API totals (`baseScore`, `bonusScore`, `totalScore`, `grade`)
- Compute and render grade badges exactly per PRD grading thresholds
- Refresh leaderboard data every 30 seconds (or equivalent polling strategy)
- Enforce role-based rendering:
  - `member`: submit own team, upload own JSON, leaderboard, own profile
  - `admin`: validate submissions, override scores, assign awards, manage teams
- Handle loading, empty, and error states for every data surface
- Add optimistic UI only where rollback behavior is explicit

### Theming

- Light mode default: neutral background, white cards, subtle elevation
- Dark mode: slate surfaces, soft borders, equivalent contrast
- Theme toggle in navbar
- Persist theme preference to localStorage
- Ensure contrast meets WCAG AA

### Responsive and Accessibility

- Breakpoints: `sm`, `md`, `lg`, `xl`
- Mobile behavior:
  - navbar collapses cleanly
  - leaderboard table supports horizontal scroll
  - row-card fallback for dense data on small screens
- Keyboard operable controls, visible focus states, semantic landmarks
- ARIA labels for icon-only actions and alt text for avatars

### Suggested Frontend Structure

```text
/components
  Navbar.tsx
  ThemeToggle.tsx
  ChampionCard.tsx
  StatCard.tsx
  LeaderboardTable.tsx
  ScoreEntryForm.tsx
  AwardsPanel.tsx
  JsonUploadPanel.tsx
  AttendeeProfileForm.tsx

/context
  ThemeContext.tsx
  AuthContext.tsx

/services
  apiClient.ts
  leaderboardService.ts

/pages
  Dashboard.tsx

/data
  leaderboard.mock.ts
```

### Performance and Code Quality

- Prevent unnecessary re-renders with memoization where beneficial
- Keep components presentational when possible; isolate data-fetch logic
- Use strict TypeScript types for API payloads
- Prefer composable utilities over repeated formatting logic

### Deliverables

1. Responsive leaderboard page matching reference visual hierarchy
2. Theme system (light/dark) with persisted preference
3. Feature-complete UI for F1, F2, F3, F4, F6, F7, F8
4. API integration scaffolding aligned to `api-spec.md`
5. Local mock data mode for offline UI development
6. Run instructions for local development and test verification

### Constraints

- Do not change the scoring model or grading scale from this PRD
- Do not hardcode production credentials, endpoints, or identities
- Do not introduce external component frameworks

---

## Non-Functional Requirements

| Requirement      | Target                    | Notes                              |
| ---------------- | ------------------------- | ---------------------------------- |
| Availability     | 99.9%                     | SWA Standard SLA is 99.95%         |
| Response time    | < 2s                      | CDN for static assets; API < 500ms |
| Concurrent users | 50                        | Small hackathon audience           |
| Data retention   | Event + 30 days           | Delete resources after             |
| Accessibility    | WCAG 2.1 AA               | Standard web accessibility         |
| Browser support  | Modern evergreen browsers | Chrome, Edge, Firefox, Safari      |

---

## Out of Scope

- Custom domain configuration (handled by platform team)
- Infrastructure provisioning (already deployed)
- CI/CD pipeline setup (covered in [app-handoff-checklist.md](./app-handoff-checklist.md))
- Load testing
- Multi-language / i18n support

---

## References

- [Scoring Rubric Source](../../../hackathon/facilitator/scoring-rubric.md) — Definitive scoring criteria
- [01-requirements.md](../01-requirements.md) — Infrastructure requirements (source material)
- [02-architecture-assessment.md](../02-architecture-assessment.md) — Architecture decisions
- [06-deployment-summary.md](../06-deployment-summary.md) — Deployed resource details
- [api-spec.md](./api-spec.md) — Full API specification
- [staticwebapp.config.json](./staticwebapp.config.json) — Auth and route configuration
- [app-handoff-checklist.md](./app-handoff-checklist.md) — Infrastructure wiring instructions
- [SWA Authentication Docs](https://learn.microsoft.com/azure/static-web-apps/authentication-authorization)
- [Azure Table Storage API](https://learn.microsoft.com/rest/api/storageservices/table-service-rest-api)
