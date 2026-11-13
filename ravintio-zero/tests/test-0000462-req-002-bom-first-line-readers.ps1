# Tests for feature 0000462-tests-without-git-identity, req-002: setup.ps1 accepts a
# boot file that starts with a UTF-8 BOM, as Windows PowerShell 5.1 writes it.
# Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

try {

Write-Host ""
Write-Host "=== REQ-002 AC-2: setup.ps1 leaves a boot file with a BOM alone ==="

$ws = New-SetupWorkspace
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "REQ-002 AC-2: the first setup run exits 0"
$boot = Join-Path $ws 'CLAUDE.md'
$text = [System.IO.File]::ReadAllText($boot)
[System.IO.File]::WriteAllBytes($boot, ([byte[]](0xEF, 0xBB, 0xBF)) + (New-Object System.Text.UTF8Encoding $false).GetBytes($text))
$bytes = [System.IO.File]::ReadAllBytes($boot)
Assert-True ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) "REQ-002 fixture: CLAUDE.md starts with a BOM"
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "REQ-002 AC-2: setup exits 0 on a boot file with a BOM"
$kept = Join-Path $ws 'ravintio-overrides\instructions\original-CLAUDE.md'
Assert-True (-not (Test-Path -LiteralPath $kept)) "REQ-002 AC-2: setup copies nothing to ravintio-overrides/instructions/"
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
