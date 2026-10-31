# Runs every test-*.ps1 suite in tests/ and tests/regression/ under the
# PowerShell host that started this script (0000036 ADR-002). CI runs it once
# with powershell (Windows PowerShell 5.1) and once with pwsh (PowerShell 7).
# run-tests.sh runs the same suites with pwsh, alongside the bash suites.
#
# Environment:
#   RAVINTIO_TEST_QUIET=1   hide PASS lines and banners, keep every failure and the summary
#   RAVINTIO_TIMING_FILE    set by this script (0000171 req-003). Invoke-Setup appends
#                           one setup.ps1 time per run, and the total prints before the summary.
#
# The runner removes every RAVINTIO_ variable from the environment of each suite (0000315), so a
# suite gives the same result in any session. The initiative driver sets RAVINTIO_INITIATIVE_STEP
# in every step session, and the hooks read it. A suite that needs a variable sets it for its own
# call. Three variables pass through: RAVINTIO_PWSH, RAVINTIO_TIMING_FILE, and RAVINTIO_TEST_QUIET. The
# last one only changes how much a suite prints, and assert.ps1 reads it. A suite that starts a
# nested runner unsets it first.
#
# The runner also compares tracked and untracked files before the first suite and after the last.
# If a suite changes one, the run fails and names the path. Ignored files are not compared.

$ErrorActionPreference = 'Stop'
$quiet = ($env:RAVINTIO_TEST_QUIET -eq '1')
foreach ($item in @(Get-ChildItem Env: | Where-Object { $_.Name -like 'RAVINTIO_*' })) {
    if ($item.Name -notin @('RAVINTIO_PWSH', 'RAVINTIO_TEST_QUIET')) { Remove-Item "Env:$($item.Name)" -ErrorAction SilentlyContinue }
}

# Returns "path<TAB>hash" lines for modified, deleted, and untracked files, or $null outside a git repository.
function Get-TreeSnapshot {
    # Windows PowerShell 5.1 turns native stderr into a terminating error under 'Stop', so relax it here.
    $savedPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $top = & git -C $here rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $top) { return $null }
        $lines = @()
        foreach ($f in @(& git -C $top -c core.quotepath=false ls-files -m -o --exclude-standard 2>$null)) {
            if (-not $f) { continue }
            if (Test-Path -LiteralPath (Join-Path $top $f)) {
                $h = (& git -C $top hash-object -- $f 2>$null)
                $lines += "$f`t$h"
            } else {
                $lines += "$f`tdeleted"
            }
        }
        return ,@($lines | Sort-Object -Unique)
    }
    finally {
        $ErrorActionPreference = $savedPreference
    }
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$treeBefore = Get-TreeSnapshot
$hostExe = (Get-Process -Id $PID).Path
Write-Host "Host: PowerShell $($PSVersionTable.PSVersion) ($($PSVersionTable.PSEdition)), $hostExe"

$suites = @(Get-ChildItem -LiteralPath $here -Filter 'test-*.ps1' -File | Sort-Object Name)
$regressionDir = Join-Path $here 'regression'
if (Test-Path -LiteralPath $regressionDir) {
    $suites += @(Get-ChildItem -LiteralPath $regressionDir -Filter 'test-*.ps1' -File | Sort-Object Name)
}

if ($suites.Count -eq 0) {
    Write-Host "No PowerShell suites found."
    exit 1
}

$timingFile = Join-Path ([System.IO.Path]::GetTempPath()) ("ravintio-timing-" + [guid]::NewGuid().ToString('N') + ".txt")
[System.IO.File]::WriteAllText($timingFile, '')
$savedTimingFile = $env:RAVINTIO_TIMING_FILE
$env:RAVINTIO_TIMING_FILE = $timingFile

$failed = @()
try {
    foreach ($suite in $suites) {
        if ($quiet) {
            $suiteOut = & $hostExe -NoProfile -ExecutionPolicy Bypass -File $suite.FullName 2>&1 | Out-String
            if ($LASTEXITCODE -ne 0) {
                $failed += $suite.Name
                if (-not $suiteOut.Contains("--- $($suite.Name) ---")) {
                    Write-Host ""
                    Write-Host "--- $($suite.Name) ---"
                }
                Write-Host $suiteOut
            }
        }
        else {
            Write-Host ""
            Write-Host "--- $($suite.Name) ---"
            & $hostExe -NoProfile -ExecutionPolicy Bypass -File $suite.FullName
            if ($LASTEXITCODE -ne 0) { $failed += $suite.Name }
        }
    }

    $values = @([System.IO.File]::ReadAllLines($timingFile) | Where-Object { $_ -match '^\d+$' })
    $totalMs = [long]0
    foreach ($v in $values) { $totalMs += [long]$v }
    Write-Host ""
    Write-Host "[timing] setup.ps1 total: $totalMs ms over $($values.Count) cases"
}
finally {
    $env:RAVINTIO_TIMING_FILE = $savedTimingFile
    if ($null -eq $savedTimingFile) { Remove-Item Env:RAVINTIO_TIMING_FILE -ErrorAction SilentlyContinue }
    Remove-Item -LiteralPath $timingFile -Force -ErrorAction SilentlyContinue
}

$treeChanged = @()
if ($null -ne $treeBefore) {
    $treeAfter = Get-TreeSnapshot
    $diff = @(Compare-Object -ReferenceObject @($treeBefore) -DifferenceObject @($treeAfter))
    $treeChanged = @($diff | ForEach-Object { ($_.InputObject -split "`t")[0] } | Sort-Object -Unique)
    foreach ($path in $treeChanged) { Write-Host "Tree changed during the run: $path" }
}

Write-Host ""
Write-Host "================================"
Write-Host "PowerShell suites: $($suites.Count - $failed.Count) passed, $($failed.Count) failed."
foreach ($name in $failed) { Write-Host "  failed: $name" }
Write-Host "================================"
if ($failed.Count -gt 0 -or $treeChanged.Count -gt 0) { exit 1 }
exit 0
