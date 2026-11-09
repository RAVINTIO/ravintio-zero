#!/usr/bin/env bash
# 0000384 req-001, req-003, req-004: plan checks
# consistency-check.mjs checks 9 (shell version), 10 (living docs unit), 8 (shared resources), 3 (docs/adr).
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

CHECK="$ZERO_DIR/scripts/consistency-check.mjs"
TMP="$(mktemp -d -t ravintio_0000384_plan_checks_XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

HEADER='| Unit | Depends on | Writes | Batch | Sequential reason |
|------|------------|--------|-------|-------------------|'
HEADER_RES='| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|------------|--------|-------|-------------------|------------------|'

# Build a fixture with a design. Prints the plan/current path.
make_fixture() {
  local d="$TMP/$1/plan/current"
  mkdir -p "$d/adr"
  printf '# Design\n## Scope\n- In: things\n' > "$d/design.md"
  echo "$d"
}

# Write an execution plan. $2 is the header, rows come from stdin.
write_plan() {
  { printf '# Execution plan\n\n## Concurrency plan\n\n%s\n' "$2"; cat; printf '\n## Assumptions\n- none\n'; } > "$1/execution-plan.md"
}

write_adr() { printf '# ADR\n\n## Decision\n\n%s\n' "$3" > "$1/adr/$2"; }

echo ""
echo "=== 0000384 req-001/003/004 plan-checks ==="

# req-001 AC-1: Bash 4 feature without an Oldest shell line fails
D=$(make_fixture shell-fail)
write_adr "$D" ADR-001-hook.md 'Use command_not_found_handle to catch typos.'
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "1" "$RC" "req-001 AC-1: unlisted shell version exits 1"
assert_contains "ADR-001-hook.md" "$OUT" "req-001 AC-1: finding names the ADR"
assert_contains "command_not_found_handle" "$OUT" "req-001 AC-1: finding names the feature"

# req-001 AC-2: the Oldest shell line makes it pass
D=$(make_fixture shell-pass)
write_adr "$D" ADR-001-hook.md 'Use command_not_found_handle to catch typos.
Oldest shell: Bash 3.2, feature checked absent, fallback chosen'
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "0" "$RC" "req-001 AC-2: named shell version exits 0"
assert_contains "consistency-check: clean" "$OUT" "req-001 AC-2: check 9 reports no finding"

# req-001: every listed feature is detected
for feat in 'declare -A m' 'mapfile -t a' 'readarray a' 'coproc X' 'shopt -s globstar' 'wait -n' 'echo ${v,,}' 'echo ${v^^}' 'x &>> log' 'a |& b'; do
  D=$(make_fixture "feat-$RANDOM")
  write_adr "$D" ADR-001-x.md "Run: $feat"
  OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
  assert_equals "1" "$RC" "req-001: '$feat' is flagged"
done

# req-001: an ADR with no listed feature needs no line
D=$(make_fixture shell-none)
write_adr "$D" ADR-001-x.md 'Plain text, no shell feature.'
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "0" "$RC" "req-001: ADR without a listed feature passes"

# req-003 AC-2: plan with no docs unit fails
D=$(make_fixture docs-missing)
write_plan "$D" "$HEADER" <<'MD'
| U1-a | none | `src/a.txt` | 1 | |
| U2-b | none | `src/b.txt` | 1 | |
MD
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "1" "$RC" "req-003 AC-2: missing docs unit exits 1"
assert_contains "living docs unit" "$OUT" "req-003 AC-2: finding names the missing living docs unit"

# req-003 AC-3: plan with a docs unit passes
D=$(make_fixture docs-present)
write_plan "$D" "$HEADER" <<'MD'
| U1-a | none | `src/a.txt` | 1 | |
| U2-docs | none | `docs/decisions-index.md` | 1 | |
MD
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "0" "$RC" "req-003 AC-3: docs unit exits 0"
case "$OUT" in *"living docs"*) echo "  FAIL: req-003 AC-3: check 10 raised a finding"; FAIL=$((FAIL+1));; *) echo "  PASS: req-003 AC-3: check 10 reports no finding"; PASS=$((PASS+1));; esac

# req-003: no execution plan skips check 10
D=$(make_fixture docs-skip)
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "0" "$RC" "req-003 skip: no execution-plan.md exits 0"

