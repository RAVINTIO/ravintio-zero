# Build report - 0000583-step-temp-cleanup-after-merge

**Run speed:** `fast`

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) |
|-------|--------|-----------|----------------------|
| P0 Discovery | 0 | primary | 2 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 11436, because the run paused between 2026-11-18 and 2026-11-26 |
| P3 Validate and Accept | 0 | primary | 27 |
| P4 Ship | 0 | primary | 1 as logged. CI fixes ran after that. |

## Parallelism

- No subagent ran. The agent did every unit inline in one tree.
- The execution plan listed 2 batches. Each unit was small, and the units shared the driver and the runner.
- The P3 docs edit pass ran as a script check, with no fresh-context review.

## Self-corrections

| Cause | Avoidable | Note |
|-------|-----------|------|
| The path limit broke every driver suite in a long temp path | Yes | A fixture check would have found it at P2. |
| Seven pinned suites compared the exact `claude` arguments or the child environment | Yes | The test impact scan did not list them. See the first postmortem. |
| The runner put its `TMPDIR` inside the repo when `TMPDIR` was unset | Yes | Local runs inherit the macOS `TMPDIR`. See the second postmortem. |
| Four suites leaked workspaces made inside command substitutions | Yes | The first design relied on a cleanup list that a subshell never reaches. |
| The signal traps came after the scratch folder in five suites | Yes | The REQ-002 test sent `TERM` before the trap existed. |

CI failed three times on shard 2 before the fifth fix. Only the runner failure has its own postmortem. The others are `Deviation:` lines in the build log.

## Suggestions

- P2: run the new REQ-002 test with `TMPDIR` unset before the first push, to match the CI Linux runners.
- P2: add driver `claude` arguments to the test impact scan.
- P3: add a clean-clone run with `TMPDIR` unset to `clean-clone-test.mjs`.

## Postmortems

- `plan/postmortems/2026-11-26-driver-flags-pinned-by-suites.md`
- `plan/postmortems/2026-11-26-runner-temp-folder-inside-repo.md`

## Inherited failures

Inherited failures: none. No `baseline-failures.md` exists for this run. The clean clone run listed three failing suites that the step did not change. They are `test-0000450-req-004`, `test-0000037-req-004`, and `test-0000318-req-004`. They passed in CI.

## Workflow governance

Breaches: 0. Rework loops per requirement (highest): 0 of 2. `Blocked:` stops: 0 of 1. Mid-pipeline design changes: 0 of 1. Human corrections at gates: 0 of 2. Longest CI run: 0 seconds of 420, because no CI duration marker was logged.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | inline | 2 | 0 |
| content | inline | 1 | 0 |

Retrospective: none. The agent did not run `ravintio-retrospective`.
