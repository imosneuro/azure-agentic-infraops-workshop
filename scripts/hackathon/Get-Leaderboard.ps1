<#
.SYNOPSIS
    Displays the hackathon leaderboard based on team scores.

.DESCRIPTION
    Reads score-results.json from each team folder and displays a ranked leaderboard.

.EXAMPLE
    .\Get-Leaderboard.ps1

.EXAMPLE
    .\Get-Leaderboard.ps1 -OutputFormat Table
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('Table', 'Markdown', 'Json')]
    [string]$OutputFormat = 'Table'
)

$ErrorActionPreference = 'Stop'

# Paths - go up 2 levels from scripts/hackathon/ to repo root
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$AgentOutputPath = Join-Path $RepoRoot "agent-output"

# Collect scores
$Scores = @()
$TeamFolders = Get-ChildItem -Path $AgentOutputPath -Directory | Where-Object { $_.Name -ne ".gitkeep" }

foreach ($Folder in $TeamFolders) {
    $ScoreFile = Join-Path $Folder.FullName "score-results.json"
    if (Test-Path $ScoreFile) {
        $TeamScore = Get-Content $ScoreFile -Raw | ConvertFrom-Json
        $Scores += $TeamScore
    }
}

if ($Scores.Count -eq 0) {
    Write-Host "`n⚠️ No scores found. Run Score-Team.ps1 first." -ForegroundColor Yellow
    exit 0
}

# Sort by total score
$Ranked = $Scores | Sort-Object -Property Total -Descending

# Add rank
$Rank = 1
$Ranked = $Ranked | ForEach-Object {
    $_ | Add-Member -NotePropertyName 'Rank' -NotePropertyValue $Rank -PassThru
    $Rank++
}

# Output
switch ($OutputFormat) {
    'Table' {
        Write-Host "`n🏆 HACKATHON LEADERBOARD" -ForegroundColor Cyan
        Write-Host "=" * 70
        Write-Host ""
        
        $TableData = $Ranked | ForEach-Object {
            $Medal = switch ($_.Rank) {
                1 { "🥇" }
                2 { "🥈" }
                3 { "🥉" }
                default { "  " }
            }
            
            [PSCustomObject]@{
                ' '   = $Medal
                Rank  = $_.Rank
                Team  = $_.Team
                Req   = "$($_.Requirements)/20"
                Arch  = "$($_.Architecture)/25"
                Impl  = "$($_.Implementation)/25"
                Dep   = "$($_.Deployment)/10"
                Docs  = "$($_.Documentation)/5"
                Load  = "$($_.LoadTesting)/5"
                Diag  = "$($_.Diagnostics)/5"
                Show  = "$($_.Showcase)/10"
                Bonus = "+$($_.Bonus)"
                Total = "$($_.Total)/130"
            }
        }
        
        $TableData | Format-Table -AutoSize
        
        # Summary stats
        $Avg = [math]::Round(($Scores | Measure-Object -Property Total -Average).Average, 1)
        $Max = ($Scores | Measure-Object -Property Total -Maximum).Maximum
        $Min = ($Scores | Measure-Object -Property Total -Minimum).Minimum
        
        Write-Host "`n📊 Statistics" -ForegroundColor Yellow
        Write-Host "  Teams:   $($Scores.Count)"
        Write-Host "  Average: $Avg"
        Write-Host "  Highest: $Max"
        Write-Host "  Lowest:  $Min"
    }
    
    'Markdown' {
        Write-Output "# Hackathon Leaderboard"
        Write-Output ""
        Write-Output "| Rank | Team | Req | Arch | Impl | Dep | Docs | Load | Diag | Show | Bonus | Total |"
        Write-Output "|------|------|-----|------|------|-----|------|------|------|------|-------|-------|"
        
        foreach ($Team in $Ranked) {
            $Medal = switch ($Team.Rank) {
                1 { "🥇" }
                2 { "🥈" }
                3 { "🥉" }
                default { "" }
            }
            Write-Output "| $Medal $($Team.Rank) | $($Team.Team) | $($Team.Requirements) | $($Team.Architecture) | $($Team.Implementation) | $($Team.Deployment) | $($Team.Documentation) | $($Team.LoadTesting) | $($Team.Diagnostics) | $($Team.Showcase) | +$($Team.Bonus) | **$($Team.Total)** |"
        }
    }
    
    'Json' {
        $Ranked | ConvertTo-Json -Depth 10
    }
}
