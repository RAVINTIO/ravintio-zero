#!/usr/bin/env bash
# Tests for feature 0000450-coordinator-status-view, req-001.
#
# initiative-status.mjs prints the queue counts, ready PRs, running steps, and live stops.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STATUS="$SCRIPT_DIR/../scripts/initiative-status.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# make_repo <name> <position> <status...>: a chart with one step per status word, steps 1..n.
make_repo() {
  local d="$WORK/$1" pos="$2" n=0 s; shift 2
  mkdir -p "$d/plan/current-initiative" "$d/plan/.initiative-control" "$d/plan/.initiative-logs"
  {
    printf -- '---\nstatus: active\nposition: %s\n---\n# Initiative\n\n## Steps\n\n' "$pos"
    printf '| Step | Feature id | Title | Bump | Version | Status |\n|---|---|---|---|---|---|\n'
    for s in "$@"; do
      n=$((n + 1))
      printf '| %s | %07d-feat-%s | Title %s | minor | 1.%s.0 | %s |\n' "$n" "$n" "$n" "$n" "$n" "$s"
    done
  } > "$d/plan/current-initiative/initiative.md"
  echo "$d"
}

control() { mkdir -p "$1/plan/.initiative-control/step-$2"; printf '%s\n' "${4:-}" > "$1/plan/.initiative-control/step-$2/$3"; }
wt_log() { mkdir -p "$1/plan/.initiative-worktrees/step-$2/plan/current"; printf '%s\n' "$3" >> "$1/plan/.initiative-worktrees/step-$2/plan/current/build-log.md"; }

run() { local root="$1"; shift; OUT="$(node "$STATUS" --root "$root" "$@" 2>&1)"; CODE=$?; }

echo ""
echo "=== AC-1: the view lists each step state ==="
R="$(make_repo a 2 merged merged ready running pending pending)"
control "$R" 3 ready 77
control "$R" 4 running
: > "$R/plan/.initiative-runner.lock"
run "$R"
assert_exit_zero "$CODE" "AC-1: exits 0"
assert_contains "I-C Run: status: driver running" "$OUT" "AC-1: driver line"
assert_contains "I-C Run: status: merged 2, ready 1, running 1, pending 2 of 6" "$OUT" "AC-1: counts line"
assert_contains "I-C Run: status: ready step 3 PR #77" "$OUT" "AC-1: ready line"
assert_contains "I-C Run: status: running step 4" "$OUT" "AC-1: running line"
assert_contains "I-C Run: status: no live stops" "$OUT" "AC-1: no stops"
rm "$R/plan/.initiative-runner.lock"
run "$R"
assert_contains "I-C Run: status: driver stopped" "$OUT" "AC-1: no lock reads as stopped"
assert_equals "" "$(find "$R" -newer "$R/plan/current-initiative/initiative.md" -type f -name '*.tmp')" "AC-1: writes no file"

echo ""
echo "=== AC-1b: a merged step wins over a control file ==="
R="$(make_repo b 2 merged merged pending)"
control "$R" 1 ready 5
control "$R" 2 running
run "$R"
assert_contains "merged 2, ready 0, running 0, pending 1 of 3" "$OUT" "merged wins: counts"
assert_not_contains "ready step 1" "$OUT" "merged wins: no ready line"
assert_not_contains "running step 2" "$OUT" "merged wins: no running line"

echo ""
echo "=== AC-2: a merged step shows no stop ==="
R="$(make_repo c 3 merged running pending)"
printf '10:00 I-D Advance: Blocked: queue stopped on step 1\n' > "$R/plan/.initiative-logs/step-1.log"
wt_log "$R" 1 "P2 Implement: Blocked: old problem"
control "$R" 2 running
run "$R"
assert_contains "I-C Run: status: no live stops" "$OUT" "AC-2: no live stops"
assert_not_contains "stop step 1" "$OUT" "AC-2: no stop line for merged step"

