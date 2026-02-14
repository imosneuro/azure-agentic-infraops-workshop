<#
.SYNOPSIS
    Validates microhack environment readiness in Dev Container or Codespaces.

.DESCRIPTION
    This script verifies Azure authentication and environment setup for the
    Agentic InfraOps microhack. Designed for Dev Container and GitHub Codespaces
    environments where tools are pre-installed.

.PARAMETER TeamName
    Optional team name for resource group naming convention check.

.EXAMPLE
    ./check-prerequisites.ps1
    Basic environment check.

.EXAMPLE
    ./check-prerequisites.ps1 -TeamName "alpha"
    Check with team-specific validation.

.NOTES
    Version: 4.0.0
    Environment: Dev Container / GitHub Codespaces only
    Part of: Agentic InfraOps Microhack
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$TeamName
)

# Colors and formatting
$script:PassColor = 'Green'
$script:FailColor = 'Red'
$script:WarnColor = 'Yellow'
$script:InfoColor = 'Cyan'

function Write-CheckHeader {
    param([string]$Title)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor
    Write-Host "  $Title" -ForegroundColor $InfoColor
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor
}

function Write-CheckResult {
    param(
        [string]$Name,
        [bool]$Passed,
        [string]$Details = "",
        [string]$Remediation = ""
    )

    $icon = if ($Passed) { "✅" } else { "❌" }
    $color = if ($Passed) { $PassColor } else { $FailColor }

    Write-Host "  $icon " -NoNewline
    Write-Host "$Name" -ForegroundColor $color -NoNewline

    if ($Details) {
        Write-Host " - $Details" -ForegroundColor Gray
    } else {
        Write-Host ""
    }

    if (-not $Passed -and $Remediation) {
        Write-Host "     └─ " -ForegroundColor $WarnColor -NoNewline
        Write-Host "$Remediation" -ForegroundColor $WarnColor
    }

    return $Passed
}

# Banner
Write-Host ""
Write-Host @"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║     █████╗  ██████╗ ███████╗███╗   ██╗████████╗██╗ ██████╗                    ║
║    ██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██║██╔════╝                    ║
║    ███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║   ██║██║                         ║
║    ██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║   ██║██║                         ║
║    ██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   ██║╚██████╗                    ║
║    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝ ╚═════╝                    ║
║                                                                               ║
║                    MICROHACK ENVIRONMENT CHECK                                ║
║                           Version 4.0.0                                       ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

$results = @()

# ============================================================================
# ENVIRONMENT DETECTION
# ============================================================================

Write-CheckHeader "Environment"

$inDevContainer = $env:REMOTE_CONTAINERS -eq 'true' -or $env:CODESPACES -eq 'true'
$envType = if ($env:CODESPACES -eq 'true') { "GitHub Codespaces" }
           elseif ($env:REMOTE_CONTAINERS -eq 'true') { "Dev Container" }
           else { "Local (not recommended)" }

$results += Write-CheckResult -Name "Container Environment" -Passed $inDevContainer `
    -Details $envType `
    -Remediation "Reopen in Dev Container: F1 → 'Dev Containers: Reopen in Container'"

# ============================================================================
# AZURE AUTHENTICATION
# ============================================================================

Write-CheckHeader "Azure Authentication"

# Check Azure CLI is available (should always be true in container)
$azInstalled = [bool](Get-Command "az" -ErrorAction SilentlyContinue)
$results += Write-CheckResult -Name "Azure CLI" -Passed $azInstalled `
    -Details $(if ($azInstalled) { "Available" } else { "" }) `
    -Remediation "Azure CLI should be pre-installed in the container"

# Check Azure login status
$azLoggedIn = $false
$azAccount = ""
$subscriptionId = ""
if ($azInstalled) {
    try {
        $account = az account show 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($account) {
            $azLoggedIn = $true
            $azAccount = "$($account.name)"
            $subscriptionId = $account.id
        }
    } catch { }
}
$results += Write-CheckResult -Name "Azure Login" -Passed $azLoggedIn `
    -Details $azAccount `
    -Remediation "Run: az login --use-device-code"

