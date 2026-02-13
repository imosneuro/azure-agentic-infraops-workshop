# Hackathon Agenda

> **Agentic InfraOps Hackathon** — 6 hours (10:00 - 16:00)

---

## Team Structure

| Aspect          | Details                  |
| --------------- | ------------------------ |
| Team Size       | 3-6 members per team     |
| Number of Teams | Flexible based on cohort |

---

## Schedule Overview

| Time        | Block           | Duration | Activity                          |
| ----------- | --------------- | -------- | --------------------------------- |
| 10:00-10:30 | **Intro**       | 30 min   | Welcome, setup, team formation    |
| 10:30-11:20 | **Challenge 1** | 50 min   | Requirements Capture              |
| 11:20-12:10 | **Challenge 2** | 50 min   | Architecture Design               |
| 12:10-12:40 | 🍽️ **Lunch**    | 30 min   | Break                             |
| 12:40-13:50 | **Challenge 3** | 70 min   | Bicep Implementation & Deployment |
| 13:50-14:30 | **Challenge 4** | 40 min   | DR Curveball & Deployment         |
| 14:30-14:50 | **Challenge 5** | 20 min   | Load Testing                      |
| 14:50-15:10 | **Challenge 6** | 20 min   | Documentation                     |
| 15:10-15:15 | **Challenge 7** | 5 min    | Diagnostics                       |
| 15:15-15:25 | 🎯 **Prep**     | 10 min   | Presentation Preparation          |
| 15:25-15:55 | **Challenge 8** | 30 min   | Partner Showcase 🎤               |
| 15:55-16:00 | **Wrap-up**     | 5 min    | Leaderboard, cleanup, close       |

---

## Challenge Summary

| #   | Challenge                     | Duration | Points | Agent(s)                             |
| --- | ----------------------------- | -------- | ------ | ------------------------------------ |
| 1   | Requirements Capture          | 50 min   | 20     | `requirements`                       |
| 2   | Architecture Design           | 50 min   | 25     | `architect`                          |
| 3   | Bicep Implementation & Deploy | 70 min   | 25     | `bicep-plan`, `bicep-code`, `deploy` |
| 4   | DR Curveball & Deploy         | 40 min   | 10     | `bicep-plan`, `bicep-code`, `deploy` |
| 5   | Load Testing                  | 20 min   | 5      | (k6 scripts)                         |
| 6   | Documentation                 | 20 min   | 5      | `design`                             |
| 7   | Diagnostics                   | 5 min    | 5      | `diagnose`                           |
| 8   | Partner Showcase 🎤           | 30 min   | 10     | (presentation)                       |

**Total Points**: 105 base + 25 bonus

> 🔒 **Coaches**: See [facilitator-guide.md](facilitator/facilitator-guide.md) for Challenge 4 details.
> Challenge 8 focuses on professional communication and presentation skills.

---

## Detailed Timing

### Block 1: Intro (10:00 - 10:30)

| Time  | Activity             |
| ----- | -------------------- |
| 10:00 | Welcome & logistics  |
| 10:05 | Hackathon overview   |
| 10:12 | 7-step workflow demo |
| 10:18 | Setup verification   |
| 10:24 | Team formation       |
| 10:27 | Scenario briefing    |

### Block 2: Challenge 1 (10:30 - 11:20)

| Time  | Activity                              |
| ----- | ------------------------------------- |
| 10:30 | Start — invoke **requirements** agent |
| 10:45 | Check-in — conversations started?     |
| 11:00 | Progress — draft requirements?        |
| 11:10 | Push — encourage approval             |
| 11:20 | Complete — move to Challenge 2        |

### Block 3: Challenge 2 (11:20 - 12:10)

| Time  | Activity                                    |
| ----- | ------------------------------------------- |
| 11:20 | Start — handoff from **requirements** agent |
| 11:35 | Check-in — WAF recommendations?             |
| 11:50 | Cost — Pricing MCP working?                 |
| 12:00 | Wrap — finalize architecture                |
| 12:10 | Lunch                                       |

### 🍽️ Lunch (12:10 - 12:40)

### Block 4: Challenge 3 (12:40 - 13:50)

| Time  | Activity                                |
| ----- | --------------------------------------- |
| 12:40 | Start — **bicep-plan** agent            |
| 12:55 | Plan — implementation plan ready?       |
| 13:10 | Code — **bicep-code** agent             |
| 13:30 | Validate — `bicep build` + `bicep lint` |
| 13:40 | Deploy — **deploy** agent               |
| 13:50 | Complete — move to Challenge 4          |

### Block 5: Challenge 4 (13:50 - 14:30)

| Time  | Activity                                   |
| ----- | ------------------------------------------ |
| 13:50 | 📣 **Challenge 4: DR Curveball Announced** |
| 13:55 | Update architecture for multi-region       |
| 14:10 | Generate updated Bicep templates           |
| 14:20 | Deploy DR infrastructure                   |
| 14:30 | Complete — move to Challenge 5             |

### Block 6: Challenges 5-7 (14:30 - 15:15)

| Time  | Activity                                     |
| ----- | -------------------------------------------- |
| 14:30 | **Challenge 5: Load Testing**                |
| 14:40 | Run k6 load tests                            |
| 14:50 | **Challenge 6: Documentation**               |
| 15:00 | Generate workload docs with **design** agent |
| 15:10 | **Challenge 7: Diagnostics**                 |
| 15:15 | Prep begins                                  |

### 🎯 Presentation Prep (15:15 - 15:25)

Teams prepare their Partner Showcase presentations (5-min pitch + 2-min Q&A format).

### Block 7: Challenge 8 (15:25 - 15:55)

| Time  | Team                     |
| ----- | ------------------------ |
| 15:25 | Intro & pairings         |
| 15:27 | Team 1 presents (~7 min) |
| 15:34 | Team 2 presents (~7 min) |
| 15:41 | Team 3 presents (~7 min) |
| 15:48 | Team 4 presents (~7 min) |

### Wrap-up (15:55 - 16:00)

- Announce leaderboard
- Key learnings
- Resource cleanup reminder

---

## Quick Reference

- **Repo**: [github.com/jonathan-vella/azure-agentic-infraops-workshop](https://github.com/jonathan-vella/azure-agentic-infraops-workshop)
- **Challenges**: [hackathon/challenges/](challenges/)
- **Facilitator Guide**: [hackathon/facilitator/facilitator-guide.md](facilitator/facilitator-guide.md)
- **Pre-Work**: [docs/know-before-you-go.md](../docs/know-before-you-go.md)