echo ""
echo "=== AC-3: a live stop shows with its reason ==="
R="$(make_repo d 3 merged running pending)"
control "$R" 2 running
wt_log "$R" 2 "10:01 P2 Implement: Blocked: tests fail 5 times"
run "$R"
assert_contains "I-C Run: status: stop step 2: " "$OUT" "AC-3: stop line"
assert_contains "tests fail 5 times" "$OUT" "AC-3: reason text"
assert_not_contains "no live stops" "$OUT" "AC-3: not none"

wt_log "$R" 2 "10:05 P2 Implement: Resolved: fixed"
run "$R"
assert_contains "no live stops" "$OUT" "a later Resolved clears the stop"

wt_log "$R" 2 "10:06 P3 Validate: Question: which version?"
run "$R"
assert_contains "stop step 2: " "$OUT" "an open Question is a stop"
assert_contains "which version?" "$OUT" "Question text shown"

echo ""
echo "=== Stops from the step log and the main build log ==="
R="$(make_repo e 2 merged running pending)"
control "$R" 2 running
printf 'noise line\n09:59 I-D Advance: Blocked: queue stopped on step 2\n{"type":"x"}\n' > "$R/plan/.initiative-logs/step-2.log"
run "$R"
assert_contains "stop step 2: I-D Advance: Blocked: queue stopped on step 2" "$OUT" "step log stop shown"
assert_not_contains "noise line" "$OUT" "other log content never printed"
assert_not_contains '"type"' "$OUT" "JSON log content never printed"

R="$(make_repo f 2 merged running pending)"
mkdir -p "$R/plan/current"
printf 'P2 Implement: Blocked: main log stop\n' > "$R/plan/current/build-log.md"
run "$R"
assert_contains "stop step 2: " "$OUT" "main build log counts for the position step"
assert_contains "main log stop" "$OUT" "main build log text shown"

echo ""
echo "=== A stop line is cut to 200 characters ==="
R="$(make_repo g 1 running)"
control "$R" 1 running
LONG="$(printf 'x%.0s' $(seq 1 400))"
wt_log "$R" 1 "P2 Implement: Blocked: $LONG"
run "$R"
LINE="$(printf '%s\n' "$OUT" | grep 'stop step 1')"
STOP_TEXT="${LINE#*stop step 1: }"
assert_equals "200" "${#STOP_TEXT}" "stop text is 200 characters"

echo ""
echo "=== Refusals ==="
R="$(make_repo h 1 running)"
mkdir -p "$WORK/elsewhere"
rm -rf "$R/plan/.initiative-control"
ln -s "$WORK/elsewhere" "$R/plan/.initiative-control"
run "$R"
assert_equals "1" "$CODE" "symlinked control dir exits 1"
assert_contains "Blocked: refused a symlinked plan path" "$OUT" "symlink Blocked line"

run "$R" --bogus
assert_equals "1" "$CODE" "bad argument exits 1"
assert_contains "I-C Run: Blocked:" "$OUT" "bad argument Blocked line"

run "$WORK/does-not-exist"
assert_equals "1" "$CODE" "missing initiative exits 1"
assert_contains "Blocked:" "$OUT" "missing initiative Blocked line"

echo ""
echo "=== Timing: 60 steps in under 2 seconds ==="
ST=(); for i in $(seq 1 60); do if [ "$i" -le 30 ]; then ST+=(merged); elif [ "$i" -le 40 ]; then ST+=(running); else ST+=(pending); fi; done
R="$(make_repo t 31 "${ST[@]}")"
for i in $(seq 31 40); do control "$R" "$i" running; wt_log "$R" "$i" "P2 Implement: Blocked: stop $i"; done
START=$(date +%s)
run "$R"
END=$(date +%s)
assert_exit_zero "$CODE" "60-step chart exits 0"
assert_contains "merged 30, ready 0, running 10, pending 20 of 60" "$OUT" "60-step counts"
[ $((END - START)) -lt 2 ] && assert_equals "ok" "ok" "runs in under 2 seconds" || assert_equals "<2s" "$((END - START))s" "runs in under 2 seconds"

print_summary
