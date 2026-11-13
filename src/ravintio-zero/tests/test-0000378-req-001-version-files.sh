#!/usr/bin/env bash
# Tests for feature 0000378-merge-time-versioning, req-001: one list of version files that
# `version-files.mjs check` and `set` both read. Each case builds a fixture repo in a temp dir.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/version-files.mjs"
LIST_REAL="$SCRIPT_DIR/../version-files.txt"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# make_fixture NAME ABOUT PRODUCT COMPONENT
make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/docs" "$d/ravintio-zero"
  cat > "$d/docs/about.md" <<EOF2
---
version: "$2"
feature: "0000001-demo"
---
# About

| Field | Value |
|-------|-------|
| Version | \`$2\` |
| Last feature | \`0000001-demo\` |
EOF2
  printf '# product\nid: demo\nversion: "%s"\nversionPolicy: "explicit"\n' "$3" > "$d/product.yml"
  printf '# component\nid: demo\nname: Demo\nversion: "%s"\nowner: me\n' "$4" > "$d/ravintio-zero/component.yml"
  printf '# version files\ndocs/about.md\nproduct.yml\n\nravintio-zero/component.yml\n' > "$d/list.txt"
}

run() { OUT="$(node "$TOOL" "$@" 2>&1)"; CODE=$?; }

# The shipped list
assert_equals "docs/about.md
product.yml
ravintio-zero/component.yml
? src/ravintio-zero/component.yml" "$(grep -v '^#' "$LIST_REAL" | grep -v '^$')" "REQ-001: shipped list holds the three version files and the optional pack source copy (0000420)"

# AC-1
make_fixture ac1 0.58.0 0.58.0 0.58.0
run check --root "$WORK/ac1" --list "$WORK/ac1/list.txt"
assert_equals "0" "$CODE" "REQ-001 AC-1: check passes on matching files"

# AC-2
make_fixture ac2 0.58.0 0.58.0 0.57.0
run check --root "$WORK/ac2" --list "$WORK/ac2/list.txt"
assert_equals "1" "$CODE" "REQ-001 AC-2: check exits 1 on a differing file"
assert_contains "ravintio-zero/component.yml" "$OUT" "REQ-001 AC-2: check names the differing file"

# AC-3
make_fixture ac3 0.57.0 0.57.0 0.57.0
run set 0.58.0 --root "$WORK/ac3" --list "$WORK/ac3/list.txt"
assert_equals "0" "$CODE" "REQ-001 AC-3: set exits 0"
run check --root "$WORK/ac3" --list "$WORK/ac3/list.txt"
assert_equals "0" "$CODE" "REQ-001 AC-3: files agree after set"
assert_contains 'version: "0.58.0"' "$(cat "$WORK/ac3/product.yml")" "REQ-001 AC-3: product.yml holds 0.58.0"
assert_contains 'version: "0.58.0"' "$(cat "$WORK/ac3/ravintio-zero/component.yml")" "REQ-001 AC-3: component.yml holds 0.58.0"
assert_contains 'version: "0.58.0"' "$(head -3 "$WORK/ac3/docs/about.md")" "REQ-001 AC-3: about.md front matter holds 0.58.0"
assert_contains '| Version | `0.58.0` |' "$(cat "$WORK/ac3/docs/about.md")" "REQ-001 AC-3: about.md table row holds 0.58.0"
assert_not_contains "0.57.0" "$(cat "$WORK/ac3"/docs/about.md "$WORK/ac3"/product.yml "$WORK/ac3"/ravintio-zero/component.yml)" "REQ-001 AC-3: no old version remains"

# set preserves the rest of each file
assert_contains 'feature: "0000001-demo"' "$(cat "$WORK/ac3/docs/about.md")" "REQ-001: set keeps other front matter"
assert_contains '| Last feature | `0000001-demo` |' "$(cat "$WORK/ac3/docs/about.md")" "REQ-001: set keeps other table rows"
assert_equals "# component
id: demo
name: Demo
version: \"0.58.0\"
owner: me" "$(cat "$WORK/ac3/ravintio-zero/component.yml")" "REQ-001: set keeps the rest of component.yml"

# Bad semver
make_fixture bad 0.57.0 0.57.0 0.57.0
run set 0.58 --root "$WORK/bad" --list "$WORK/bad/list.txt"
assert_equals "1" "$CODE" "REQ-001: set exits 1 on a bad semver"
assert_contains 'version: "0.57.0"' "$(cat "$WORK/bad/product.yml")" "REQ-001: bad semver leaves files unchanged"

# Path outside the root
make_fixture out 0.57.0 0.57.0 0.57.0
printf 'docs/about.md\n../outside.yml\n' > "$WORK/out/list.txt"
printf 'version: "0.57.0"\n' > "$WORK/outside.yml"
run check --root "$WORK/out" --list "$WORK/out/list.txt"
assert_equals "1" "$CODE" "REQ-001: check exits 1 for a path outside the root"
run set 0.58.0 --root "$WORK/out" --list "$WORK/out/list.txt"
assert_equals "1" "$CODE" "REQ-001: set exits 1 for a path outside the root"
assert_contains 'version: "0.57.0"' "$(cat "$WORK/outside.yml")" "REQ-001: the outside file is untouched"

print_summary
