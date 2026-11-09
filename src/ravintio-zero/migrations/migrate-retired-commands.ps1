# migrate-retired-commands.ps1 - Remove the three retired pack commands.
# Idempotent: safe to run multiple times. It removes a file only if its front
# matter holds the matching "name:" line, so a developer's own command stays.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-retired-commands.ps1
# Works on Windows PowerShell 5.1 and PowerShell 7. Keep this file ASCII.

$ErrorActionPreference = 'Stop'

$Dir = '.claude/commands'

function Test-Link {
    param([string]$Path)
    $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine((Get-Location).ProviderPath, $Path))
    try {
        $attrs = [System.IO.File]::GetAttributes($full)
        return (($attrs -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
    }
    catch { return $false }
}

foreach ($p in @('.claude', $Dir)) {
    if (Test-Link $p) {
        Write-Host "ERROR: $p is a symlink. Refusing to continue. Nothing was removed."
        Write-Host "Replace the link with a real folder, then run this helper again."
        exit 1
    }
}

if (-not (Test-Path -LiteralPath $Dir -PathType Container)) {
    Write-Host "Nothing to do: $Dir is not a folder."
    exit 0
}

$removed = 0
foreach ($name in @('fast-path', 'change-pipeline', 'retrofit')) {
    $f = "$Dir/$name.md"
    if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { continue }
    if (Test-Link $f) {
        Write-Host "Skipped ${f}: symlink."
        continue
    }
    $head = @(Get-Content -LiteralPath $f -TotalCount 8)
    if (@($head | Where-Object { $_ -match "^name:\s*$([regex]::Escape($name))\s*$" }).Count -gt 0) {
        Remove-Item -LiteralPath $f -Force
        Write-Host "Removed $f."
        $removed++
    }
    else {
        Write-Host "Skipped ${f}: no matching name line, so it is not the pack command."
    }
}

Write-Host "Done. Removed $removed file(s)."
exit 0
