#!/usr/bin/env bash
# Tests for feature 0000448-driver-runs-approved-setup-command, req-001: setup-command.mjs reads
# the setup Confirmation row and returns the command only if it has the allowed form.
#
# AC-1: a valid row gives the file and the args.
# AC-2: no row, or no table, gives null.
# AC-3: a different form, or two different commands, gives null.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$SCRIPT_DIR/../scripts/setup-command.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# find <answer cell>: prints the JSON result for a chart with one setup Confirmation row.
find_for() {
  node --input-type=module -e "
import { findSetupCommand } from '$HELPER';
const cell = process.argv[1];
const text = ['## Decisions', '', '| Step | Fork | Pre-approved answer | Bump effect |', '|---|---|---|---|', '| 1-21 | Confirmation: setup rerun at each \`Setup:\` stop | ' + cell + ' | none |'].join('\n');
console.log(JSON.stringify(findSetupCommand(text)));
" "$1" 2>&1
}

echo ""
echo "=== req-001 AC-1: a valid row ==="
OUT="$(find_for 'Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. If it differs, stop.')"
assert_equals '{"file":"ravintio-zero/setup.sh","args":["claude-code","--strict-orchestrator"]}' "$OUT" "req-001 AC-1: file and args"
OUT="$(find_for 'Run `src/ravintio-zero/setup.sh claude-code`.')"
assert_equals '{"file":"src/ravintio-zero/setup.sh","args":["claude-code"]}' "$OUT" "req-001 AC-1: the src path is allowed"

echo ""
echo "=== req-001 AC-2: no row or no table ==="
OUT="$(node --input-type=module -e "
import { findSetupCommand } from '$HELPER';
console.log(JSON.stringify(findSetupCommand('# Initiative\n\nNo decisions here.\n')));
")"
assert_equals "null" "$OUT" "req-001 AC-2: no table gives null"
OUT="$(node --input-type=module -e "
import { findSetupCommand } from '$HELPER';
const t = ['## Decisions', '', '| Step | Fork | Pre-approved answer | Bump effect |', '|---|---|---|---|', '| 3 | Local suite runs | Run \`ravintio-zero/setup.sh claude-code\` | none |'].join('\n');
console.log(JSON.stringify(findSetupCommand(t)));
")"
assert_equals "null" "$OUT" "req-001 AC-2: a row that is not a setup Confirmation gives null"

echo ""
echo "=== req-001 AC-3: a different form ==="
for cmd in 'rm -rf x' 'bash -c y' 'ravintio-zero/setup.sh a; b' 'ravintio-zero/setup.sh $(id)' 'ravintio-zero/setup.sh a && b' '../ravintio-zero/setup.sh a' '/tmp/ravintio-zero/setup.sh a' 'ravintio-zero/setup.ps1 claude-code' 'ravintio-zero/setup.sh a | b' 'ravintio-zero/setup.sh --'; do
  OUT="$(find_for "Run \`$cmd\`.")"
  assert_equals "null" "$OUT" "req-001 AC-3: [$cmd] gives null"
done

echo ""
echo "=== req-001 AC-3: two different commands ==="
OUT="$(node --input-type=module -e "
import { findSetupCommand } from '$HELPER';
const t = ['## Decisions', '', '| Step | Fork | Pre-approved answer | Bump effect |', '|---|---|---|---|', '| 1 | Confirmation: setup a | \`ravintio-zero/setup.sh claude-code\` | none |', '| 2 | Confirmation: setup b | \`ravintio-zero/setup.sh codex\` | none |'].join('\n');
console.log(JSON.stringify(findSetupCommand(t)));
")"
assert_equals "null" "$OUT" "req-001 AC-3: two different commands give null"
OUT="$(node --input-type=module -e "
import { findSetupCommand } from '$HELPER';
const t = ['## Decisions', '', '| Step | Fork | Pre-approved answer | Bump effect |', '|---|---|---|---|', '| 1 | Confirmation: setup a | \`ravintio-zero/setup.sh claude-code\` | none |', '| 2 | Confirmation: setup b | \`ravintio-zero/setup.sh claude-code\` | none |'].join('\n');
console.log(JSON.stringify(findSetupCommand(t)));
")"
assert_equals '{"file":"ravintio-zero/setup.sh","args":["claude-code"]}' "$OUT" "req-001 AC-3: two equal commands give the command"

print_summary
