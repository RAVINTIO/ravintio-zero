#!/usr/bin/env bash
# Tests for feature 0000466-version-files-completeness-check, req-001: the suite fails when
# version-files.txt omits a tracked file that carries the product version, or names a required
# file that does not exist. The check runs on the real repo and on fixture repos.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

LIST_REAL="$SCRIPT_DIR/../version-files.txt"
TOOL="$SCRIPT_DIR/../scripts/version-files.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# check_list ROOT LIST: print "omitted: {path}" for each tracked version-carrying file the list
# omits, and "missing: {path}" for each required entry whose file does not exist. Exit 1 on any.
check_list() {
  node --input-type=module - "$1" "$2" "$TOOL" <<'JS'
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

const [root, list, tool] = process.argv.slice(2);
const { readEntries } = await import(pathToFileURL(tool).href);
const tracked = execFileSync('git', ['ls-files', '-z'], { cwd: root, encoding: 'utf8' })
  .split('\0').filter(Boolean);
const own = (text) => {
  const lines = text.split(/\r?\n/);
  const end = lines[0] === '---' ? lines.indexOf('---', 1) : -1;
  for (let i = end < 0 ? 0 : 1; i < (end < 0 ? lines.length : end); i++) {
    const m = /^version:\s*["']?([^"'\s#]*)/.exec(lines[i]);
    if (m) return m[1];
  }
  return null;
};
const read = (p) => readFileSync(join(root, p), 'utf8');
const skipped = (p) => p.startsWith('plan/') || p.startsWith('docs/adr/') || p.split('/').includes('fixtures');
const productVersion = existsSync(join(root, 'product.yml')) ? own(read('product.yml')) : null;
const shaped = (p) => p === 'product.yml' || p === 'docs/about.md' || p.split('/').pop() === 'component.yml';
const candidates = tracked.filter((p) => {
  if (skipped(p)) return false;
  if (shaped(p)) return true;
  return /\.(md|ya?ml)$/.test(p) && productVersion !== null && own(read(p)) === productVersion;
});
const entries = readEntries(list);
const listed = new Set(entries.map((e) => e.path));
let bad = false;
for (const p of candidates) if (!listed.has(p)) { console.log(`omitted: ${p}`); bad = true; }
for (const e of entries) if (!e.optional && !existsSync(join(root, e.path))) { console.log(`missing: ${e.path}`); bad = true; }
process.exit(bad ? 1 : 0);
JS
}

run() { OUT="$(check_list "$@" 2>&1)"; CODE=$?; }

# track DIR PATH: put one file in the index of the fixture repo. The fixture makes no commit.
track() { git -C "$1" update-index --add -- "$2"; }

# make_fixture NAME: a git repo with product.yml, docs/about.md, and a component.yml, all tracked.
make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/docs" "$d/pack"
  printf 'id: demo\nversion: "0.1.0"\n' > "$d/product.yml"
  printf -- '---\nversion: "0.1.0"\n---\n# About\n' > "$d/docs/about.md"
  printf 'id: pack\nversion: "0.1.0"\n' > "$d/pack/component.yml"
  printf 'product.yml\ndocs/about.md\npack/component.yml\n' > "$d/list.txt"
  git -C "$d" init -q
  track "$d" product.yml
  track "$d" docs/about.md
  track "$d" pack/component.yml
}

# AC-1: the real repo passes.
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
run "$REPO_ROOT" "$LIST_REAL"
assert_equals "0" "$CODE" "REQ-001 AC-1: the shipped list names every version-carrying file ($OUT)"

# A complete fixture passes.
make_fixture ok
run "$WORK/ok" "$WORK/ok/list.txt"
assert_equals "0" "$CODE" "REQ-001: a complete fixture passes ($OUT)"

# AC-2: a component.yml that the list omits fails and is named.
make_fixture omit
mkdir -p "$WORK/omit/src/pack"
printf 'id: pack\nversion: "0.1.0"\n' > "$WORK/omit/src/pack/component.yml"
track "$WORK/omit" src/pack/component.yml
run "$WORK/omit" "$WORK/omit/list.txt"
assert_equals "1" "$CODE" "REQ-001 AC-2: an omitted component.yml fails"
assert_contains "omitted: src/pack/component.yml" "$OUT" "REQ-001 AC-2: the output names the omitted file"

# An optional entry counts as listed.
printf 'product.yml\ndocs/about.md\npack/component.yml\n? src/pack/component.yml\n' > "$WORK/omit/list.txt"
run "$WORK/omit" "$WORK/omit/list.txt"
assert_equals "0" "$CODE" "REQ-001: an optional entry counts as listed ($OUT)"

# A file of another shape that holds the product version fails. A file at another version passes.
make_fixture shape
printf -- '---\nversion: "0.1.0"\n---\n# Doc\n' > "$WORK/shape/guide.md"
printf -- '---\nversion: "0.0.9"\n---\n# Other\n' > "$WORK/shape/other.md"
track "$WORK/shape" guide.md
track "$WORK/shape" other.md
run "$WORK/shape" "$WORK/shape/list.txt"
assert_equals "1" "$CODE" "REQ-001: an unlisted file at the product version fails"
assert_contains "omitted: guide.md" "$OUT" "REQ-001: the output names guide.md"
assert_not_contains "other.md" "$OUT" "REQ-001: a file at another version passes"

# An untracked file does not count, and a file under plan/ does not count.
make_fixture skip
mkdir -p "$WORK/skip/plan"
printf 'version: "0.1.0"\n' > "$WORK/skip/untracked.yml"
printf -- '---\nversion: "0.1.0"\n---\n' > "$WORK/skip/plan/note.md"
track "$WORK/skip" plan/note.md
run "$WORK/skip" "$WORK/skip/list.txt"
assert_equals "0" "$CODE" "REQ-001: untracked files and plan/ files do not count ($OUT)"

# AC-3: a required entry whose file does not exist fails and is named.
make_fixture req
printf 'product.yml\ndocs/about.md\npack/component.yml\ngone/component.yml\n' > "$WORK/req/list.txt"
run "$WORK/req" "$WORK/req/list.txt"
assert_equals "1" "$CODE" "REQ-001 AC-3: a missing required entry fails"
assert_contains "missing: gone/component.yml" "$OUT" "REQ-001 AC-3: the output names the missing entry"

print_summary
