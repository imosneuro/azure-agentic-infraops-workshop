# Scenario Brief: Nordic Fresh Foods

> **Your Challenge**: Design and deploy Azure infrastructure for a farm-to-table delivery platform.

## The Business

**Nordic Fresh Foods** is a growing farm-to-table delivery company based in Stockholm, Sweden.
They connect local organic farmers with restaurants and consumers across Scandinavia.

| Fact                | Details                                   |
| ------------------- | ----------------------------------------- |
| Founded             | 2022                                      |
| Partner Restaurants | 500+                                      |
| Active Consumers    | 10,000                                    |
| Current Tech        | Spreadsheets, WordPress, manual processes |
| Funding             | €2M Series A (just secured)               |

## The Problem

The CEO has secured €2M in Series A funding and needs to modernize operations before peak
season (3 months away). Current pain points:

1. **Order chaos**: Staff manually enters orders from phone, email, and web forms into
   spreadsheets. They lose ~8% of orders to errors.

2. **No real-time inventory**: Farmers update stock levels via WhatsApp. The team often
   oversells products that are no longer available.

3. **Delivery scheduling**: Routes are planned manually. Drivers often arrive at farms when
   produce isn't ready, wasting time and fuel.

4. **Customer visibility**: Restaurants have no way to track orders or see estimated
   delivery times. They call constantly for updates.

5. **Seasonal scaling**: During summer and December, order volume triples. They currently
   hire temp staff and work overtime — it's unsustainable.

## The Vision

The CTO (newly hired) has outlined a vision for **"FreshConnect"** — a cloud-based platform
that will:

- Accept orders from a web portal and mobile app
- Show real-time inventory from connected farms
- Automatically schedule and optimize delivery routes
- Provide order tracking for restaurants and consumers
- Scale seamlessly during peak periods
- Generate analytics for business decisions

## Your Mission

Design and deploy the Azure infrastructure for the **FreshConnect MVP** (Minimum Viable Product).

> ⚠️ **Note**: You are NOT building the application code. You are designing and deploying
> the **cloud infrastructure** that the development team will use.

## MVP Requirements

### Functional Requirements

| Capability             | Description                                                               |
| ---------------------- | ------------------------------------------------------------------------- |
| **Web Portal**         | Restaurant and consumer order entry (expect 500 concurrent users at peak) |
| **API Backend**        | RESTful APIs for mobile apps and integrations                             |
| **Database**           | Store orders, customers, inventory, delivery schedules                    |
| **File Storage**       | Product images, invoices, delivery receipts                               |
| **Secrets Management** | API keys, connection strings, certificates                                |
| **Monitoring**         | Application health, performance metrics, alerts                           |

### Constraints

| Constraint     | Value                  | Notes                                                     |
| -------------- | ---------------------- | --------------------------------------------------------- |
| **Budget**     | ~€500/month            | Infrastructure only (increases to €700 after Challenge 4) |
| **Compliance** | GDPR                   | Customer PII must stay in EU                              |
| **Region**     | `swedencentral`        | Primary region (Stockholm proximity)                      |
| **Timeline**   | 3 months to production | MVP for peak season                                       |
| **Team**       | 3 developers, 1 DevOps | Small team, needs managed services                        |

### Out of Scope (for MVP)

- Mobile app infrastructure (Phase 2)
- AI/ML for route optimization (Phase 2)
- Multi-region disaster recovery _(initially — see Challenge 4!)_
- Real-time IoT from delivery vehicles (Phase 3)

## Non-Functional Requirements

| Requirement    | Target                                       |
| -------------- | -------------------------------------------- |
| SLA            | 99.9%                                        |
| RTO            | 4 hours (initially)                          |
| RPO            | 1 hour (initially)                           |
| Peak Load      | 500 concurrent users                         |
| Seasonal Spike | 3x normal volume                             |
| Authentication | Azure AD (internal), Azure AD B2C (external) |
| Network        | Public endpoints acceptable for MVP          |

## Key Stakeholders

| Role           | Priorities                       |
| -------------- | -------------------------------- |
| **CEO**        | On-time delivery, budget control |
| **CTO**        | Scalability, modern architecture |
| **CFO**        | Cost optimization, ROI           |
| **Operations** | Reliability, easy maintenance    |

---

## The Microhack Journey

This 6-hour microhack walks you through the full infrastructure lifecycle across **8 challenges**:

1. **Requirements** — Capture business needs using `requirements` agent
2. **Architecture** — Design Azure solution aligned with Well-Architected Framework
3. **Implementation** — Generate Bicep templates for deployment
4. **DR Curveball** — Adapt to multi-region disaster recovery requirements
5. **Load Testing** — Validate performance under stress
6. **Documentation** — Create operational guides and runbooks
7. **Diagnostics** — Build troubleshooting procedures
8. **Partner Showcase** — Present your solution professionally

Not all teams will complete all challenges — the goal is learning the agentic workflow and prompt engineering skills!

---

## Getting Started

Begin with [Challenge 1: Requirements](../microhack/challenges/challenge-1-requirements.md) to capture these
requirements using the **requirements** agent.
