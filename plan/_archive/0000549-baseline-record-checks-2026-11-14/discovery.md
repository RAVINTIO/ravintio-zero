---
title: "Discovery - 0000549-baseline-record-checks"
summary: "Raw discovery-pass findings for initiative 0000544 step 5."
---
# Discovery - 0000549-baseline-record-checks

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside `plan/_archive/` |
| Git pre-flight | Branch `feat/0000549-baseline-record-checks`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.114.0`
- Prior features (`plan/_archive/`): many archived runs. The closest are 0000385 (baseline failures) and 0000390 (baseline ratchet).
- Constraining ADRs: `docs/adr/0331-baseline-by-suite-name.md` (match failures by suite name).
- Component / data-ownership map: component `ravintio-zero` owns `src/ravintio-zero/`. The pack mirror `ravintio-zero/` holds the same files.

## Step inputs

- Backlog entries: 0000525 (record accepts unfinished runner output), 0000515 (check treats a missing file as an empty baseline).
- Both entries edit `baseline-failures.mjs`. Suite `test-0000385-req-002-baseline-failures.sh` pins the missing-file behaviour that 0000515 reverses.
- Baseline run: started in the background from a clean clone, output in `/tmp/step5-base/out.txt`.
