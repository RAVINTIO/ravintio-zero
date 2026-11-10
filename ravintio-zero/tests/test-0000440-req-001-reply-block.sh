#!/usr/bin/env bash
# Tests for feature 0000440-driver-reads-reply-blocks, req-001: the driver stops on a Blocked: or
# Question: line in the final reply of a step session, and the continue prompt skips a missing log.
#
# A stub claude on PATH stands in for the model. STUB_MODE reply prints a result event that holds
# a Blocked: line and writes no build log. prefixed writes a prefixed Blocked: line to the build
# log. nolog removes the build log and ends its turn, and the resume finishes the step.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG"
RM=plan/current-initiative/initiative.md
resumed=no
case " $* " in *" --resume "*) resumed=yes ;; esac
finish() {
  mkdir -p plan/_archive
  mv plan/current-initiative "plan/_archive/0000050-demo-initiative-2026-10-23"
}
printf '{"type":"system","session_id":"sess-abc12345"}\n'
case "${STUB_MODE}" in
  reply)
    rm -f plan/current/build-log.md
    printf '{"type":"result","result":"13:41 I-D Advance: Blocked: CI failed on PR $(touch pwned)"}\n' ;;
  badreply)
    printf 'not json\n{"type":"result","result":42}\n{"type":"result"}\n' ;;
  resolvedreply)
    if [ "$resumed" = yes ]; then finish; exit 0; fi
    printf '{"type":"result","result":"I-D Advance: Blocked: CI failed\\nResolved: fixed"}\n' ;;
  prefixed) printf 'I-D Advance: Blocked: CI failed\n' >> plan/current/build-log.md ;;
  nolog)
    if [ "$resumed" = yes ]; then finish; exit 0; fi
    rm -f plan/current/build-log.md ;;
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
echo "=== req-001 AC-1: a Blocked: line in the reply stops the driver with no resume ==="
R="$(make_fixture reply)"
run_driver "$R" reply
assert_equals "1" "$CODE" "AC-1: driver exits 1"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-1: the step ran once and was not resumed"
assert_contains "I-C Run: Blocked: step 1 stopped." "$OUT" "AC-1: prints the stop line"
assert_contains "I-D Advance: Blocked: CI failed on PR" "$OUT" "AC-1: the stop line repeats the block"
assert_equals "no" "$([ -e "$R/pwned" ] && echo yes || echo no)" "AC-1: reply text ran nothing"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "AC-1: lock released"

echo ""
echo "=== req-001 AC-1: a bad or empty reply adds no block ==="
R="$(make_fixture badreply)"
run_driver "$R" badreply
assert_not_contains "stopped." "$OUT" "AC-1: no block from a malformed result event"

echo ""
echo "=== req-001 AC-1: a Resolved: line in the reply clears the block ==="
R="$(make_fixture resolvedreply)"
run_driver "$R" resolvedreply
assert_equals "0" "$CODE" "AC-1: driver exits 0"
assert_contains "Resuming: step 1" "$OUT" "AC-1: the driver resumed"

echo ""
echo "=== req-001 AC-2: a prefixed Blocked: line in the build log counts ==="
R="$(make_fixture prefixed)"
run_driver "$R" prefixed
assert_equals "1" "$CODE" "AC-2: driver exits 1"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "AC-2: no resume"
assert_contains "I-D Advance: Blocked: CI failed" "$OUT" "AC-2: the stop line repeats the block"

echo ""
echo "=== req-001 AC-3: the continue prompt skips a missing build log ==="
R="$(make_fixture nolog)"
run_driver "$R" nolog
assert_equals "0" "$CODE" "AC-3: driver exits 0"
PROMPT="$(grep -- '--resume' "$R/stub.log")"
assert_not_contains "Read plan/current/build-log.md" "$PROMPT" "AC-3: the prompt omits the missing path"
assert_contains "no build log" "$PROMPT" "AC-3: the prompt says none exists"
assert_contains "Question:" "$PROMPT" "AC-3: the prompt still names Question:"

print_summary
