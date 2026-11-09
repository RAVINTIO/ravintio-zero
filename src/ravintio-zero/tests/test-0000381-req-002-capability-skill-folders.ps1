# Tests for feature 0000381-setup-safety, req-002, in setup.ps1 under whichever
# host runs this file. Setup copies every file of a capability skill folder and
# skips a folder with no SKILL.md. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

try {

$ws = New-SetupWorkspace
$cap = Join-Path $ws 'ravintio-overrides\capability-skills'
New-Item -ItemType Directory -Path (Join-Path $cap 'my-skill\references'), (Join-Path $cap 'my-skill\scripts'), (Join-Path $cap 'no-skill-md\references') -Force | Out-Null
Set-Content -LiteralPath (Join-Path $cap 'my-skill\SKILL.md') -Value "---`nname: my-skill`ndescription: A test skill.`n---`n# My skill"
Set-Content -LiteralPath (Join-Path $cap 'my-skill\references\guide.md') -Value 'ref'
Set-Content -LiteralPath (Join-Path $cap 'my-skill\scripts\run.sh') -Value 'run'
Set-Content -LiteralPath (Join-Path $cap 'no-skill-md\references\orphan.md') -Value 'orphan'
$run = Invoke-Setup $ws @('claude-code')
$sk = Join-Path $ws '.claude\skills'

Write-Host ""
Write-Host "=== req-002 AC-1: references and scripts install ==="
Assert-True (Test-Path -LiteralPath (Join-Path $sk 'my-skill\SKILL.md')) "AC-1: SKILL.md installs"
Assert-True (Test-Path -LiteralPath (Join-Path $sk 'my-skill\references\guide.md')) "AC-1: references/guide.md installs"
Assert-True (Test-Path -LiteralPath (Join-Path $sk 'my-skill\scripts\run.sh')) "AC-1: scripts/run.sh installs"

Write-Host ""
Write-Host "=== req-002 AC-2: a folder with no SKILL.md warns and installs nothing ==="
Assert-True (-not (Test-Path -LiteralPath (Join-Path $sk 'no-skill-md'))) "AC-2: the folder with no SKILL.md is not installed"
Assert-Contains 'no-skill-md' $run.Output "AC-2: setup warns and names the folder"
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
