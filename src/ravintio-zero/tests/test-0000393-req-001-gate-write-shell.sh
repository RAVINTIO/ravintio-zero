#!/usr/bin/env bash
# 0000393 req-001: gate-write checks Bash redirects, tee and sed -i (ADR-001)
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
node "$SCRIPT_DIR/test-0000393-req-001-gate-write-shell.mjs"
exit $?
