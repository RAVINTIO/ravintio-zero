#!/usr/bin/env bash
# Tests for feature 0000391-standards-archetypes, req-005: four starter archetypes.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCH="$ROOT/archetypes"
PROTECTED="$ARCH/protected.json"

# Prints the value of a JS expression over the parsed manifest $1 (variable m).
jsval() { node -e 'const m=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));const v=eval(process.argv[2]);console.log(typeof v==="object"?JSON.stringify(v):String(v))' "$1" "$2" 2>/dev/null; }

echo "=== req-005: README names all four ==="
for n in us-writing restricted-stack language-standards strict-testing; do
  assert_equals "yes" "$([ -f "$ARCH/README.md" ] && grep -q "$n" "$ARCH/README.md" && echo yes || echo no)" "README names $n"
done

echo "=== req-005: manifests ==="
MANIFESTS="$(find "$ARCH" -name archetype.json 2>/dev/null | LC_ALL=C sort)"
assert_equals "4" "$(printf '%s\n' "$MANIFESTS" | grep -c archetype.json)" "four manifests"
while IFS= read -r mf; do
  [ -n "$mf" ] || continue
  dir="$(dirname "$mf")"
  rel="${dir#"$ARCH"/}"
  assert_equals "$(basename "$dir")" "$(jsval "$mf" 'm.name')" "$rel: name equals folder"
  assert_equals "yes" "$(jsval "$mf" '(m.kind==="alternative"||m.kind==="constraint")?"yes":"no"')" "$rel: kind valid"
  assert_equals "$(dirname "$rel")" "$(jsval "$mf" 'm.kind')" "$rel: kind equals parent folder"
  assert_equals "yes" "$(jsval "$mf" '(typeof m.summary==="string"&&m.summary.length>0)?"yes":"no"')" "$rel: summary"
  assert_equals "yes" "$(jsval "$mf" 'Array.isArray(m.slots)?"yes":"no"')" "$rel: slots array"
  assert_equals "yes" "$(jsval "$mf" '(m.thresholds&&typeof m.thresholds==="object"&&!Array.isArray(m.thresholds))?"yes":"no"')" "$rel: thresholds object"
  assert_equals "yes" "$(jsval "$mf" '(Array.isArray(m.gates)&&m.gates.every(g=>g.id&&g.type))?"yes":"no"')" "$rel: gates array of id and type"
  # Every file mirrors a path under ravintio-overrides.
  if [ -d "$dir/files" ]; then
    bad=""
    while IFS= read -r f; do
      [ -n "$f" ] || continue
      case "${f#"$dir/files/"}" in
        standards/*|templates/*|gates/*|library-standards/*) ;;
        *) bad="$bad ${f#"$dir/files/"}" ;;
      esac
    done <<< "$(find "$dir/files" -type f)"
    assert_equals "" "$bad" "$rel: files mirror ravintio-overrides"
    # No alternative carries a protected ignore file.
    if [ "$(dirname "$rel")" = "alternative" ] && [ -f "$PROTECTED" ]; then
      clash=""
      while IFS= read -r f; do
        [ -n "$f" ] || continue
        p="${f#"$dir/files/"}"
        if node -e 'const p=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));const e=Array.isArray(p)?p:(p.entries||p);const t=process.argv[2];const hit=Array.isArray(e)?e.find(x=>x.path&&(x.path===t||x.path.endsWith("/"+t))):Object.entries(e).find(([k])=>k===t||k.endsWith("/"+t));const mode=hit?(Array.isArray(e)?hit.mode:(hit[1].mode||hit[1])):"";process.exit(mode==="ignore"?0:1)' "$PROTECTED" "$p" 2>/dev/null; then clash="$clash $p"; fi
      done <<< "$(find "$dir/files" -type f)"
      assert_equals "" "$clash" "$rel: no protected ignore file"
    fi
  fi
done <<< "$MANIFESTS"

echo "=== req-005: us-writing ==="
USW="$ARCH/alternative/us-writing/files/standards/writing-standards.md"
PACK="$ROOT/standards/writing-standards.md"
assert_equals "yes" "$([ -f "$USW" ] && echo yes || echo no)" "us-writing carries writing-standards.md"
assert_equals '["writing-style"]' "$(jsval "$ARCH/alternative/us-writing/archetype.json" 'm.slots')" "us-writing slot"
for line in \
  '- Keep every sentence under 25 words. Aim for an average near 15.' \
  '- Do not use em dashes or semicolons. End the sentence and start a new one.' \
  '- Write dates as 2026-08-18 or "August 18, 2026". Never write 8/18 or 18/8.'; do
  assert_equals "yes" "$(grep -qxF -- "$line" "$USW" 2>/dev/null && grep -qxF -- "$line" "$PACK" && echo yes || echo no)" "pinned line kept: ${line:0:40}"
done
for m in 'BEGIN style-rules' 'END style-rules' 'BEGIN summary' 'END summary'; do
  assert_contains "$m" "$(cat "$USW" 2>/dev/null)" "us-writing keeps marker $m"
done
assert_not_contains "British" "$(cat "$USW" 2>/dev/null)" "us-writing has no British wording"
assert_contains "American English" "$(cat "$USW" 2>/dev/null)" "us-writing says American English"

echo "=== req-005: strict-testing ==="
ST="$ARCH/constraint/strict-testing/archetype.json"
assert_equals "yes" "$(jsval "$ST" 'm.gates.some(g=>g.type==="file-per-component"&&/pact/i.test(JSON.stringify(g)))?"yes":"no"')" "Pact file-per-component gate"
assert_equals "yes" "$(jsval "$ST" 'm.gates.some(g=>g.type==="min-value"&&/mutation/i.test(JSON.stringify(g)))?"yes":"no"')" "mutation min-value gate"
assert_equals "yes" "$(jsval "$ST" 'm.thresholds["mutation-score"]>=80?"yes":"no"')" "mutation-score threshold at least 80"
assert_equals "yes" "$(jsval "$ST" '/Playwright MCP/.test(JSON.stringify(m))?"yes":"no"')" "names Playwright MCP"
assert_equals "yes" "$(jsval "$ST" '(m.setup&&/playwright/i.test(JSON.stringify(m.setup)))?"yes":"no"')" "setup field describes Playwright server"
STD="$(cat "$ARCH/constraint/strict-testing/files/standards/strict-testing-standards.md" 2>/dev/null)"
assert_contains "Pact" "$STD" "standards name Pact"
assert_contains "Stryker" "$STD" "standards name Stryker"
assert_contains "PIT" "$STD" "standards name PIT"
assert_contains "Playwright MCP" "$STD" "standards name Playwright MCP"

echo "=== req-005: restricted-stack ==="
RS="$ARCH/constraint/restricted-stack/archetype.json"
assert_equals "yes" "$(jsval "$RS" 'm.slots.includes("stack-list")?"yes":"no"')" "stack-list slot"
assert_equals "yes" "$(jsval "$RS" 'm.gates.some(g=>g.type==="allowlist")?"yes":"no"')" "allowlist gate"

echo "=== req-005: language-standards ==="
LS="$ARCH/alternative/language-standards/archetype.json"
assert_equals "yes" "$(jsval "$LS" 'm.slots.includes("language-standards")?"yes":"no"')" "language-standards slot"
LSF="$(cat "$ARCH"/alternative/language-standards/files/library-standards/*/*.md 2>/dev/null)"
assert_contains "linter" "$LSF" "names linters"
assert_contains "formatter" "$LSF" "names formatters"

print_summary
