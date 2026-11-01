# Tests for feature 0000316-hooks-fail-closed, req-001 and req-002: setup.ps1
# keeps Bash in the project root and wires every hook from the project root.
# It writes the same settings as setup.sh. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

function Get-AllHookCommands {
    param([string]$Path)
    $json = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json
    $out = @()
    foreach ($ev in @($json.hooks.PSObject.Properties.Name)) {
        foreach ($group in @($json.hooks.$ev)) {
            foreach ($hook in @($group.hooks)) { $out += "$($hook.command)" }
        }
    }
    return $out
}

try {

Write-Host ""
Write-Host "=== req-001: the env setting ==="
$ws = New-SetupWorkspace
$settingsPath = Join-Path $ws '.claude\settings.json'
[System.IO.File]::WriteAllText($settingsPath, '{"env":{"FOO":"bar"}}')
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "req-001: setup exits 0"
$json = [System.IO.File]::ReadAllText($settingsPath) | ConvertFrom-Json
Assert-Equal '1' "$($json.env.CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR)" "req-001 AC-1: the setting is 1"
Assert-Equal 'bar' "$($json.env.FOO)" "req-001 AC-2: FOO survives"
$before = [System.IO.File]::ReadAllText($settingsPath)
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal $before ([System.IO.File]::ReadAllText($settingsPath)) "req-001 AC-3: a rerun leaves settings.json unchanged"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-002: hook commands use the project root ==="
$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude\settings.json') -Force -ErrorAction SilentlyContinue
$run = Invoke-Setup $ws @('claude-code')
$cmds = Get-AllHookCommands (Join-Path $ws '.claude\settings.json')
Assert-Equal 0 @($cmds | Where-Object { $_ -like 'node ".claude/*' }).Count "req-002: no command is relative to the working directory"
Assert-Equal 0 @($cmds | Where-Object { $_ -notlike '*${CLAUDE_PROJECT_DIR}*' }).Count "req-002: every command reads CLAUDE_PROJECT_DIR"
Assert-Equal 7 @($cmds | Where-Object { $_ -like '* guard *' }).Count "req-002: seven PreToolUse commands run in guard mode"
Assert-Equal 4 @($cmds | Where-Object { $_ -like '* advisory *' }).Count "req-002: four commands run in advisory mode"
Assert-True (Test-Path (Join-Path $ws '.claude\hooks\enforcement\guard-run.mjs')) "req-002: guard-run.mjs is installed"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-002 AC-2: Codex uses the absolute project path ==="
$ws = New-SetupWorkspace
Remove-Item -LiteralPath (Join-Path $ws '.claude') -Recurse -Force
$run = Invoke-Setup $ws @('codex')
$cmds = Get-AllHookCommands (Join-Path $ws '.codex\hooks.json')
$root = ($ws -replace '\\', '/').TrimEnd('/')
Assert-Contains "$root/.codex/hooks/enforcement/guard-run.mjs" ($cmds -join "`n") "req-002 AC-2: the command holds the absolute path"
Assert-Equal 0 @($cmds | Where-Object { $_ -like '*rev-parse*' }).Count "req-002 AC-2: the command has no git rev-parse"
$run = Invoke-Setup $ws @('codex')
Assert-Equal 1 @(Get-AllHookCommands (Join-Path $ws '.codex\hooks.json')).Count "req-002 AC-3: a rerun leaves one hook"
Remove-SetupWorkspace $ws

}
finally { Remove-AllWorkspaces }

Complete-Suite
