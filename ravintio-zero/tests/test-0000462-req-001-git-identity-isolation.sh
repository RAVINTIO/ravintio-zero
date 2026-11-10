#!/usr/bin/env bash
# Tests for feature 0000462-tests-without-git-identity, req-001: the runners
# give each suite a git environment that refuses to guess an identity (ADR-0301).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ISO="$SCRIPT_DIR/helpers/git-isolation.sh"
RUN_SH="$SCRIPT_DIR/run-tests.sh"
RUN_PS="$SCRIPT_DIR/run-tests.ps1"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "=== REQ-001 AC-1: a commit with no identity fails, and one with an identity succeeds ==="
if [ -f "$ISO" ]; then
  (
    # shellcheck disable=SC1090
    source "$ISO"
    export HOME="$TMP/home"
    mkdir -p "$HOME"
    printf '[user]\n\tname = developer\n\temail = developer@example.com\n' > "$HOME/.gitconfig"
    export GIT_AUTHOR_NAME=leak GIT_AUTHOR_EMAIL=leak@example.com EMAIL=leak@example.com
    isolate_git_env
    git init -q "$TMP/repo" >/dev/null 2>&1
    echo "ok" > "$TMP/repo/f"
    git -C "$TMP/repo" add f
    git -C "$TMP/repo" -c commit.gpgsign=false -c core.hooksPath=/dev/null commit -q -m one >/dev/null 2>&1
    echo "bare=$?" > "$TMP/result"
    git -C "$TMP/repo" -c user.name=t -c user.email=t@example.com -c commit.gpgsign=false -c core.hooksPath=/dev/null commit -q -m two >/dev/null 2>&1
    echo "named=$?" >> "$TMP/result"
  )
  assert_equals "bare=128" "$(sed -n 1p "$TMP/result" 2>/dev/null)" "REQ-001 AC-1: a commit with no identity fails"
  assert_equals "named=0" "$(sed -n 2p "$TMP/result" 2>/dev/null)" "REQ-001 AC-1: a commit with an explicit identity succeeds"
else
  assert_equals "present" "missing" "REQ-001 AC-1: helpers/git-isolation.sh exists"
fi

echo ""
echo "=== REQ-001 AC-2: both runners isolate before they run a suite ==="
assert_contains "isolate_git_env" "$(cat "$RUN_SH")" "REQ-001 AC-2: run-tests.sh calls isolate_git_env"
for v in GIT_CONFIG_GLOBAL GIT_CONFIG_NOSYSTEM useConfigOnly; do
  assert_contains "$v" "$(cat "$RUN_PS")" "REQ-001 AC-2: run-tests.ps1 sets $v"
done

echo ""
echo "=== REQ-001 AC-2: a suite that the runner starts sees the isolated config ==="
if [ -n "${GIT_ISOLATION_CONFIG:-}" ]; then
  assert_equals "$GIT_ISOLATION_CONFIG" "${GIT_CONFIG_GLOBAL:-}" "REQ-001 AC-2: GIT_CONFIG_GLOBAL is the isolation file"
  assert_equals "true" "$(git config --global --get user.useConfigOnly)" "REQ-001 AC-2: git refuses to guess an identity"
  assert_equals "1" "${GIT_CONFIG_NOSYSTEM:-}" "REQ-001 AC-2: the system config is hidden"
else
  echo "  SKIP: run this suite through run-tests.sh to check the runner environment"
fi

echo ""
echo "=== REQ-001 AC-3: the PR #136 defect fails under isolation ==="
FN="$(sed -n '/^commit_workspace_pack()/,/^}/p' "$SCRIPT_DIR/helpers/assert.sh")"
BROKEN="$(printf '%s\n' "$FN" | sed -e 's/-c user.email=test@example.com -c user.name=test //' -e 's/^commit_workspace_pack()/broken_commit_workspace_pack()/')"
if [ -f "$ISO" ]; then
  (
    source "$ISO"
    isolate_git_env
    eval "$BROKEN"
    mkdir -p "$TMP/ws-broken" "$TMP/ws-ok"
    echo x > "$TMP/ws-broken/f"; echo x > "$TMP/ws-ok/f"
    broken_commit_workspace_pack "$TMP/ws-broken"
    commit_workspace_pack "$TMP/ws-ok"
    git -C "$TMP/ws-broken" rev-parse -q --verify HEAD >/dev/null 2>&1; echo "broken=$?" > "$TMP/r3"
    git -C "$TMP/ws-ok" rev-parse -q --verify HEAD >/dev/null 2>&1; echo "ok=$?" >> "$TMP/r3"
  )
  assert_equals "broken=1" "$(sed -n 1p "$TMP/r3" 2>/dev/null)" "REQ-001 AC-3: the function without identity flags makes no commit"
  assert_equals "ok=0" "$(sed -n 2p "$TMP/r3" 2>/dev/null)" "REQ-001 AC-3: the shipped function makes a commit"
else
  assert_equals "present" "missing" "REQ-001 AC-3: helpers/git-isolation.sh exists"
fi

print_summary
