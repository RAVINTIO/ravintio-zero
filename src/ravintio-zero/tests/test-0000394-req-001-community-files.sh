#!/usr/bin/env bash
# Tests for feature 0000394-github-security-and-ci-lint, REQ-001.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo ""
echo "=== REQ-001 AC-1: community and security files exist and hold text ==="
for f in SECURITY.md CONTRIBUTING.md CODE_OF_CONDUCT.md \
  .github/dependabot.yml .github/PULL_REQUEST_TEMPLATE.md .github/CODEOWNERS \
  .github/release.yml .github/ISSUE_TEMPLATE/bug_report.md \
  .github/ISSUE_TEMPLATE/feature_request.md .github/ISSUE_TEMPLATE/config.yml; do
  if [ -s "$ROOT/$f" ]; then state="present"; else state="missing"; fi
  assert_equals "present" "$state" "REQ-001 AC-1: $f exists and is non-empty"
done

SECURITY="$(cat "$ROOT/SECURITY.md" 2>/dev/null)"
assert_contains "private vulnerability reporting" "$SECURITY" "REQ-001: SECURITY.md names private vulnerability reporting"

echo ""
echo "=== REQ-001 AC-2: Dependabot covers workflows ==="
DEPENDABOT="$(cat "$ROOT/.github/dependabot.yml" 2>/dev/null)"
assert_contains 'package-ecosystem: "github-actions"' "$DEPENDABOT" "REQ-001 AC-2: dependabot lists github-actions"

OWNERS="$(cat "$ROOT/.github/CODEOWNERS" 2>/dev/null)"
assert_contains "@martinjmayer" "$OWNERS" "REQ-001: CODEOWNERS names the maintainer"
print_summary