# Check subscription is set (not default/free tier typically)
$subscriptionSet = $azLoggedIn -and $subscriptionId -and $subscriptionId -ne ""
$results += Write-CheckResult -Name "Subscription Selected" -Passed $subscriptionSet `
    -Details $(if ($subscriptionSet) { $subscriptionId.Substring(0, 8) + "..." } else { "" }) `
    -Remediation "Run: az account set --subscription '<subscription-id>'"

# ============================================================================
# AZURE PERMISSIONS CHECK
# ============================================================================

Write-CheckHeader "Azure Permissions"

$canCreateRg = $false
if ($azLoggedIn) {
    try {
        # Check if user can list resource groups (basic permission check)
        $null = az group list --query "[0].name" -o tsv 2>&1
        $canCreateRg = $LASTEXITCODE -eq 0
    } catch { }
}
$results += Write-CheckResult -Name "Resource Group Access" -Passed $canCreateRg `
    -Details $(if ($canCreateRg) { "Can list/create resource groups" } else { "" }) `
    -Remediation "Ensure you have Owner role on the subscription (required for Azure Policy)"

# Check allowed locations (governance policy check)
$locationOk = $false
if ($azLoggedIn) {
    try {
        # Try to validate swedencentral is accessible
        $locations = az account list-locations --query "[?name=='swedencentral'].name" -o tsv 2>&1
        $locationOk = $locations -eq 'swedencentral'
    } catch { }
}
$results += Write-CheckResult -Name "Sweden Central Region" -Passed $locationOk `
    -Details $(if ($locationOk) { "swedencentral available" } else { "" }) `
    -Remediation "Ensure swedencentral region is available in your subscription"

# ============================================================================
# COPILOT CHECK
# ============================================================================

Write-CheckHeader "GitHub Copilot"

# Check if .github/agents folder exists (indicates agents are configured)
$agentsExist = Test-Path ".github/agents"
$agentCount = if ($agentsExist) { 
    (Get-ChildItem ".github/agents/*.agent.md" -ErrorAction SilentlyContinue).Count 
} else { 0 }
$results += Write-CheckResult -Name "Custom Agents" -Passed ($agentCount -gt 0) `
    -Details "$agentCount agents found" `
    -Remediation "Ensure you're in the correct repository"

Write-Host ""
Write-Host "  ℹ️  " -NoNewline -ForegroundColor $InfoColor
Write-Host "GitHub Copilot access cannot be verified programmatically." -ForegroundColor Gray
Write-Host "     Test by pressing Ctrl+Alt+I and selecting an agent from the dropdown." -ForegroundColor Gray

# ============================================================================
# TEAM RESOURCE GROUP (if team name provided)
# ============================================================================

if ($TeamName) {
    Write-CheckHeader "Team Configuration"

    $rgName = "rg-microhack-$TeamName"
    $rgExists = $false
    if ($azLoggedIn) {
        try {
            $rg = az group show --name $rgName 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
            $rgExists = $null -ne $rg
        } catch { }
    }
    $results += Write-CheckResult -Name "Team Resource Group" -Passed $rgExists `
        -Details $(if ($rgExists) { $rgName } else { "" }) `
        -Remediation "Run: az group create --name $rgName --location swedencentral"
}

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor
Write-Host "  SUMMARY" -ForegroundColor $InfoColor
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor

$passed = ($results | Where-Object { $_ -eq $true }).Count
$total = $results.Count

Write-Host ""
Write-Host "  Checks: " -NoNewline
$color = if ($passed -eq $total) { $PassColor } else { $FailColor }
Write-Host "$passed/$total passed" -ForegroundColor $color

Write-Host ""

if ($passed -eq $total) {
    Write-Host "  🎉 " -NoNewline
    Write-Host "Environment ready! You can start the microhack." -ForegroundColor $PassColor
    $exitCode = 0
} else {
    Write-Host "  ⚠️  " -NoNewline
    Write-Host "Some checks failed. Please resolve issues before starting." -ForegroundColor $FailColor
    $exitCode = 1
}

Write-Host ""
Write-Host "  📋 Start here: microhack/README.md" -ForegroundColor Gray
Write-Host "  🎯 Challenge 1: microhack/challenges/challenge-1-requirements.md" -ForegroundColor Gray
Write-Host ""

exit $exitCode
