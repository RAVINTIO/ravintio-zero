# Changelog (0000420-version-both-copies, 10 Nov 2026)

**Feature:** The version bump writes both pack copies
**Version:** no bump. This PR is not a chart step of initiative 0000360.
**PR:** pending

## What changed

- A `version-files.txt` line that starts with `? ` names an optional file. `readVersions` and `setVersions` skip it when the file is absent.
- The shipped list adds `? src/ravintio-zero/component.yml`, the pack source copy.
- `merge-queue.mjs` stages only the listed files that exist. It also skips an optional file that a git ref lacks.
- A new suite, `test-0000420-req-001-optional-version-files.sh`, covers optional and required entries. The 0000378 list test names the new line.

## Why

On 2026-11-10 the queue's version bump on PR #150 wrote 0.76.0 to the installed `component.yml` only. CI's `sync-installed.mjs --check` then failed with `differs: component.yml`. Step 21 and every later bump would fail the same way.

## Deviations

- P2 ran inline without subagents, because the change is one unit.

## Validation results

- Recorded at P3.

## Skipped phases

None.
