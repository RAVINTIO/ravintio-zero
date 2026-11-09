# migrate-backlog-priority-and-theme.ps1 - Add default priority and theme to backlog entries.
# Idempotent: safe to run multiple times. It adds each key only when it is absent.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-backlog-priority-and-theme.ps1
# Works on Windows PowerShell 5.1 and PowerShell 7. Keep this file ASCII.

$ErrorActionPreference = 'Stop'

$Backlog = 'plan/backlog'
$IndexScript = 'ravintio-zero/scripts/backlog-index.mjs'

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
foreach ($p in @('plan', $Backlog)) {
    if (Test-Link $p) {
        Write-Host "ERROR: $p is a symlink. Refusing to continue. Nothing was written."
        Write-Host "Replace the link with a real folder, then run this helper again."
        exit 1
    }
}

if (-not (Test-Path -LiteralPath $Backlog -PathType Container)) {
    Write-Host "Nothing to do: $Backlog is not a folder."
    exit 0
}

$utf8 = New-Object System.Text.UTF8Encoding $false
$changed = 0
$dirs = @(Get-ChildItem -LiteralPath $Backlog -Directory | Sort-Object Name)
foreach ($d in $dirs) {
    $rel = "$Backlog/$($d.Name)/entry.md"
    if (-not (Test-Path -LiteralPath $rel -PathType Leaf)) { continue }
    if ((Test-Link "$Backlog/$($d.Name)") -or (Test-Link $rel)) {
        Write-Host "Skipped ${rel}: symlink."
        continue
    }
    $full = Get-FullPath $rel
    $text = [System.IO.File]::ReadAllText($full, $utf8)
    # Match the first frontmatter block: an opening rule on line 1 and the next closing rule.
    $m = [regex]::Match($text, '\A---(\r?\n)((?:[^\r\n]*\r?\n)*?)---(?=\r?\n|\z)')
    if (-not $m.Success) { continue }
    $eol = $m.Groups[1].Value
    $body = $m.Groups[2].Value
    $add = ''
    if ($body -notmatch '(?m)^priority:') { $add += 'priority: "medium"' + $eol }
    if ($body -notmatch '(?m)^theme:') { $add += 'theme: "unsorted"' + $eol }
    if ($add -eq '') { continue }
    $insertAt = $m.Groups[2].Index + $m.Groups[2].Length
    $new = $text.Substring(0, $insertAt) + $add + $text.Substring($insertAt)
    [System.IO.File]::WriteAllText($full, $new, $utf8)
    Write-Host "Updated $rel."
    $changed++
}

Write-Host "Done. Updated $changed entry file(s)."

if (Test-Path -LiteralPath $IndexScript -PathType Leaf) {
    Write-Host "Regenerating the backlog index."
    & node $IndexScript
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: $IndexScript failed. The entries are updated. Fix the cause and run it again."
        exit 1
    }
}
exit 0