# req-003: a plan with no Concurrency plan table skips check 10
D=$(make_fixture docs-notable)
printf '# Execution plan\n\n## Concurrency plan\n\nProse only.\n' > "$D/execution-plan.md"
OUT=$(node "$CHECK" "$D" 2>&1)
case "$OUT" in *"living docs"*) echo "  FAIL: req-003 skip: check 10 ran without a table"; FAIL=$((FAIL+1));; *) echo "  PASS: req-003 skip: check 10 skipped without a table"; PASS=$((PASS+1));; esac

# req-004 AC-1: shared resource in one batch fails
D=$(make_fixture res-fail)
write_plan "$D" "$HEADER_RES" <<'MD'
| U1-a | none | `src/a.txt` | 1 | | port:4321 |
| U2-b | none | `src/b.txt` | 1 | | `port:4321` |
| U3-docs | none | `docs/x.md` | 1 | | none |
MD
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "1" "$RC" "req-004 AC-1: shared resource exits 1"
assert_contains "U1-a" "$OUT" "req-004 AC-1: finding names the first unit"
assert_contains "U2-b" "$OUT" "req-004 AC-1: finding names the second unit"
assert_contains "port:4321" "$OUT" "req-004 AC-1: finding names the resource"

# req-004: the same resource in different batches passes
D=$(make_fixture res-batches)
write_plan "$D" "$HEADER_RES" <<'MD'
| U1-a | none | `src/a.txt` | 1 | | port:4321 |
| U2-docs | none | `docs/x.md` | 1 | | |
| U3-c | U1-a | `src/c.txt` | 2 | Reuses the port after U1-a. | port:4321 |
MD
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "0" "$RC" "req-004: same resource in separate batches exits 0"

# req-004 AC-2: older plan without the column passes
D=$(make_fixture res-old)
write_plan "$D" "$HEADER" <<'MD'
| U1-a | none | `src/a.txt` | 1 | |
| U2-docs | none | `docs/x.md` | 1 | |
MD
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "0" "$RC" "req-004 AC-2: plan without the column exits 0"
case "$OUT" in *"shared resource"*) echo "  FAIL: req-004 AC-2: finding for a missing column"; FAIL=$((FAIL+1));; *) echo "  PASS: req-004 AC-2: no shared resource finding"; PASS=$((PASS+1));; esac

# req-001 check 3: ADR references resolve against docs/adr
D=$(make_fixture adr-ref)
mkdir -p "$D/../../docs/adr" "$D/requirements"
printf 'x\n' > "$D/../../docs/adr/0007-shipped.md"
printf '# Design\n## Scope\nSee ADR-007 and ADR-0007 and ADR-0008.\n' > "$D/design.md"
OUT=$(node "$CHECK" "$D" 2>&1); RC=$?
assert_equals "1" "$RC" "check 3: unresolved ADR-0008 exits 1"
assert_contains "ADR-0008" "$OUT" "check 3: finding names ADR-0008"
case "$OUT" in *"ADR-007 "*|*"ADR-0007 "*) echo "  FAIL: check 3: docs/adr reference flagged"; FAIL=$((FAIL+1));; *) echo "  PASS: check 3: ADR-007 and ADR-0007 resolve in docs/adr"; PASS=$((PASS+1));; esac

# NFR: under 2 s on a 50-file plan
D=$(make_fixture perf)
mkdir -p "$D/requirements"
for i in $(seq 1 25); do
  n=$(printf '%03d' "$i")
  printf '# R\n**Source:** US-%s\n\n## Acceptance Criteria\n- [ ] AC-1: x\n  - Given a\n  - When b\n  - Then c\n' "$n" > "$D/requirements/req-$n-x.md"
  write_adr "$D" "ADR-$n-x.md" 'Oldest shell: Bash 3.2'
  printf '| REQ-%s | US-%s |\n' "$n" "$n" >> "$D/rows.txt"
done
rm -f "$D/rows.txt"
START=$(node -e 'console.log(Date.now())')
node "$CHECK" "$D" >/dev/null 2>&1
END=$(node -e 'console.log(Date.now())')
ELAPSED=$((END - START))
if [ "$ELAPSED" -lt 2000 ]; then
  echo "  PASS: NFR: 50-file plan checked in ${ELAPSED} ms"; PASS=$((PASS+1))
else
  echo "  FAIL: NFR: 50-file plan took ${ELAPSED} ms"; FAIL=$((FAIL+1))
fi

print_summary
