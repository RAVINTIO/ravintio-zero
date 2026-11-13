# Verification report - 0000378-merge-time-versioning

Method: ran each script from the repo root against the real tree and against suite fixtures. No server or container was needed.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 check passes | CLI `version-files.mjs check` on the real repo | verified | exit 0, `ok: 0.57.0` |
| REQ-001 AC-2 check names a differing file | Fixture in `test-0000378-req-001-version-files.sh` | verified | exit 1 and the path named |
| REQ-001 AC-3 set updates every file | Fixture in the same suite | verified | all files hold the new version, outside path exits 1 |
| REQ-002 AC-1 matching title passes | CLI `merge-queue.mjs title --step 2` | verified | exit 0, `title ok` |
| REQ-002 AC-2 slug title fails | CLI with the slug title | verified | exit 1, expected `0000378: Merge-time versioning` printed |
| REQ-003 AC-1 reverse order gets consecutive versions | Fixture with a fake `gh` and a bare remote | verified | v0.58.0 then v0.59.0, tags peel to the merge commits |
| REQ-003 AC-2 failure stops before the merge | Fixture: slug title, unwritable file, red check, dirty tree | verified | exit 1, nothing merged or tagged |
| REQ-003 AC-2 version file differs after the set | `versions` on a differing file (direct). Through `run` the branch is unreachable | verified for `versions`, not reached through `run` | see deviations in the change record |
| REQ-003 AC-3 chart row and `## Merges` | Fixture | verified | row holds version and `merged`, one `## Merges` row per step |
| REQ-004 AC-1 history check accepts merge order | Fixture in `test-0000378-req-004-merge-order.sh` | verified | exit 0 |
| REQ-004 AC-2 reshape follows merge order | Same suite | verified | step 2 then step 1, tree equals old head |
| REQ-005 AC-1 a fold clears the conflict | Fixture in `test-0000378-req-005-reshape-folds.sh` | verified | exit 0, `fold:` line printed |
| REQ-005 AC-2 no fold clears it | Same suite, wrong `--assign` fixture | verified | exit 1, commit named, no branch written |
| REQ-005 AC-3 tree equals old head | Same suite | verified | tree hashes equal |

The rerun-safety branch of `run` has no test. It is unverified.
