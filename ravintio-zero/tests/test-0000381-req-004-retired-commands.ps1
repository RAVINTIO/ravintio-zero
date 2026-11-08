# Tests for feature 0000381-setup-safety, req-004, in setup.ps1 under whichever
# host runs this file. Setup prunes retired pack commands and keeps a developer's
# own commands, and migration 0008 does the same. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

function New-CommandWorkspace {
    $ws = New-SetupWorkspace
    $c = Join-Path $ws '.claude\commands'
    New-Item -ItemType Directory -Path $c -Force | Out-Null
    foreach ($n in @('fast-path', 'change-pipeline', 'retrofit')) {
        Set-Content -LiteralPath (Join-Path $c "$n.md") -Value "---`nname: $n`ndescription: Retired.`n---`n# $n"
    }
    Set-Content -LiteralPath (Join-Path $c 'my-own.md') -Value "---`nname: my-own`ndescription: Mine.`n---`n# Mine"
    return $ws
}

try {

Write-Host ""
Write-Host "=== req-004 AC-1 and AC-2: setup prunes retired commands, keeps the developer's ==="
$ws = New-CommandWorkspace
$c = Join-Path $ws '.claude\commands'
$run = Invoke-Setup $ws @('claude-code')
foreach ($n in @('fast-path', 'change-pipeline', 'retrofit')) {
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $c "$n.md"))) "AC-1: $n.md is removed"
}
Assert-True (Test-Path -LiteralPath (Join-Path $c 'feature-pipeline.md')) "the shipped command installs"
Assert-True (Test-Path -LiteralPath (Join-Path $c 'my-own.md')) "AC-2: the developer command survives"
$run = Invoke-Setup $ws @('claude-code')
Assert-True (Test-Path -LiteralPath (Join-Path $c 'my-own.md')) "AC-2: the developer command survives a re-run"
Assert-Contains 'feature-pipeline.md' (Get-Content -LiteralPath (Join-Path $c '.ravintio-manifest') -Raw) "setup lists the shipped command in the command manifest"

Write-Host ""
Write-Host "=== req-004: a listed command the pack stopped shipping is removed ==="
Add-Content -LiteralPath (Join-Path $c '.ravintio-manifest') -Value 'old-shipped.md'
Set-Content -LiteralPath (Join-Path $c 'old-shipped.md') -Value '# old'
$run = Invoke-Setup $ws @('claude-code')
Assert-True (-not (Test-Path -LiteralPath (Join-Path $c 'old-shipped.md'))) "a manifest-listed command the pack no longer ships is removed"
Assert-True (Test-Path -LiteralPath (Join-Path $c 'my-own.md')) "an unlisted developer command stays"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-004 AC-3: migration 0008 removes the retired commands ==="
$ws = New-CommandWorkspace
$c = Join-Path $ws '.claude\commands'
Push-Location $ws
try {
    & $global:HostExe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $ws 'ravintio-zero\migrations\migrate-retired-commands.ps1') 2>&1 | Out-Null
    Assert-Equal 0 $LASTEXITCODE "AC-3: the helper exits 0"
    foreach ($n in @('fast-path', 'change-pipeline', 'retrofit')) {
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $c "$n.md"))) "AC-3: $n.md is removed by the helper"
    }
    Assert-True (Test-Path -LiteralPath (Join-Path $c 'my-own.md')) "AC-3: the helper keeps the developer command"
    & $global:HostExe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $ws 'ravintio-zero\migrations\migrate-retired-commands.ps1') 2>&1 | Out-Null
    Assert-Equal 0 $LASTEXITCODE "AC-3: a second run exits 0"
}
finally { Pop-Location }
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
