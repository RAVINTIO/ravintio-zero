#!/usr/bin/env bash
# Tests for feature 0000377-driver-stops-and-headroom, req-002: the driver and the watcher stop
# on an open Question: line, and the continue prompt names Question:.
#
# A stub claude on PATH stands in for the model. STUB_MODE question writes a Question: line to the
# build log and ends its turn. resolved writes the Question: line, then a Resolved: line.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WATCH="$SCRIPT_DIR/../scripts/initiative-watch.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG"
RM=plan/current-initiative/initiative.md
POSRE='^((\*\*)?[Pp]osition:?(\*\*)? *:? *)'
pos="$(sed -nE "s/${POSRE}//p" "$RM")"
resumed=no
case " $* " in *" --resume "*) resumed=yes ;; esac
finish() {
  printf 'I-C Run: step %s done\n' "$pos" >> plan/current/build-log.md
  mkdir -p plan/_archive
  mv plan/current-initiative "plan/_archive/0000050-demo-initiative-2026-10-23"
}
printf '{"type":"system","session_id":"sess-abc12345"}\n'
case "${STUB_MODE}" in
  question) printf 'P0 Discovery: Question: Which product id?\n' >> plan/current/build-log.md ;;
  resolved)
    if [ "$resumed" = yes ]; then finish; exit 0; fi
    printf 'P0 Discovery: Question: Which product id?\nResolved: use ravintio-zero\n' >> plan/current/build-log.md ;;
esac
exit 0
STUB
chmod +x "$WORK/bin/claude"

make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current"
  cat > "$d/plan/current-initiative/initiative.md" <<EOF2
---
title: "Initiative: demo"
summary: "One step."
status: active
---
# Initiative: demo

goal: demo
branch: initiative/0000050-demo
status: active
position: 1

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000051-a | 0000011 | minor | | pending |
EOF2
  : > "$d/plan/current/build-log.md"
  printf '%s' "$d"
}

run_driver() {
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_LOG="$1/stub.log" STUB_MODE="$2" \
    node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}

echo ""
echo "=== req-002 AC-4: an open Question: line stops the driver with no resume ==="
R="$(make_fixture question)"
run_driver "$R" question
assert_equals "1" "$CODE" "AC-4: driver exits 1"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-4: the step ran once and was not resumed"
assert_contains "Which product id?" "$OUT" "AC-4: the stop line repeats the question"
assert_not_contains "Resuming" "$OUT" "AC-4: no resume line"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "AC-4: lock released"

echo ""
echo "=== req-002 AC-5: a Resolved: line clears the question ==="
R="$(make_fixture resolved)"
run_driver "$R" resolved
assert_equals "0" "$CODE" "AC-5: driver exits 0"
assert_contains "Resuming: step 1" "$OUT" "AC-5: the driver resumed"

echo ""
echo "=== req-002 AC-6: the continue prompt and the watcher name Question: ==="
assert_contains "Question:" "$(grep 'const CONTINUE_PROMPT' "$DRIVER")" "AC-6: the continue prompt names Question:"
assert_contains "Question:" "$(grep -A4 '^function eventLine' "$WATCH")" "AC-6: the watcher reports Question: lines"

print_summary
