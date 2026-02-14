<#
.SYNOPSIS
    Cleans up Azure resources created during the microhack.

.DESCRIPTION
    Deletes resource groups matching microhack naming patterns.
    Supports dry-run mode to preview deletions.

.PARAMETER TeamName
    Delete resources for a specific team only.

.PARAMETER Pattern
    Resource group name pattern to match (default: rg-*-dev-swc).

.PARAMETER WhatIf
    Preview deletions without executing them.

.PARAMETER Force
    Skip confirmation prompts.

.EXAMPLE
    .\Cleanup-MicrohackResources.ps1 -WhatIf
    # Preview all resource groups that would be deleted

.EXAMPLE
    .\Cleanup-MicrohackResources.ps1 -TeamName "freshconnect"
    # Delete only freshconnect team's resources

.EXAMPLE
    .\Cleanup-MicrohackResources.ps1 -Force
    # Delete all matching resources without prompts
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [string]$TeamName,

    [Parameter()]
    [string]$Pattern = "rg-*-dev-*",

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

Write-Host "`n🧹 Microhack Resource Cleanup" -ForegroundColor Cyan
Write-Host "=" * 50

# Check Azure CLI login
try {
    $Account = az account show 2>&1 | ConvertFrom-Json
    Write-Host "Subscription: $($Account.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Not logged in to Azure. Run: az login" -ForegroundColor Red
    exit 1
}

# Build filter
if ($TeamName) {
    $Filter = "rg-$TeamName-*"
    Write-Host "Filtering for team: $TeamName" -ForegroundColor Yellow
} else {
    $Filter = $Pattern
}

# Get matching resource groups
Write-Host "`nSearching for resource groups matching: $Filter" -ForegroundColor Yellow
$ResourceGroups = az group list --query "[?contains(name, 'rg-') && contains(name, '-dev-')]" 2>&1 | ConvertFrom-Json

if ($TeamName) {
    $ResourceGroups = $ResourceGroups | Where-Object { $_.name -like "*$TeamName*" }
}

if ($ResourceGroups.Count -eq 0) {
    Write-Host "`n✅ No matching resource groups found." -ForegroundColor Green
    exit 0
}

# Display what will be deleted
Write-Host "`nFound $($ResourceGroups.Count) resource group(s):" -ForegroundColor Yellow
$ResourceGroups | ForEach-Object {
    $ResourceCount = (az resource list -g $_.name --query "length(@)" 2>$null) ?? 0
    Write-Host "  - $($_.name) ($ResourceCount resources) [$($_.location)]"
}

# Estimate costs saved
Write-Host "`n💰 Deleting these resources will stop ongoing charges." -ForegroundColor Green

# Confirm
if (-not $Force -and -not $WhatIfPreference) {
    Write-Host ""
    $Confirm = Read-Host "Delete these resource groups? (yes/no)"
    if ($Confirm -ne 'yes') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Delete
$Deleted = 0
$Failed = 0

foreach ($RG in $ResourceGroups) {
    if ($PSCmdlet.ShouldProcess($RG.name, "Delete resource group")) {
        try {
            Write-Host "Deleting: $($RG.name)..." -NoNewline
            az group delete --name $RG.name --yes --no-wait 2>&1 | Out-Null
            Write-Host " ✅ (async)" -ForegroundColor Green
            $Deleted++
        } catch {
            Write-Host " ❌ Failed" -ForegroundColor Red
            $Failed++
        }
    }
}

# Summary
Write-Host "`n" + "=" * 50
Write-Host "📊 Summary" -ForegroundColor Cyan
Write-Host "  Deleted: $Deleted"
Write-Host "  Failed:  $Failed"

if ($Deleted -gt 0) {
    Write-Host "`n⏳ Deletions are running asynchronously." -ForegroundColor Yellow
    Write-Host "   Check Azure Portal to confirm completion."
}

Write-Host "`n✅ Cleanup initiated." -ForegroundColor Green
