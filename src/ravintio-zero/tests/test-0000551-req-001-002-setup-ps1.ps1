# Tests for feature 0000551-refuse-symlink-style-outputs, req-001 and req-002:
# setup.ps1 refuses a link at the style file path, its folder, and AGENTS.md
# for the writing block. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

function New-TestLink {
    param([string]$Path, [string]$Target)
    try {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -ErrorAction Stop | Out-Null
        return $true
    }
    catch { return $false }
}
function Get-Count { param([string]$Text, [string]$Needle) return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }

try {

$styleRel = '.claude/output-styles/ravintio-writing.md'
$styleLine = "  ! Refused: $styleRel is a link, writing style not installed"
$agentsLine = '  ! Refused: AGENTS.md is a link, writing section not installed'

Write-Host ""
Write-Host "=== req-001 AC-1: a link at the style file ==="

$ws = New-SetupWorkspace
$victim = Join-Path $ws 'victim.txt'
[System.IO.File]::WriteAllText($victim, 'victim content')
New-Item -ItemType Directory -Path (Join-Path $ws '.claude/output-styles') -Force | Out-Null
$stylePath = Join-Path $ws $styleRel
if (New-TestLink $stylePath $victim) {
    $run = Invoke-Setup $ws @('claude-code')
    Assert-Equal 0 $run.Code "req-001 AC-1: setup exits 0"
    Assert-Equal 'victim content' ([System.IO.File]::ReadAllText($victim)) "req-001 AC-1: the target keeps its bytes"
    Assert-Contains $styleLine $run.Output "req-001 AC-1: the fixed line is printed"
    Assert-True ($null -eq (Read-Settings $ws).PSObject.Properties['outputStyle']) "req-001 AC-1: outputStyle stays unset"
}
else { Write-Host "  SKIP: cannot create a symbolic link on this host" }
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-001 AC-2: a link at the style folder ==="

$ws = New-SetupWorkspace
$other = Join-Path $ws 'other-folder'
New-Item -ItemType Directory -Path $other | Out-Null
if (New-TestLink (Join-Path $ws '.claude/output-styles') $other) {
    $run = Invoke-Setup $ws @('claude-code')
    Assert-Equal 0 $run.Code "req-001 AC-2: setup exits 0"
    Assert-Equal 0 @(Get-ChildItem -LiteralPath $other -Recurse -File).Count "req-001 AC-2: the other folder gains no file"
    Assert-Contains $styleLine $run.Output "req-001 AC-2: the fixed line is printed"
}
else { Write-Host "  SKIP: cannot create a symbolic link on this host" }
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-001 AC-3: no link, the install is unchanged ==="

$ws = New-SetupWorkspace
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "req-001 AC-3: setup exits 0"
Assert-True (Test-Path (Join-Path $ws $styleRel)) "req-001 AC-3: the style file is written"
Assert-True (-not $run.Output.Contains('Refused')) "req-001 AC-3: no refusal line"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-002 AC-1: a link at AGENTS.md ==="

$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude') -Recurse -Force
$victim = Join-Path $ws 'victim.txt'
[System.IO.File]::WriteAllText($victim, 'victim content')
if (New-TestLink (Join-Path $ws 'AGENTS.md') $victim) {
    $run = Invoke-Setup $ws @('codex')
    Assert-Equal 0 $run.Code "req-002 AC-1: setup exits 0"
    Assert-Equal 0 (Get-Count ([System.IO.File]::ReadAllText($victim)) 'ravintio-writing:start') "req-002 AC-1: the target holds no writing block"
    Assert-Contains $agentsLine $run.Output "req-002 AC-1: the fixed line is printed"
}
else { Write-Host "  SKIP: cannot create a symbolic link on this host" }
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-002 AC-2: a plain AGENTS.md keeps one block ==="

$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude') -Recurse -Force
$run = Invoke-Setup $ws @('codex')
Assert-Equal 0 $run.Code "req-002 AC-2: setup exits 0"
Assert-Equal 1 (Get-Count ([System.IO.File]::ReadAllText((Join-Path $ws 'AGENTS.md'))) 'ravintio-writing:start') "req-002 AC-2: one writing block"
Assert-True (-not $run.Output.Contains('Refused')) "req-002 AC-2: no refusal line"
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
