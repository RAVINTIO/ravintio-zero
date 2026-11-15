# Changelog (0000569-scan-new-pack-files-for-wording-allowlist, 15 Nov 2026)

**Feature:** Scan new pack files for the wording allowlist
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

The test impact scan has a new `Pack content` cause. It names `test-0000042-req-010-pack-wording-allowlist.sh` for a run that adds a content file under `ravintio-zero/`. It also says to list the wording tests in the execution plan. A new suite checks the cause and the scan size in both pack trees.

## Why

A new pack content file can hold a word that the wording allowlist test bans. The scan had no cause for it, so the full suite found the breach late. The plan phase now lists the wording tests first.

## Deviations

The backlog entry names `SKILL.md`. The causes live in `references/test-impact-causes.md`, so the cause went there. The scan held 20 lines, the cap. The step raised the cap to 21 in `test-0000383`, `test-0000567`, and `test-0000568`.

## Validation results

The full suite passes apart from three inherited failures. This step folds in backlog entry 0000415.

## Skipped phases

None
