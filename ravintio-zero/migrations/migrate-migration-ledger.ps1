# migrate-migration-ledger.ps1 - Copy the pack's _done/ records into the migration ledger.
# Idempotent: safe to run multiple times. It only appends rows and deletes nothing.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-migration-ledger.ps1 [PackVersion]
# Without an argument, the version comes from ravintio-zero/component.yml.
# Works on Windows PowerShell 5.1 and PowerShell 7. Keep this file ASCII.

param([string]$PackVersion = '')

$ErrorActionPreference = 'Stop'

$DoneDir = 'ravintio-zero/migrations/_done'
$LedgerDir = 'plan/state'
$Ledger = 'plan/state/migrations.md'

function Get-FullPath {
    param([string]$Path)
    return [System.IO.Path]::GetFullPath([System.IO.Path]::Combine((Get-Location).ProviderPath, $Path))
}

# True when the entry itself is a link, dangling or not. A link is read as a
# link and never followed.
function Test-Link {
    param([string]$Path)
    $full = Get-FullPath $Path
    try {
        $attrs = [System.IO.File]::GetAttributes($full)
        if (($attrs -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) { return $true }
    }
    catch { }
    try {
        $info = New-Object System.IO.FileInfo $full
        if (($null -ne $info.PSObject.Properties['LinkTarget']) -and ($null -ne $info.LinkTarget)) { return $true }
    }
    catch { }
    try {
        $item = Get-Item -LiteralPath $full -Force -ErrorAction SilentlyContinue
        if (($null -ne $item) -and ($null -ne $item.PSObject.Properties['LinkType']) -and (@('SymbolicLink', 'Junction') -contains "$($item.LinkType)")) { return $true }
    }
    catch { }
    return $false
}

# Refuse a symlink at any path this helper writes through.
foreach ($p in @('plan', $LedgerDir, $Ledger)) {
    if (Test-Link $p) {
        Write-Host "ERROR: $p is a symlink. Refusing to continue. Nothing was written."
        Write-Host "Replace the link with a real file or folder, then run this helper again."
        exit 1
    }
}

$utf8 = New-Object System.Text.UTF8Encoding $false

if ($PackVersion -eq '') {
    if (Test-Path -LiteralPath 'ravintio-zero/component.yml' -PathType Leaf) {
        $text = [System.IO.File]::ReadAllText((Get-FullPath 'ravintio-zero/component.yml'), $utf8)
        $m = [regex]::Match($text, '(?m)^version:\s*["'']?(\d+\.\d+\.\d+)["'']?\s*$')
        if ($m.Success) { $PackVersion = $m.Groups[1].Value }
    }
}
if ($PackVersion -notmatch '^\d+\.\d+\.\d+$') {
    Write-Host "ERROR: no pack version found in ravintio-zero/component.yml. Nothing was written."
    exit 1
}

if ((-not (Test-Path -LiteralPath $DoneDir -PathType Container)) -or (Test-Link $DoneDir)) {
    Write-Host "Nothing to do: $DoneDir is not a folder."
    exit 0
}

$ledgerFull = Get-FullPath $Ledger
if (-not (Test-Path -LiteralPath $Ledger -PathType Leaf)) {
    [System.IO.Directory]::CreateDirectory((Get-FullPath $LedgerDir)) | Out-Null
    $header = @(
        '# Migration ledger',
        '',
        'The migrator appends one row per migration. The result is `done` or `not applicable`.',
        'The id is the four-digit migration number, or the file name without `.md` for an older file.',
        'The pack version is the version when the row was written.',
        '',
        '| Migration | Result | Pack version |',
        '|---|---|---|'
    ) -join "`n"
    [System.IO.File]::WriteAllText($ledgerFull, $header + "`n", $utf8)
    Write-Host "Created $Ledger."
}
else {
    $current = [System.IO.File]::ReadAllText($ledgerFull, $utf8)
    if (($current.Length -gt 0) -and (-not $current.EndsWith("`n"))) {
        [System.IO.File]::AppendAllText($ledgerFull, "`n", $utf8)
    }
}

$added = 0
$files = @(Get-ChildItem -LiteralPath $DoneDir -Filter '*.md' -File | Sort-Object Name)
foreach ($f in $files) {
    if (Test-Link "$DoneDir/$($f.Name)") { continue }
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $id = $stem
    if ($stem -match '^(\d{4})-') { $id = $Matches[1] }
    $existing = [System.IO.File]::ReadAllText($ledgerFull, $utf8)
    if ($existing.Contains("| $id |")) {
        Write-Host "Skipped ${id}: already in the ledger."
        continue
    }
    [System.IO.File]::AppendAllText($ledgerFull, "| $id | done | $PackVersion |`n", $utf8)
    Write-Host "Added $id."
    $added++
}

Write-Host "Done. Added $added row(s) to $Ledger."
exit 0
