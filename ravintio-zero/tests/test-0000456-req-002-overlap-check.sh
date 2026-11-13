#!/usr/bin/env bash
# Tests for feature 0000456-regenerate-shared-files-at-merge, req-002: the coordinator check names open step PRs
# that touch the same files. A fake `gh` answers `pr list` from a JSON file and records each call.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="${CPC_TOOL:-$SCRIPT_DIR/../scripts/coordinator-pr-check.mjs}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

R="$WORK/repo"
mkdir -p "$R/plan/backlog" "$R/src"
git init -q -b main "$R"
(
  cd "$R" || exit 1
  echo a > src/a.txt
  echo b > src/b.txt
  echo base > plan/backlog/index.md
  git add src plan && git commit -q -m base
  git checkout -q -b chore/coord
  echo a2 > src/a.txt
  echo idx2 > plan/backlog/index.md
  git add src plan && git commit -q -m coordinator
)
BASE_SHA="$(git -C "$R" rev-parse main)"

cat > "$WORK/gh" <<'SHIM'
#!/usr/bin/env bash
echo "$*" >> "$FAKE_GH_LOG"
cat "$FAKE_GH_JSON"
SHIM
chmod +x "$WORK/gh"
export FAKE_GH_LOG="$WORK/gh.log" FAKE_GH_JSON="$WORK/prs.json"

run_check() {
  OUT="$(cd "$R" && GH_BIN="$WORK/gh" node "$TOOL" "$BASE_SHA" --root "$R" "$@" 2>&1)"
  CODE=$?
}

# ---------------------------------------------------------------- AC-1: overlap found
: > "$FAKE_GH_LOG"
cat > "$FAKE_GH_JSON" <<'JSON'
[{"number":7,"headRefName":"feat/step","files":[{"path":"src/a.txt"},{"path":"src/other.txt"}]},
 {"number":8,"headRefName":"chore/coord","files":[{"path":"src/a.txt"}]},
 {"number":9,"headRefName":"docs/other","files":[{"path":"src/a.txt"}]}]
JSON
run_check --base initiative/x
assert_equals "1" "$CODE" "AC-1: an overlap exits 1"
assert_contains "overlap: #7 src/a.txt" "$OUT" "AC-1: the output names the PR and the file"
assert_not_contains "#8" "$OUT" "AC-1: the check skips the current branch"
assert_not_contains "#9" "$OUT" "AC-1: the check skips a PR whose head is not feat/"
assert_contains "pr list --base initiative/x --state open --json number,headRefName,files" "$(cat "$FAKE_GH_LOG")" "AC-1: the check lists open PRs for the base"

# ---------------------------------------------------------------- AC-2: shared files ignored
cat > "$FAKE_GH_JSON" <<'JSON'
[{"number":7,"headRefName":"feat/step","files":[{"path":"plan/backlog/index.md"}]}]
JSON
run_check --base initiative/x
assert_equals "0" "$CODE" "AC-2: a PR that changes only a shared file is no overlap ($OUT)"
assert_not_contains "overlap" "$OUT" "AC-2: the check prints no overlap line"

# ---------------------------------------------------------------- AC-3: no base flag
: > "$FAKE_GH_LOG"
run_check
assert_equals "0" "$CODE" "AC-3: a run without --base exits 0"
assert_contains "full-suite" "$OUT" "AC-3: the output is as before"
assert_equals "0" "$(wc -l < "$FAKE_GH_LOG" | tr -d ' ')" "AC-3: the check makes no gh call"

print_summary
