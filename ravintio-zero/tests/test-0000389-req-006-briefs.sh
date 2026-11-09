#!/usr/bin/env bash
# Tests for feature 0000389-writing-standard, req-006 and req-005 AC-2: briefs name the standard.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
DISPATCH="$SCRIPT_DIR/../standards/agent-dispatch-standards.md"
REFRESH="$SCRIPT_DIR/../skills/ravintio-refresh-setup/SKILL.md"
STD="ravintio-zero/standards/writing-standards.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "=== req-006 AC-1: dispatch template names the standard ==="
SKEL="$(grep -n 'prompt: "Requirement:' "$DISPATCH")"
assert_equals "2" "$(printf '%s\n' "$SKEL" | grep -c "$STD")" "req-006 AC-1: both skeleton prompts name the standard"
RULE="$(grep '^\*\*Self-contained prompt rule' "$DISPATCH")"
assert_contains "$STD" "$RULE" "req-006 AC-1: the prompt rule names the standard"

echo ""
echo "=== req-006 AC-2: driver names the standard ==="
mkdir -p "$WORK/bin" "$WORK/r/plan/current-initiative" "$WORK/r/plan/current"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG"
printf '{"type":"assistant","message":{"content":[{"type":"text","text":"SECRET-MARKER-7731"}]}}\n'
RM=plan/current-initiative/initiative.md
mkdir -p plan/_archive
mv plan/current-initiative "plan/_archive/0000050-demo-initiative-2026-10-23"
STUB
chmod +x "$WORK/bin/claude"
cat > "$WORK/r/plan/current-initiative/initiative.md" <<'EOF2'
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
: > "$WORK/r/plan/current/build-log.md"

OUT="$(cd "$WORK/r" && PATH="$WORK/bin:$PATH" STUB_LOG="$WORK/r/stub.log" node "$DRIVER" --root "$WORK/r" 2>&1)"
CODE=$?


assert_exit_zero "$CODE" "req-006 AC-2: driver exits 0"
ARGS="$(cat "$WORK/r/stub.log")"
assert_contains "--append-system-prompt" "$ARGS" "req-006 AC-2: claude gets --append-system-prompt"
assert_contains "$STD" "$ARGS" "req-006 AC-2: the appended line names the standard"
assert_contains "Run initiative step 1" "$ARGS" "req-006 AC-2: the step prompt is unchanged"

echo ""
echo "=== req-005 AC-2: refresh keeps the flag ==="
SKILL="$(cat "$REFRESH")"
assert_contains "--strict-orchestrator\` and \`--no-writing-style" "$SKILL" "req-005 AC-2: allowed set holds --no-writing-style"
assert_contains "lists \`--no-writing-style\`" "$SKILL" "req-005 AC-2: a signal row maps the flag"

print_summary
