# Changelog (0000559-start-baseline-first, 16 Nov 2026)

**Feature:** Start the baseline run before the P0 artifacts
**Version:** set by the merge queue at merge
**PR:** 243

## What changed

The P0 start actions now run the decision rows and then the baseline suite right after the pre-flight. Every action that writes a P0 artifact follows. The actions after the baseline moved two places later. The cross-references in the orchestrator skill and the roadmap standards name the new numbers. A new suite checks the order and the citations.

## Why

The baseline run takes about 13 minutes in a clean clone. It started as the fifteenth action, so P3 waited on it. It now overlaps the rest of P0, P1, and P2. This step folds in backlog entry 0000478.

## Deviations

The decision rows moved ahead of the baseline, because a row may change how the baseline runs. The step reads the rows first and logs them once the build log exists. Two suites pinned action numbers, so the step updated both pins.

## Validation results

The clean-clone full run passed 479 feature suites and failed 3. The baseline run failed the same three.

## Skipped phases

None
