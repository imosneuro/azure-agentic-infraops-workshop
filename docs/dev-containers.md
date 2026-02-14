# Dev Containers

> [Current Version](../VERSION.md) | Dev container setup and customization for Agentic InfraOps

## Overview

This repository includes a Dev Container that provides a fully configured
development environment with all tools pre-installed. It works with both
**VS Code Dev Containers** (local Docker) and **GitHub Codespaces** (cloud).

## What's Included

| Tool | Version | Purpose |
| --- | --- | --- |
| Azure CLI (`az`) | Latest | Azure resource management |
| Bicep CLI | Latest | Infrastructure as Code |
| GitHub CLI (`gh`) | Latest | Repository and PR management |
| Node.js + npm | 20.x | Linting, validation scripts |
| Python 3 + pip | 3.12+ | Diagram generation, MCP server |
| PowerShell | 7.x | Microhack scripts, deployment |
| Git | Latest | Version control |

## Getting Started

### Local (VS Code + Docker)

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Install the
   [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Open the repo in VS Code
4. Accept the **"Reopen in Container"** prompt (or run
   `Dev Containers: Reopen in Container` from the Command Palette)

### GitHub Codespaces

1. Go to the repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for the container to build (first time takes 2-3 minutes)

## Configuration Files

| File | Purpose |
| --- | --- |
| `.devcontainer/devcontainer.json` | Container definition and VS Code settings |
| `.vscode/extensions.json` | Recommended VS Code extensions |
| `.vscode/mcp.json` | MCP server configuration |

## Customization

### Adding a VS Code extension

Add the extension ID to `.vscode/extensions.json`:

```jsonc
{
  "recommendations": [
    "your-publisher.your-extension"
  ]
}
```

### Installing additional tools

Add commands to `.devcontainer/devcontainer.json` in the
`postCreateCommand` field:

```jsonc
{
  "postCreateCommand": "npm install && pip install -r requirements.txt"
}
```

### Environment variables

Use a `.env` file in the repo root (gitignored by default) or set them
in `devcontainer.json`:

```jsonc
{
  "remoteEnv": {
    "AZURE_SUBSCRIPTION_ID": "${localEnv:AZURE_SUBSCRIPTION_ID}"
  }
}
```

## Troubleshooting

See [Troubleshooting](troubleshooting.md#dev-container) for common
Dev Container issues and fixes.
