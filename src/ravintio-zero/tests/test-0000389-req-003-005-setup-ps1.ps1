# Tests for feature 0000389-writing-standard, req-003 to req-005: setup.ps1
# installs the Claude Code output style, the Codex AGENTS.md writing block,
# and skips both under --no-writing-style. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

function Get-Bytes { param([string]$Path) return [System.IO.File]::ReadAllBytes($Path) }
function Test-SameBytes {
    param([byte[]]$A, [byte[]]$B)
    return ([System.Convert]::ToBase64String($A) -ceq [System.Convert]::ToBase64String($B))
}
function Get-Fresh {
    param([string]$Ws, [string]$Tool)
    $script = Join-Path (Join-Path (Join-Path $Ws 'ravintio-zero') 'scripts') 'writing-style.mjs'
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'node'
    $psi.Arguments = "`"$script`" $Tool"
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.StandardOutputEncoding = New-Object System.Text.UTF8Encoding $false
    $p = [System.Diagnostics.Process]::Start($psi)
    $out = $p.StandardOutput.ReadToEnd()
    $p.WaitForExit()
    return $out
}
function Get-Count { param([string]$Text, [string]$Needle) return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }

try {

$styleRel = '.claude/output-styles/ravintio-writing.md'

Write-Host ""
Write-Host "=== req-003 AC-1: claude-code installs the style, no settings.json ==="

$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude') -Recurse -Force
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "req-003 AC-1: setup exits 0"
$style = Join-Path $ws $styleRel
Assert-True (Test-Path $style) "req-003 AC-1: the style file is written"
Assert-Contains '+ .claude/output-styles/ravintio-writing.md (created)' $run.Output "req-003 AC-1: the output says created"
Assert-Equal 'ravintio-writing' ((Read-Settings $ws).outputStyle) "req-003 AC-1: outputStyle is set"
Assert-Contains 'outputStyle set to ravintio-writing' $run.Output "req-003 AC-1: the output says outputStyle set"
$bytes = Get-Bytes (Get-SettingsPath $ws)
Assert-True (-not ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB)) "req-003 AC-1: settings.json has no BOM"

Write-Host ""
Write-Host "=== req-003 AC-3: matches the generator, rerun changes no byte ==="

$fresh = Get-Fresh $ws 'claude-code'
$fileBytes = Get-Bytes $style
Assert-True (Test-SameBytes $fileBytes ((New-Object System.Text.UTF8Encoding $false).GetBytes($fresh))) "req-003 AC-3: the style file equals a fresh generation"
Assert-True (-not ($fileBytes.Length -ge 3 -and $fileBytes[0] -eq 0xEF)) "req-003 AC-3: the style file has no BOM"
Assert-True (-not ([System.Text.Encoding]::UTF8.GetString($fileBytes)).Contains("`r")) "req-003 AC-3: the style file has LF endings"
$settingsBefore = Get-Bytes (Get-SettingsPath $ws)
$run = Invoke-Setup $ws @('claude-code')
Assert-True (Test-SameBytes $fileBytes (Get-Bytes $style)) "req-003 AC-3: the rerun keeps the style file"
Assert-True (Test-SameBytes $settingsBefore (Get-Bytes (Get-SettingsPath $ws))) "req-003 AC-3: the rerun keeps settings.json"
Assert-Contains '- .claude/output-styles/ravintio-writing.md (unchanged)' $run.Output "req-003 AC-3: the output says unchanged"
Assert-Contains 'outputStyle already ravintio-writing' $run.Output "req-003 AC-3: the output says already set"
[System.IO.File]::WriteAllText($style, 'stale', (New-Object System.Text.UTF8Encoding $false))
$run = Invoke-Setup $ws @('claude-code')
Assert-Contains '~ .claude/output-styles/ravintio-writing.md (updated)' $run.Output "req-003 AC-3: a stale file is updated"
Assert-True (Test-SameBytes $fileBytes (Get-Bytes $style)) "req-003 AC-3: the update restores the generation"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-003 AC-2: an existing outputStyle stays ==="

$ws = New-SetupWorkspace
Write-SettingsText $ws "{`"outputStyle`":`"Concise`"}"
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "req-003 AC-2: setup exits 0"
Assert-Equal 'Concise' ((Read-Settings $ws).outputStyle) "req-003 AC-2: outputStyle stays Concise"
Assert-Contains 'outputStyle already set to Concise, left as is' $run.Output "req-003 AC-2: the output says so"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-004: codex AGENTS.md holds one writing block ==="

