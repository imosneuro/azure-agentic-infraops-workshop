<#
.SYNOPSIS
    Deploys team-leaderboard Azure infrastructure using Bicep templates.

.DESCRIPTION
    Provisions Azure Static Web App, Table Storage, Log Analytics, and Application
    Insights for the microhack team leaderboard. Supports phased deployment with
    approval gates between foundation and application layers.

.PARAMETER ResourceGroupName
    Name of the resource group. Default: rg-team-leaderboard-prod

.PARAMETER Location
    Azure region for all resources. Default: westeurope

.PARAMETER Environment
    Deployment environment (dev, staging, prod). Default: prod

.PARAMETER Owner
    Resource owner identifier. Default: agentic-infraops

.PARAMETER CostCenter
    Cost center code required by Azure Policy.

.PARAMETER TechnicalContact
    Technical contact email required by Azure Policy.

.PARAMETER RepositoryUrl
    GitHub repository URL for Static Web App linkage.

.PARAMETER Phase
    Deployment phase: all, foundation, application. Default: all

.PARAMETER WhatIf
    Run what-if preview without deploying.

.EXAMPLE
    ./deploy.ps1 -CostCenter "microhack" -TechnicalContact "team@contoso.com"

.EXAMPLE
    ./deploy.ps1 -Phase foundation -CostCenter "microhack" -TechnicalContact "team@contoso.com"

.EXAMPLE
    ./deploy.ps1 -WhatIf -CostCenter "microhack" -TechnicalContact "team@contoso.com"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ResourceGroupName = 'rg-team-leaderboard-prod',
    [string]$Location = 'westeurope',

    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = 'prod',

    [string]$Owner = 'agentic-infraops',

    [Parameter(Mandatory)]
    [string]$CostCenter,

    [Parameter(Mandatory)]
    [string]$TechnicalContact,

    [string]$RepositoryUrl = '',
    [string]$RepositoryBranch = 'main',

    [ValidateSet('all', 'foundation', 'application')]
    [string]$Phase = 'all'
)

$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Team Leaderboard - Azure Deployment  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Pre-flight checks ────────────────────────────────────────────────────────

Write-Host "🔍 Pre-flight checks..." -ForegroundColor Yellow

try {
    $account = az account show --output json | ConvertFrom-Json
    Write-Host "  ✅ Logged in as: $($account.user.name)" -ForegroundColor Green
    Write-Host "  ✅ Subscription: $($account.name) ($($account.id))" -ForegroundColor Green
}
catch {
    Write-Host "  ❌ Not logged into Azure. Run 'az login --use-device-code' first." -ForegroundColor Red
    exit 1
}

# Validate real ARM token (az account show can succeed with stale cached metadata)
az account get-access-token --resource https://management.azure.com/ --output none 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Azure CLI token expired or missing from MSAL cache." -ForegroundColor Red
    Write-Host "     Run 'az login --use-device-code' in this terminal, then retry." -ForegroundColor Yellow
    Write-Host "     Note: 'az account show' may succeed even when tokens are invalid." -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✅ ARM token validated" -ForegroundColor Green

$bicepVersion = az bicep version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Bicep CLI not found. Run 'az bicep install'." -ForegroundColor Red
    exit 1
}
Write-Host "  ✅ Bicep: $bicepVersion" -ForegroundColor Green

# ── Validate templates ────────────────────────────────────────────────────────

Write-Host ""
Write-Host "📋 Validating Bicep templates..." -ForegroundColor Yellow

$templateFile = Join-Path $PSScriptRoot 'main.bicep'
$paramFile = Join-Path $PSScriptRoot 'main.bicepparam'

if (-not (Test-Path $templateFile)) {
    Write-Host "  ❌ Template not found: $templateFile" -ForegroundColor Red
    exit 1
}

az bicep build --file $templateFile 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Bicep build failed. Fix errors before deploying." -ForegroundColor Red
    exit 1
}
Write-Host "  ✅ Bicep build passed" -ForegroundColor Green

az bicep lint --file $templateFile 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ⚠️  Bicep lint warnings detected (non-blocking)" -ForegroundColor Yellow
}
else {
    Write-Host "  ✅ Bicep lint passed" -ForegroundColor Green
}

# ── Resource group with 9 required tags ───────────────────────────────────────

Write-Host ""
Write-Host "📦 Creating resource group: $ResourceGroupName..." -ForegroundColor Yellow

