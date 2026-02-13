![Type](https://img.shields.io/badge/Type-App%20Design-blue)
![Status](https://img.shields.io/badge/Status-Ready-brightgreen)
![Audience](https://img.shields.io/badge/Audience-App%20Dev%20Team-green)

> Purpose: Define the UI and interaction design for the Team Leaderboard app implementation.
> Scope: App UX and frontend architecture only; infrastructure design is out of scope.

## Problem, Users, Value

| Item        | Summary |
| ----------- | ------- |
| **Problem** | Manual JSON prep and script-based scoring create slower leaderboard updates and more operational friction during live sessions. |
| **Users**   | **Team members** submit scores for their own team. **Admins** review submissions, approve or reject them, and apply manual score overrides when needed. |
| **Value**   | The UX prioritizes fast submission, clear review state, and role-safe controls so scoring remains auditable and easier to run during the event. |

---

## Design Goals

- Match the leaderboard visual hierarchy shown in the reference screenshot.
- Preserve PRD functional scope (F1–F8).
- Keep UI implementation responsive, accessible, and API-driven.
- Support admin and member experiences without duplicated screens.

## Experience Principles

- Prioritize live ranking clarity over decorative visuals.
- Keep score-entry workflows fast for facilitators during live sessions.
- Keep member views lightweight and easy to scan from mobile devices.
- Use consistent spacing, typography, and status treatments across cards and tables.

## Screen Structure

### Dashboard (Primary Screen)

- Top navigation: search, All / By Category / By Challenge tabs, notification area, theme toggle, user menu.
- Champions spotlight: top 3 ranked teams with prominent score badges and key stats.
- Highlights row: compact metric cards (activity, streak, rank movement indicators).
- Leaderboard body: sortable and expandable ranking table with team-level detail drilldown.

### Team Member Workflows

- Score submission panel for category and criterion scoring with validation.
- JSON upload panel for own-team import with schema validation and preview.
- Submission status panel showing pending/approved/rejected state.

### Admin Workflows

- Submission review queue with approve/reject actions.
- Manual score override panel.
- Awards panel for assigning category awards.

### Shared Workflows

- Team score detail expansion in leaderboard.
- Attendee profile registration and update for authenticated users.

## Component Model

- `Navbar`: global controls, search, auth actions, theme toggle.
- `ChampionCard`: top-team summary with role, verification, and score badge.
- `StatCard`: compact metric indicators for dashboard highlights.
- `LeaderboardTable`: ranked rows, expansion, responsive fallback on small screens.
- `ScoreSubmissionForm`: member-only scoring editor with category subtotal checks.
- `SubmissionStatusPanel`: member view of latest submission state.
- `AdminReviewQueue`: admin-only pending submission triage.
- `ManualScoreOverride`: admin-only score correction workflow.
- `AwardsPanel`: admin-only award assignment controls.
- `JsonUploadPanel`: member-only structured upload with pre-submit validation.
- `AttendeeProfileForm`: self-service attendee registration/editing.

## Responsive Strategy

- `xl`/`lg`: full table layout, 3-column champions, horizontal metric strip.
- `md`: champions use 2-column wrap, table remains scrollable.
- `sm`: champions and metrics stack vertically, leaderboard uses card-style fallback.
- Maintain touch target size for all interactive controls in mobile layouts.

## Theme Strategy

- Light mode default with neutral page background and white card surfaces.
- Dark mode with slate surfaces, lighter borders, reduced shadow depth.
- Toggle in navbar, persisted via localStorage.
- Ensure text, badges, and data states maintain WCAG 2.1 AA contrast.

## Accessibility Requirements

- Semantic landmarks (`header`, `main`, `section`, `table`, `form`) on all primary views.
- Keyboard access for tabs, row expansion, dialogs, and action buttons.
- Visible focus styles across both themes.
- ARIA labels for icon-only controls and descriptive alt text for avatars.

## Data Integration Expectations

- Leaderboard data sourced from `/api/scores` summary payload.
- Team metadata from `/api/teams`; awards from `/api/awards`.
- Attendee profile from `/api/attendees`; upload via `/api/upload`.
- Admin queue from `/api/submissions`; validation via `/api/submissions/validate`.
- Polling every 30 seconds for leaderboard freshness unless real-time transport is added.

## Animation Guidance

- Use subtle motion only: card hover elevation, light fade-in, smooth theme transition.
- Avoid heavy animation libraries and long-duration effects.

## Out of Scope

- Backend schema redesign or endpoint contract changes.
- New role definitions beyond `admin` and `member`.
- Visual rebranding outside this app and current workshop context.

## References

- [Product Requirements](./app-prd.md)
- [API Specification](./api-spec.md)
- [Handoff Checklist](./app-handoff-checklist.md)
- [Scaffold Guide](./app-scaffold.md)
- [Infrastructure README](../README.md)
