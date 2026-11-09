#!/usr/bin/env bash
# Tests for feature 0000354-steps-run-to-the-end, req-001: the driver resumes an unmerged step.
#
# A stub claude on PATH stands in for the model. In resume modes it prints a stream event with a
# session id, then exits 0 without moving the position, the way a step does when it ends its turn
# early. A call with --resume does the step's work.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
source "$SCRIPT_DIR/helpers/driver-args.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
# Stub claude. STUB_MODE: once (resume merges), never (resume never merges), nosession, fail, badid.
printf '%s\n' "$*" >> "$STUB_LOG"
RM=plan/current-initiative/initiative.md
POSRE='^((\*\*)?[Pp]osition:?(\*\*)? *:? *)'
pos="$(sed -nE "s/${POSRE}//p" "$RM")"
resumed=no
case " $* " in *" --resume "*) resumed=yes ;; esac
finish() {
  printf 'I-C Run: step %s done\n' "$pos" >> plan/current/build-log.md
  if [ "$pos" = 2 ]; then
    mkdir -p plan/_archive
    mv plan/current-initiative "plan/_archive/0000050-demo-initiative-2026-10-23"
  else
    sed -i.bak -E "s/${POSRE}.*/\\1$((pos + 1))/" "$RM" && rm -f "$RM.bak"
  fi
}
early() {
  printf '{"type":"system","subtype":"init","session_id":"%s"}\n' "$1"
  exit 0
}
case "${STUB_MODE:-once}" in
  fail) printf '{"session_id":"sess-abc12345"}\n'; exit 3 ;;
  nosession) exit 0 ;;
  badid) early '--bad id; touch pwned' ;;
  never) early sess-abc12345 ;;
  once)
    if [ "$resumed" = yes ]; then printf '{"type":"system","session_id":"sess-abc12345"}\n'; finish; exit 0; fi
    early sess-abc12345 ;;
esac
STUB
chmod +x "$WORK/bin/claude"

make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current"
  cat > "$d/plan/current-initiative/initiative.md" <<EOF2
---
title: "Initiative: demo"
summary: "Two steps."
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
| 2 | 0000052-b | 0000012 | minor | | pending |
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
echo "=== req-001 AC-1: a resume lets the step merge ==="
R="$(make_fixture once)"
run_driver "$R" once
assert_equals "0" "$CODE" "AC-1: driver exits 0 at delivery"
assert_equals "4" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-1: each of two steps ran once and resumed once"
assert_equals "$(driver_args sonnet "" Run initiative step 1)" "$(sed -n 1p "$R/stub.log")" "AC-1: first run uses the step prompt"
assert_contains "$(driver_args_prefix) --model sonnet --resume sess-abc12345 " "$(sed -n 2p "$R/stub.log")" "AC-1: the resume passes the session id after the same flags"
assert_contains "I-C Run: Resuming: step 1 ended its turn unmerged, resume 1 of 2" "$OUT" "AC-1: prints the resume line"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "AC-1: lock released"
assert_equals "2" "$(grep -c 'sess-abc12345' "$R/plan/.initiative-logs/step-1.log")" "AC-1: the resume writes to the same step log"

echo ""
echo "=== req-001 AC-2: the cap is two resumes ==="
R="$(make_fixture never)"
run_driver "$R" never
assert_equals "1" "$CODE" "AC-2: driver exits 1"
assert_equals "3" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-2: one run and two resumes"
assert_equals "2" "$(grep -c -- '--resume' "$R/stub.log")" "AC-2: two resume calls"
assert_contains "I-C Run: Resuming: step 1 ended its turn unmerged, resume 2 of 2" "$OUT" "AC-2: prints the second resume line"
assert_contains "I-C Run: Blocked: step 1 exited without merging after 2 resumes" "$OUT" "AC-2: prints Blocked: after the cap"
assert_contains "Log: plan/.initiative-logs/step-1.log" "$OUT" "AC-2: the stop line names the log"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "AC-2: lock released"

echo ""
echo "=== req-001 AC-3: no resume without a valid session id or after a failure ==="
R="$(make_fixture nosession)"
run_driver "$R" nosession
assert_equals "1" "$CODE" "AC-3 (no id): driver exits 1"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-3 (no id): no resume"
assert_contains "Blocked:" "$OUT" "AC-3 (no id): prints Blocked:"

R="$(make_fixture badid)"
run_driver "$R" badid
assert_equals "1" "$CODE" "AC-3 (bad id): driver exits 1"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-3 (bad id): no resume"
assert_equals "no" "$([ -e "$R/pwned" ] && echo yes || echo no)" "AC-3 (bad id): nothing ran from the id"

R="$(make_fixture fail)"
run_driver "$R" fail
assert_equals "1" "$CODE" "AC-3 (fail): driver exits 1"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-3 (fail): a non-zero exit never resumes"
assert_contains "claude exited 3 on step 1" "$OUT" "AC-3 (fail): names the exit"

print_summary
