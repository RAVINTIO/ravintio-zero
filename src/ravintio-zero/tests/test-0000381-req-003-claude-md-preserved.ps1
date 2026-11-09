# Tests for feature 0000381-setup-safety, req-003, in setup.ps1 under whichever
# host runs this file. A first install moves a developer's own CLAUDE.md content
# to ravintio-overrides/instructions/. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

try {

$ws = New-SetupWorkspace
Set-Content -LiteralPath (Join-Path $ws 'CLAUDE.md') -Value "# Team rules`n`nAlways squash. Never rebase shared branches."
$run = Invoke-Setup $ws @('claude-code')
$dest = Join-Path $ws 'ravintio-overrides\instructions\original-CLAUDE.md'

Write-Host ""
Write-Host "=== req-003 AC-1: the content moves to the overrides ==="
Assert-True (Test-Path -LiteralPath $dest) "AC-1: original-CLAUDE.md exists in ravintio-overrides/instructions/"
Assert-Contains 'Always squash' (Get-Content -LiteralPath $dest -Raw) "AC-1: it holds the developer content"
Assert-Contains 'ravintio-overrides/instructions/original-CLAUDE.md' $run.Output "AC-1: setup names the file"

Write-Host ""
Write-Host "=== req-003 AC-2: the new CLAUDE.md includes the content ==="
$boot = Get-Content -LiteralPath (Join-Path $ws 'CLAUDE.md') -Raw
Assert-Contains 'Always squash' $boot "AC-2: CLAUDE.md carries the moved content"
Assert-Contains 'RAVINTIO Zero - Mandatory Pipeline Rules' $boot "AC-2: CLAUDE.md carries the pack rules"

Write-Host ""
Write-Host "=== req-003 AC-3: a re-run moves nothing ==="
$before = @(Get-ChildItem -LiteralPath (Join-Path $ws 'ravintio-overrides\instructions')).Count
$run = Invoke-Setup $ws @('claude-code')
$after = @(Get-ChildItem -LiteralPath (Join-Path $ws 'ravintio-overrides\instructions')).Count
Assert-Equal $before $after "AC-3: no new file appears"
Assert-True (-not ($run.Output -match 'content kept in')) "AC-3: setup does not mention a move"
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