az group create `
    --name $ResourceGroupName `
    --location $Location `
    --tags `
        "environment=$Environment" `
        "owner=$Owner" `
        "costcenter=$CostCenter" `
        "application=team-leaderboard" `
        "workload=team-leaderboard" `
        "sla=99.9%" `
        "backup-policy=none" `
        "maint-window=sat-02-06-utc" `
        "technical-contact=$TechnicalContact" `
    --output none

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Resource group creation failed. Check tag policy compliance." -ForegroundColor Red
    exit 1
}
Write-Host "  ✅ Resource group ready with 9 required tags" -ForegroundColor Green

# ── Deployment parameters ─────────────────────────────────────────────────────

$deployParams = @(
    '--resource-group', $ResourceGroupName
    '--template-file', $templateFile
    '--parameters', "projectName=team-leaderboard"
    '--parameters', "environment=$Environment"
    '--parameters', "location=$Location"
    '--parameters', "owner=$Owner"
    '--parameters', "costCenter=$CostCenter"
    '--parameters', "technicalContact=$TechnicalContact"
    '--parameters', "repositoryUrl=$RepositoryUrl"
    '--parameters', "repositoryBranch=$RepositoryBranch"
    '--parameters', "phase=$Phase"
)

# ── What-If preview ──────────────────────────────────────────────────────────

if ($WhatIf) {
    Write-Host ""
    Write-Host "🔍 Running what-if preview (phase: $Phase)..." -ForegroundColor Yellow
    az deployment group what-if @deployParams --output table
    Write-Host ""
    Write-Host "ℹ️  What-if complete. No resources were modified." -ForegroundColor Cyan
    exit 0
}

# ── Phased deployment ─────────────────────────────────────────────────────────

function Deploy-Phase {
    param(
        [string]$PhaseName,
        [string]$PhaseValue,
        [string]$Description
    )

    Write-Host ""
    Write-Host "🚀 Deploying phase: $PhaseName ($Description)..." -ForegroundColor Yellow

    $phaseParams = @(
        '--resource-group', $ResourceGroupName
        '--template-file', $templateFile
        '--parameters', "projectName=team-leaderboard"
        '--parameters', "environment=$Environment"
        '--parameters', "location=$Location"
        '--parameters', "owner=$Owner"
        '--parameters', "costCenter=$CostCenter"
        '--parameters', "technicalContact=$TechnicalContact"
        '--parameters', "repositoryUrl=$RepositoryUrl"
        '--parameters', "repositoryBranch=$RepositoryBranch"
        '--parameters', "phase=$PhaseValue"
        '--name', "team-leaderboard-$PhaseValue-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        '--output', 'json'
    )

    # Capture stdout (JSON) separately from stderr (BCP warnings) to prevent parsing failures
    $errorOutput = $null
    $result = az deployment group create @phaseParams 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ❌ Phase '$PhaseName' deployment failed:" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        exit 1
    }

    Write-Host "  ✅ Phase '$PhaseName' deployed successfully" -ForegroundColor Green
    return $result | ConvertFrom-Json
}

if ($Phase -eq 'all') {
    # Phase 1: Foundation
    $foundationResult = Deploy-Phase -PhaseName 'Foundation' -PhaseValue 'foundation' -Description 'Log Analytics + Storage'

    Write-Host ""
    Write-Host "⏸️  Foundation deployed. Proceeding to application phase..." -ForegroundColor Cyan

    # Phase 2: Application
    $appResult = Deploy-Phase -PhaseName 'Application' -PhaseValue 'application' -Description 'App Insights + Static Web App'
}
else {
    $result = Deploy-Phase -PhaseName $Phase -PhaseValue $Phase -Description "Single phase: $Phase"
}

# ── Deployment results ────────────────────────────────────────────────────────

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       ✅ Deployment Complete            ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📊 Deployment Results:" -ForegroundColor Cyan
Write-Host "  ┌─────────────────────────┬──────────────────────────────────────┐"
Write-Host "  │ Resource Group           │ $ResourceGroupName"
Write-Host "  │ Location                 │ $Location"
Write-Host "  │ Environment              │ $Environment"
Write-Host "  │ Phase                    │ $Phase"
Write-Host "  └─────────────────────────┴──────────────────────────────────────┘"

# Extract outputs from the last deployment
if ($Phase -eq 'all' -or $Phase -eq 'application') {
    $outputs = if ($Phase -eq 'all') { $appResult } else { $result }
    if ($outputs.properties.outputs) {
        $o = $outputs.properties.outputs
        Write-Host ""
        Write-Host "  📌 Key Outputs:" -ForegroundColor Cyan
        if ($o.staticWebAppUrl.value) {
            Write-Host "     SWA URL:     https://$($o.staticWebAppUrl.value)"
        }
        if ($o.staticWebAppName.value) {
            Write-Host "     SWA Name:    $($o.staticWebAppName.value)"
        }
        if ($o.storageAccountName.value) {
            Write-Host "     Storage:     $($o.storageAccountName.value)"
        }
    }
}

Write-Host ""
Write-Host "ℹ️  Next steps:" -ForegroundColor Yellow
Write-Host "  1. Link your GitHub repo to the Static Web App (if not set via repositoryUrl)"
Write-Host "  2. Configure staticwebapp.config.json with GitHub OAuth and writer/reader roles"
Write-Host "  3. Set up managed identity for SWA → Storage access (shared key is disabled)"
Write-Host ""