$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude') -Recurse -Force
New-Item -ItemType Directory -Path (Join-Path $ws 'ravintio-overrides\instructions') -Force | Out-Null
Set-Content -Path (Join-Path $ws 'ravintio-overrides\instructions\custom-001-test.md') -Value 'Local rule for the test.'
$run = Invoke-Setup $ws @('codex')
Assert-Equal 0 $run.Code "req-004: setup codex exits 0"
$agents = Join-Path $ws 'AGENTS.md'
$text = [System.IO.File]::ReadAllText($agents)
Assert-Equal 1 (Get-Count $text '<!-- ravintio-writing:start -->') "req-004: one start marker"
Assert-Equal 1 (Get-Count $text '<!-- ravintio-writing:end -->') "req-004: one end marker"
Assert-Contains (Get-Fresh $ws 'codex') $text "req-004: the block equals a fresh generation"
Assert-Contains 'ravintio-overrides:instructions:start' $text "req-004: the override block is kept"
Assert-Contains '+ AGENTS.md (writing section added)' $run.Output "req-004: the output says added"
Assert-True (-not (Test-Path (Join-Path $ws $styleRel))) "req-004: codex writes no output style"
$before = Get-Bytes $agents
$run = Invoke-Setup $ws @('codex')
Assert-True (Test-SameBytes $before (Get-Bytes $agents)) "req-004: a rerun is byte-identical"
Assert-Equal 1 (Get-Count ([System.IO.File]::ReadAllText($agents)) '<!-- ravintio-writing:start -->') "req-004: a rerun keeps one block"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-005 AC-1: --no-writing-style ==="

$ws = New-SetupWorkspace
$run = Invoke-Setup $ws @('claude-code', '--no-writing-style')
Assert-Equal 0 $run.Code "req-005 AC-1: claude-code exits 0"
Assert-True (-not (Test-Path (Join-Path $ws $styleRel))) "req-005 AC-1: no style file"
Assert-True ($null -eq (Read-Settings $ws).PSObject.Properties['outputStyle']) "req-005 AC-1: no outputStyle key"
Assert-Contains '- writing style skipped (--no-writing-style)' $run.Output "req-005 AC-1: the output says skipped"
Assert-Contains '--no-writing-style' (Get-Content -Raw (Join-Path $ws 'plan/state/claude-code.md')) "req-005 AC-1: the setup record lists the flag"
Assert-Contains '--no-writing-style' (Get-Content -Raw (Join-Path $ws '.claude/.ravintio-setup-flags')) "req-005 AC-1: the marker lists the flag"
Remove-SetupWorkspace $ws

$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude') -Recurse -Force
$run = Invoke-Setup $ws @('--no-writing-style', 'codex')
Assert-Equal 0 $run.Code "req-005 AC-1: codex with the flag first exits 0"
Assert-Equal 0 (Get-Count ([System.IO.File]::ReadAllText((Join-Path $ws 'AGENTS.md'))) 'ravintio-writing:start') "req-005 AC-1: AGENTS.md has no writing block"
Assert-Contains '- writing style skipped (--no-writing-style)' $run.Output "req-005 AC-1: codex output says skipped"
Assert-Contains '--no-writing-style' (Get-Content -Raw (Join-Path $ws 'plan/state/codex.md')) "req-005 AC-1: the codex record lists the flag"
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
