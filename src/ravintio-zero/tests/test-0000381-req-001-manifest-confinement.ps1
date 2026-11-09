# Tests for feature 0000381-setup-safety, req-001, in setup.ps1 under whichever
# host runs this file. Setup removes only the folders its manifest lists inside
# the skills directory, and writes repo-relative paths. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

try {

Write-Host ""
Write-Host "=== req-001 AC-2: setup.ps1 writes a repo-relative manifest ==="

$ws = New-SetupWorkspace
$skills = Join-Path $ws '.claude\skills'
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "AC-2: setup exits 0"
$manifest = Join-Path $skills '.ravintio-manifest'
$lines = @(Get-Content -LiteralPath $manifest)
Assert-True ($lines[0] -like '.claude/skills/ravintio-*') "AC-2: first manifest line starts with the skills directory"
Assert-True (@($lines | Where-Object { [System.IO.Path]::IsPathRooted($_) }).Count -eq 0) "AC-2: no manifest line is absolute"

Write-Host ""
Write-Host "=== req-001 AC-1: lines outside the skills directory are skipped ==="

$out = Join-Path ([System.IO.Path]::GetTempPath()) ("ravintio_0000381_" + [guid]::NewGuid().ToString('N'))
foreach ($d in @('abs', 'dots')) {
    New-Item -ItemType Directory -Path (Join-Path $out $d) -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $out "$d\keep.txt") -Value 'keep'
}
$extra = @(
    (Join-Path $out 'abs'),
    '.claude/skills/../../../outside/dots'
)
Add-Content -LiteralPath $manifest -Value $extra
$run = Invoke-Setup $ws @('claude-code')
Assert-True (Test-Path -LiteralPath (Join-Path $out 'abs\keep.txt')) "AC-1: absolute target survives"
Assert-True (Test-Path -LiteralPath (Join-Path $out 'dots\keep.txt')) "AC-1: dots target survives"
Assert-Contains 'outside the skills directory' $run.Output "AC-1: setup warns about a skipped line"

Write-Host ""
Write-Host "=== req-001: a listed folder inside the skills directory is still removed ==="

$old = Join-Path $skills 'old-pack-skill'
$legacy = Join-Path $skills 'old-pack-skill-legacy'
New-Item -ItemType Directory -Path $old, $legacy -Force | Out-Null
Add-Content -LiteralPath $manifest -Value @('.claude/skills/old-pack-skill', $legacy)
$run = Invoke-Setup $ws @('claude-code')
Assert-True (-not (Test-Path -LiteralPath $old)) "relative line inside the skills directory is removed"
Assert-True (-not (Test-Path -LiteralPath $legacy)) "legacy absolute line inside the skills directory is removed"
Remove-Item -LiteralPath $out -Recurse -Force -ErrorAction SilentlyContinue
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
