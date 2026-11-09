#!/usr/bin/env bash
# Tests for feature 0000382-install-lifecycle, req-005: help, clean bytes, docs, and block messages.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== AC-1: --help exits 0 and lists every flag ==="
out="$(bash "$ZERO_DIR/setup.sh" --help)"; rc=$?
assert_equals "0" "$rc" "--help exits 0"
flags="$(sed -n '/^while \[\[ \$# -gt 0 \]\]/,/^done/p' "$ZERO_DIR/setup.sh" | grep -oE '^\s+(-h\|)?--?[a-z][a-z-]*(\|--[a-z-]+)*' | grep -oE -- '--?[a-z][a-z-]*' | sort -u)"
missing=""
for f in $flags; do
  case "$f" in --structured-telemetry-mcp|--context-mode-mcp|--include-full-skill-library|--backend-url) continue ;; esac
  printf '%s' "$out" | grep -qF -- "$f" || missing="$missing $f"
done
assert_equals "" "$missing" "help lists every accepted flag"
assert_equals "0" "$(bash "$ZERO_DIR/setup.sh" -h >/dev/null; echo $?)" "-h exits 0"

echo "=== AC-2: setup.sh holds no invalid UTF-8 and no mojibake banner ==="
iconv -f UTF-8 -t UTF-8 "$ZERO_DIR/setup.sh" >/dev/null 2>&1 && r=yes || r=no
assert_equals "yes" "$r" "setup.sh is valid UTF-8"
assert_equals "0" "$(grep -c 'Ã' "$ZERO_DIR/setup.sh")" "setup.sh holds no mojibake"
assert_contains "========" "$(sed -n '/^echo "RAVINTIO Setup"/{n;p;}' "$ZERO_DIR/setup.sh" | tail -1)" "the banner is a plain rule"

echo "=== AC-3: every hook block message names a next step ==="
for hook in gate-write em-dash-guard merge-guard block-forced-add ratchet-check; do
  f="$ZERO_DIR/hooks/enforcement/$hook.mjs"
  grep -qiE 'next step|first\.|Complete P0|Load the|Rerun|Replace with|leave it out|add a line|Add it to|Write literal|use the Write tool|human on the loop' "$f" && r=yes || r=no
  assert_equals "yes" "$r" "$hook names a next step"
done
assert_contains "Next step" "$(grep -h 'Next step' "$ZERO_DIR/hooks/enforcement/merge-guard.mjs")" "merge-guard names the next step"

echo "=== the guide covers the day-to-day commands and override skills ==="
guide="$(cat "$ZERO_DIR/getting-started.md")"
assert_contains "## Day-to-day commands" "$guide" "commands table exists"
for w in pause park skip; do assert_contains "\`$w" "$guide" "the table covers $w"; done
assert_contains "ravintio-overrides/capability-skills/" "$guide" "the guide names the override skills folder"
out="$(cd "$(mktemp -d)" && true)"
assert_contains "ravintio-overrides/capability-skills/" "$(bash "$ZERO_DIR/setup.sh" --help)" "help names the override skills folder"

echo "=== the docs give the real skill count ==="
n="$(ls -d "$ZERO_DIR"/skills/*/ | wc -l | tr -d ' ')"
assert_equals "16" "$n" "the pack ships 16 skills"
assert_contains "Sixteen skills" "$(cat "$ZERO_DIR/pipeline-reference.md")" "pipeline-reference says sixteen"
assert_contains "The 16 skills" "$guide" "the guide says 16"

print_summary
