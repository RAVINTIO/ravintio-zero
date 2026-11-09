# Tests for feature 0000382-install-lifecycle, req-001 to req-005, in setup.ps1
# under whichever host runs this file. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

# Runs setup.ps1 without the helper's pre-commit, so a dirty tree stays dirty.
function Invoke-RawSetup {
    param([string]$Workspace, [string[]]$SetupArgs)
    $setup = Join-Path $Workspace 'ravintio-zero\setup.ps1'
    Push-Location $Workspace
    $saved = $env:GIT_CEILING_DIRECTORIES
    $env:GIT_CEILING_DIRECTORIES = Split-Path -Parent $Workspace
    try {
        $output = & $global:HostExe -NoProfile -ExecutionPolicy Bypass -File $setup @SetupArgs 2>&1 | Out-String
        $code = $LASTEXITCODE
    }
    finally { $env:GIT_CEILING_DIRECTORIES = $saved; Pop-Location }
    return [PSCustomObject]@{ Code = $code; Output = $output }
}

try {

Write-Host "=== req-002: the clean-tree check ==="
$ws = New-SetupWorkspace
Add-Content -LiteralPath (Join-Path $ws 'ravintio-zero\getting-started.md') -Value 'edit'
$r = Invoke-RawSetup $ws @('claude-code')
Assert-Equal 1 $r.Code "setup exits 1 on a modified pack file"
Assert-Contains 'ravintio-zero/getting-started.md' $r.Output "setup names the file"
Assert-True (-not (Test-Path -LiteralPath (Join-Path $ws '.claude\skills'))) "setup copied nothing"
Remove-SetupWorkspace $ws

$ws = Join-Path ([System.IO.Path]::GetTempPath()) ("ravintio_0000382_" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $ws | Out-Null
Copy-Item -Path $global:ZeroDir -Destination (Join-Path $ws 'ravintio-zero') -Recurse
$global:Workspaces += $ws
$r = Invoke-RawSetup $ws @('claude-code')
Assert-Equal 1 $r.Code "setup exits 1 outside a git repository"
Assert-Contains 'git repository' $r.Output "the message names git"

Write-Host "=== req-001: doctor and plan/current ==="
$ws = New-SetupWorkspace
$r = Invoke-Setup $ws @('claude-code', '--doctor')
Assert-Equal 1 $r.Code "doctor exits 1 before setup ran"
Assert-Contains 'setup has not run' $r.Output "doctor says setup has not run"
$r = Invoke-Setup $ws @('claude-code', '--strict-orchestrator')
Assert-Equal 0 $r.Code "setup exits 0"
Assert-True (Test-Path -LiteralPath (Join-Path $ws 'plan\current')) "setup creates plan/current"
$r = Invoke-Setup $ws @('claude-code', '--doctor')
Assert-Equal 0 $r.Code "doctor exits 0 after setup"
Assert-Contains 'Doctor found no problems' $r.Output "doctor reports no problems"

Write-Host "=== req-004: strict mode follows the flags ==="
$r = Invoke-Setup $ws @('claude-code')
Assert-True (Test-Path -LiteralPath (Join-Path $ws 'plan\.orchestrator-strict')) "a plain re-run keeps strict mode"
$r = Invoke-Setup $ws @('claude-code', '--no-strict-orchestrator')
Assert-True (-not (Test-Path -LiteralPath (Join-Path $ws 'plan\.orchestrator-strict'))) "--no-strict-orchestrator removes strict mode"
Assert-Contains 'strict mode off' $r.Output "setup says it turned strict mode off"
$r = Invoke-Setup $ws @('claude-code', '--strict-orchestrator', '--no-strict-orchestrator')
Assert-Equal 1 $r.Code "both strict flags exit 1"

Write-Host "=== req-003: uninstall ==="
$r = Invoke-Setup $ws @('claude-code', '--uninstall')
Assert-Equal 0 $r.Code "uninstall exits 0"
Assert-Equal '' ((& git -C $ws config --get core.hooksPath) -join '') "core.hooksPath is unset"
Assert-True (-not (Test-Path -LiteralPath (Join-Path $ws '.claude\skills\ravintio-plan'))) "the pack skill is removed"
Assert-True (Test-Path -LiteralPath (Join-Path $ws 'plan\state\claude-code.md')) "the setup record survives"
Set-Content -LiteralPath (Join-Path $ws 'plan\.orchestrator-active') -Value 'x'
$r = Invoke-Setup $ws @('claude-code', '--uninstall')
Assert-Equal 1 $r.Code "uninstall exits 1 while a run is active"

Write-Host "=== req-005: help ==="
$r = Invoke-Setup $ws @('--help')
Assert-Equal 0 $r.Code "--help exits 0"
foreach ($f in @('--strict-orchestrator', '--no-strict-orchestrator', '--doctor', '--update', '--uninstall', '--help')) {
    Assert-Contains $f $r.Output "help lists $f"
}

}
finally { Remove-AllWorkspaces }

Complete-Suite
