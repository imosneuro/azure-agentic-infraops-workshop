# Quickstart

> [Current Version](../VERSION.md) | Get up and running with Agentic InfraOps in 10 minutes

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) 1.100+
- [GitHub Copilot](https://github.com/features/copilot) subscription (Pro+ or Enterprise)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for Dev Containers)
- An Azure subscription with Contributor access

## 1. Clone and Open

```bash
git clone https://github.com/jonathan-vella/azure-agentic-infraops-workshop.git
cd azure-agentic-infraops-workshop
code .
```

When VS Code opens, accept the **"Reopen in Container"** prompt.
The Dev Container installs all dependencies automatically.

## 2. Verify Prerequisites

Once inside the Dev Container, run the prerequisites check:

```powershell
pwsh scripts/check-prerequisites.ps1
```

This validates:

- Azure CLI is installed and logged in
- Bicep CLI is available
- Node.js and npm are ready
- GitHub CLI is authenticated

## 3. Enable Custom Agents

Open VS Code Settings (`Ctrl+,`) and enable subagents:

```json
{
  "github.copilot.chat": {
    "customAgentInSubagent": {
      "enabled": true
    }
  }
}
```

## 4. Start the Workflow

Open Copilot Chat (`Ctrl+Shift+I`) and select **InfraOps Conductor**:

```text
Describe the Azure infrastructure project you want to build.
```

The Conductor guides you through all 7 steps with approval gates:

1. **Requirements** — capture what you need
2. **Architecture** — WAF assessment and cost estimate
3. **Design** — diagrams and ADRs (optional)
4. **Planning** — Bicep implementation plan with governance
5. **Code** — AVM-first Bicep templates
6. **Deploy** — Azure provisioning with what-if preview
7. **Documentation** — as-built suite

## 5. Explore Sample Output

Review complete sample artifacts in [`agent-output/_sample/`](../agent-output/_sample/)
to understand what each step produces.

## Next Steps

- Read the [Copilot Guide](copilot-guide.md) for prompting best practices
- See the [Know Before You Go](know-before-you-go.md) for microhack prep
- See the [Development Workflow](guides/development-workflow.md) for contributing
- Check [Troubleshooting](troubleshooting.md) if you hit issues
