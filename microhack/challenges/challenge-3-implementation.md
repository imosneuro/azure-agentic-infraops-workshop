# Challenge 3: Bicep Implementation, Deployment & Workflow Understanding

## Prerequisite: Azure Policy Deployment (Recommended)

If your facilitator has deployed Azure Policies for the event, your Bicep templates will need to
comply with governance constraints (required tags, HTTPS-only, TLS 1.2, etc.).
See the [Setup-GovernancePolicies.ps1](https://github.com/jonathan-vella/azure-agentic-infraops-workshop/tree/main/microhack/scripts#governance-scripts)
section of the repository for details.

> **Duration**: 45 minutes | **Agents**: `bicep-plan`, `bicep-code`, `deploy`
> **Output**: Deployed infrastructure + Workflow diagram

## The Business Challenge

Nordic Fresh Foods needs production-ready infrastructure code that:

- Can be deployed repeatedly and consistently
- Meets Azure governance and security requirements
- Is maintainable by their small DevOps team
- Follows infrastructure-as-code best practices

Your task: Generate Bicep templates, **deploy them to Azure**, and **demonstrate you understand
the agent workflow** by explaining it.

## Your Challenge

### Part A: Implementation Planning (~10 min)

**Your Task**: Use the `bicep-plan` agent to create an implementation strategy.

**Guiding Questions**:

- What information does the agent need from your architecture assessment?
- How should you structure your prompt to get a phased implementation plan?
- What governance constraints might affect your deployment?

**Prompt Engineering Tip**: The agent works best when you provide context about your
architecture decisions, not just a file reference.

**Expected Output**: `agent-output/freshconnect/04-implementation-plan.md`
