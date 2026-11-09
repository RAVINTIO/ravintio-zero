# migrate-adr-home.ps1 - Move every ADR into docs/adr under a four-digit number.
# Idempotent: safe to run multiple times. A second run changes nothing.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-adr-home.ps1 [--dry-run] [--root <dir>] [--no-restore] [--include-current]
# Works on Windows PowerShell 5.1 and PowerShell 7. Keep this file ASCII.

$ErrorActionPreference = 'Stop'

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host 'ERROR: node is not installed. Install Node.js, then run this helper again.'
    exit 1
}

& node (Join-Path $PSScriptRoot 'migrate-adr-home.mjs') @args
exit $LASTEXITCODE
