#!/usr/bin/env bash
# Tests for feature 0000382-install-lifecycle, req-006: the generated pack facts file.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FACTS="$ZERO_DIR/pack-facts.json"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "=== AC-1: every flag setup.sh and setup.ps1 accept is listed ==="
sh_flags="$(sed -n '/^while \[\[ \$# -gt 0 \]\]/,/^done/p' "$ZERO_DIR/setup.sh" | grep -oE -- '--[a-z][a-z-]*' | sort -u | grep -vE -- '--(structured-telemetry-mcp|context-mode-mcp|include-full-skill-library|backend-url)')"
ps_flags="$(sed -n '/^while (\$i -lt/,/^\$ErrorActionPreference/p' "$ZERO_DIR/setup.ps1" | grep -oE -- "'--[a-z][a-z-]*'" | tr -d "'" | sort -u | grep -vE -- '--(structured-telemetry-mcp|context-mode-mcp|include-full-skill-library|backend-url)')"
listed="$(node -e 'const f=JSON.parse(require("fs").readFileSync(process.argv[1]));console.log(f.setupFlags.map(x=>x.flag).join(" "))' "$FACTS")"
missing=""
for f in $sh_flags; do case " $listed " in *"$f"*) ;; *) missing="$missing $f" ;; esac; done
assert_equals "" "$missing" "setup.sh flags are all in the facts file"
missing=""
for f in $ps_flags; do case "$listed" in *"$f"*) ;; *) missing="$missing $f" ;; esac; done
assert_equals "" "$missing" "setup.ps1 flags are all in the facts file"

echo "=== AC-2: every hook setup wires is listed ==="
ws="$TMP/ws"; mkdir -p "$ws"; cp -r "$ZERO_DIR" "$ws/ravintio-zero"; git init -q "$ws"
commit_workspace_pack "$ws"
(cd "$ws" && GIT_CEILING_DIRECTORIES="$TMP" bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
wired="$(node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1]));const o=new Set();for(const es of Object.values(s.hooks))for(const e of es)for(const h of e.hooks){const m=/guard-run\.mjs"?\s+\w+\s+([a-z-]+)\.mjs/.exec(h.command);if(m)o.add(m[1])}console.log([...o].sort().join(" "))' "$ws/.claude/settings.json")"
inFacts="$(node -e 'const f=JSON.parse(require("fs").readFileSync(process.argv[1]));console.log([...new Set(f.hooks.map(h=>h.module))].sort().join(" "))' "$FACTS")"
assert_equals "$wired" "$inFacts" "the facts file lists the hooks setup wires"
assert_contains "commit-msg" "$(cat "$FACTS")" "the facts file lists the git hooks"
assert_contains "ravintio-orchestrator" "$(cat "$FACTS")" "the facts file lists the skills"
assert_contains "P4 Ship" "$(cat "$FACTS")" "the facts file lists the phases"

echo "=== AC-3: a stale file fails the check ==="
node "$ZERO_DIR/scripts/pack-facts.mjs" --check >/dev/null 2>&1; rc=$?
assert_equals "0" "$rc" "the committed file is current"
cp -r "$ZERO_DIR" "$TMP/copy"
echo '{}' > "$TMP/copy/pack-facts.json"
node "$TMP/copy/scripts/pack-facts.mjs" --check >/dev/null 2>"$TMP/err"; rc=$?
assert_equals "1" "$rc" "a stale file exits 1"
assert_contains "stale" "$(cat "$TMP/err")" "the error says the file is stale"

echo "=== CI runs the check ==="
assert_contains "pack-facts.mjs --check" "$(cat "$ZERO_DIR/hooks/ravintio.yml")" "the workflow runs the check"

print_summary
