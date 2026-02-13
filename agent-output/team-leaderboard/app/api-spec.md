# API Specification — Team Leaderboard

![Type](https://img.shields.io/badge/Type-API%20Spec-blue)
![Runtime](https://img.shields.io/badge/Runtime-Node.js%2020-green)
![Auth](https://img.shields.io/badge/Auth-GitHub%20OAuth-orange)

> All endpoints are managed Azure Functions behind the SWA reverse proxy.
> Base URL: `https://purple-bush-029df9903.4.azurestaticapps.net/api`

---

## Authentication Context

Every API request includes the SWA authentication context automatically. Access the caller's identity in Node.js:

```javascript
function getClientPrincipal(req) {
  const header = req.headers["x-ms-client-principal"];
  if (!header) return null;
  const encoded = Buffer.from(header, "base64");
  return JSON.parse(encoded.toString("ascii"));
}

// Returns:
// {
//   "identityProvider": "github",
//   "userId": "<unique-id>",
//   "userDetails": "<github-username>",
//   "userRoles": ["authenticated", "writer"]
// }
```

---

## Endpoints

### `GET /api/teams`

Retrieve all teams.

| Property   | Value                             |
| ---------- | --------------------------------- |
| **Auth**   | `authenticated` (reader + writer) |
| **Method** | GET                               |

**Response `200 OK`:**

```json
[
  {
    "teamName": "team-alpha",
    "teamMembers": ["user1", "user2", "user3"],
    "createdAt": "2026-02-13T10:00:00Z"
  }
]
```

---

### `POST /api/teams`

Create a new team.

| Property   | Value         |
| ---------- | ------------- |
| **Auth**   | `writer` only |
| **Method** | POST          |

**Request Body:**

```json
{
  "teamName": "team-alpha",
  "teamMembers": ["user1", "user2", "user3"]
}
```

**Response `201 Created`:**

```json
{
  "teamName": "team-alpha",
  "teamMembers": ["user1", "user2", "user3"],
  "createdAt": "2026-02-13T10:00:00Z"
}
```

**Errors:**

| Status | Condition           |
| ------ | ------------------- |
| `400`  | Missing `teamName`  |
| `409`  | Team already exists |

---

### `PUT /api/teams`

Update an existing team.

| Property   | Value         |
| ---------- | ------------- |
| **Auth**   | `writer` only |
| **Method** | PUT           |

**Request Body:**

```json
{
  "teamName": "team-alpha",
  "teamMembers": ["user1", "user2", "user3", "user4"]
}
```

**Response `200 OK`:** Updated team object.

---

### `DELETE /api/teams`

Delete a team and all associated scores.

| Property   | Value         |
| ---------- | ------------- |
| **Auth**   | `writer` only |
| **Method** | DELETE        |

**Request Body:**

```json
{
  "teamName": "team-alpha"
}
```

**Response `204 No Content`**

---

### `GET /api/scores`

Retrieve scores. Supports optional query parameters for filtering.

| Property   | Value                             |
| ---------- | --------------------------------- |
| **Auth**   | `authenticated` (reader + writer) |
| **Method** | GET                               |

**Query Parameters:**

| Parameter  | Type   | Description                           |
| ---------- | ------ | ------------------------------------- |
| `team`     | string | Filter by team name (optional)        |
| `category` | string | Filter by scoring category (optional) |

**Response `200 OK`:**

```json
[
  {
    "teamName": "team-alpha",
    "category": "Requirements",
    "criterion": "ProjectContext",
    "points": 4,
    "maxPoints": 4,
    "scoredBy": "facilitator1",
    "timestamp": "2026-02-13T14:30:00Z"
  }
]
```

**Leaderboard Summary (when no filters):**

```json
{
  "leaderboard": [
    {
      "teamName": "team-alpha",
      "baseScore": 95,
      "bonusScore": 15,
      "totalScore": 110,
      "maxBaseScore": 105,
      "percentage": 90.48,
      "grade": "OUTSTANDING",
      "awards": ["BestOverall"]
    }
  ],
  "lastUpdated": "2026-02-13T15:00:00Z"
}
```

---

### `POST /api/scores`

Submit scores for a team. Upserts individual criterion scores.

| Property   | Value         |
| ---------- | ------------- |
| **Auth**   | `writer` only |
| **Method** | POST          |

**Request Body:**

```json
{
  "teamName": "team-alpha",
  "scores": [
    {
      "category": "Requirements",
      "criterion": "ProjectContext",
      "points": 4,
      "maxPoints": 4
    },
    {
      "category": "Requirements",
      "criterion": "FunctionalRequirements",
      "points": 3,
      "maxPoints": 4
    }
  ],
  "bonus": [
    {
      "enhancement": "ZoneRedundancy",
      "points": 5,
      "verified": true
    },
    {
      "enhancement": "ManagedIdentities",
      "points": 5,
      "verified": true
    }
  ]
}
```

**Response `200 OK`:**

```json
{
  "teamName": "team-alpha",
  "scoresUpserted": 2,
  "bonusUpserted": 2,
  "newTotal": 95
}
```

**Errors:**

| Status | Condition                                 |
| ------ | ----------------------------------------- |
| `400`  | Points exceed maxPoints for any criterion |
| `400`  | Unknown category or criterion name        |
| `404`  | Team not found                            |

---

### `GET /api/awards`

Retrieve all award assignments.

| Property   | Value                             |
| ---------- | --------------------------------- |
| **Auth**   | `authenticated` (reader + writer) |
| **Method** | GET                               |

**Response `200 OK`:**

```json
[
  {
    "category": "BestOverall",
    "teamName": "team-alpha",
    "assignedBy": "facilitator1",
    "timestamp": "2026-02-13T16:00:00Z"
  }
]
```

---

### `POST /api/awards`

Assign an award to a team. Upserts (one team per award category).

| Property   | Value         |
| ---------- | ------------- |
| **Auth**   | `writer` only |
| **Method** | POST          |

**Request Body:**

```json
{
  "category": "BestOverall",
  "teamName": "team-alpha"
}
```

**Valid Award Categories:**

- `BestOverall`
- `SecurityChampion`
- `CostOptimizer`
- `BestArchitecture`
- `SpeedDemon`

**Response `200 OK`:** Award object with `assignedBy` populated from auth context.

**Errors:**

| Status | Condition              |
| ------ | ---------------------- |
| `400`  | Invalid award category |
| `404`  | Team not found         |

---

### `GET /api/attendees`

Retrieve all attendee registrations. **Writer only** for full list.

| Property   | Value         |
| ---------- | ------------- |
| **Auth**   | `writer` only |
| **Method** | GET           |

**Response `200 OK`:**

```json
[
  {
    "gitHubUsername": "user1",
    "firstName": "Jane",
    "surname": "Doe",
    "teamNumber": 1,
    "registeredAt": "2026-02-13T09:00:00Z",
    "updatedAt": "2026-02-13T09:00:00Z"
  }
]
```

---

### `GET /api/attendees/me`

Retrieve the current user's own registration.

| Property   | Value                             |
| ---------- | --------------------------------- |
| **Auth**   | `authenticated` (reader + writer) |
| **Method** | GET                               |

**Response `200 OK`:** Single attendee object.

**Response `404 Not Found`:** User has not registered yet.

---

### `POST /api/attendees/me`

Register or update the current user's profile.

| Property   | Value                             |
| ---------- | --------------------------------- |
| **Auth**   | `authenticated` (reader + writer) |
| **Method** | POST                              |

**Request Body:**

```json
{
  "firstName": "Jane",
  "surname": "Doe",
  "teamNumber": 1
}
```

**Response `201 Created`** (new) or **`200 OK`** (update).

**Errors:**

| Status | Condition                           |
| ------ | ----------------------------------- |
| `400`  | Missing required fields             |
| `400`  | `teamNumber` not a positive integer |

---

### `POST /api/upload`

Bulk import scores from a `score-results.json` file (output of `Score-Team.ps1`).

| Property         | Value              |
| ---------------- | ------------------ |
| **Auth**         | `writer` only      |
| **Method**       | POST               |
| **Content-Type** | `application/json` |

**Request Body:** The full JSON output from `Score-Team.ps1`:

```json
{
  "TeamName": "team-alpha",
  "Timestamp": "2026-02-13T12:00:00Z",
  "Categories": {
    "Requirements": {
      "Score": 18,
      "MaxPoints": 20,
      "Criteria": {
        "ProjectContext": 4,
        "FunctionalRequirements": 4,
        "NFRs": 4,
        "Compliance": 3,
        "Budget": 3
      }
    },
    "Architecture": {
      "Score": 22,
      "MaxPoints": 25,
      "Criteria": {
        "CostEstimation": 5,
        "ReliabilityPatterns": 5,
        "SecurityControls": 4,
        "ScalabilityApproach": 4,
        "ServiceSelection": 4
      }
    }
  },
  "Bonus": {
    "ZoneRedundancy": { "Points": 5, "Verified": true },
    "PrivateEndpoints": { "Points": 0, "Verified": false },
    "MultiRegionDR": { "Points": 0, "Verified": false },
    "ManagedIdentities": { "Points": 5, "Verified": true }
  },
  "ShowcaseScore": 8,
  "Total": {
    "Base": 95,
    "Bonus": 10,
    "Showcase": 8,
    "Grand": 113,
    "MaxBase": 105
  },
  "Grade": "OUTSTANDING"
}
```

**Response `200 OK`:**

```json
{
  "teamName": "team-alpha",
  "scoresImported": 10,
  "bonusImported": 4,
  "totalScore": 113,
  "grade": "OUTSTANDING"
}
```

**Errors:**

| Status | Condition                          |
| ------ | ---------------------------------- |
| `400`  | Invalid JSON structure             |
| `400`  | Missing `TeamName` field           |
| `400`  | Score values exceed max points     |
| `404`  | Team not found (create team first) |

---

## Table Storage Key Design

| Table     | PartitionKey    | RowKey                     | Access Pattern                           |
| --------- | --------------- | -------------------------- | ---------------------------------------- |
| Teams     | `"team"`        | Team name                  | All teams in one partition for fast list |
| Attendees | GitHub username | `"profile"`                | Direct lookup by username                |
| Scores    | Team name       | `"{Category}_{Criterion}"` | All scores for a team in one partition   |
| Awards    | `"award"`       | Award category             | All awards in one partition              |

### Why This Design

- **Teams**: Fixed PK allows efficient `PartitionKey eq 'team'` query for leaderboard
- **Attendees**: Username as PK enables O(1) lookup for `/.auth/me` → profile resolution
- **Scores**: Team as PK groups all scores together; RK pattern enables category filtering
- **Awards**: Fixed PK with 5 known RKs — always a point query

---

## Error Response Format

All error responses follow a consistent JSON structure:

```json
{
  "error": {
    "code": "TEAM_NOT_FOUND",
    "message": "Team 'team-alpha' does not exist. Create it first via POST /api/teams."
  }
}
```

**Standard Error Codes:**

| Code                | HTTP Status | Description                         |
| ------------------- | ----------- | ----------------------------------- |
| `VALIDATION_ERROR`  | 400         | Request body failed validation      |
| `TEAM_NOT_FOUND`    | 404         | Referenced team does not exist      |
| `TEAM_EXISTS`       | 409         | Team with this name already exists  |
| `INVALID_CATEGORY`  | 400         | Unknown scoring category            |
| `INVALID_AWARD`     | 400         | Unknown award category              |
| `SCORE_EXCEEDS_MAX` | 400         | Points exceed maximum for criterion |
| `UNAUTHORIZED`      | 401         | Missing or invalid auth context     |
| `FORBIDDEN`         | 403         | Insufficient role for operation     |

---

## References

- [app-prd.md](./app-prd.md) — Product requirements with full feature descriptions
- [staticwebapp.config.json](./staticwebapp.config.json) — Route and auth configuration
- [SWA API Documentation](https://learn.microsoft.com/azure/static-web-apps/apis-functions)
- [Azure Tables SDK for JS](https://learn.microsoft.com/javascript/api/@azure/data-tables/)
- [SWA Authentication Context](https://learn.microsoft.com/azure/static-web-apps/user-information)
