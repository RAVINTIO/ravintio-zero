# Changelog (0000440-driver-reads-reply-blocks, 10 Nov 2026)

**Feature:** Driver reads blocks from the reply
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The driver keeps the `result` text of each session's last `result` event and stops on a `Blocked:` or `Question:` line in it.
- A block line may carry an `hh:mm` time and a short prefix, such as `13:41 I-D Advance: Blocked:`. This applies to the build log too.
- The continue prompt names the archived build log, or says none exists, when `plan/current/build-log.md` is missing.
- The roadmap standards, the architecture overview, and the dependency graph describe the read.
- The step pulls in entry 0000413 and deletes it.

## Why

Step 6 of initiative 0000360 gave the same block three times in 25 seconds. It had no build log, so the driver never saw the block and resumed twice.

## Deviations

None.

## Validation results

- New suite `test-0000440-req-001-reply-block.sh`: 16 passed.
- Full suite in a clean clone: 381 passed and 2 failed. Both failures exist on the base commit.
- Security review: 0 critical and 0 high findings.

## Skipped phases

None.
