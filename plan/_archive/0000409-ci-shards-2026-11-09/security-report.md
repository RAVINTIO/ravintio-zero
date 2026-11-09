# Security report - 0000409-ci-shards

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `.github/workflows/ravintio.yml` shard jobs | none | Each keeps `contents: read`, the pinned `actions/checkout` commit, and `persist-credentials: false`. None reads a secret |
| None | `.github/workflows/ravintio.yml` summary jobs | none | They set `permissions: {}`, check out nothing, and pass the shard result through `env`, not into the script text. A cancelled or skipped shard gives a result other than `success`, so the summary fails |
| Low | Required check on `main` | low | Dropping the Windows pwsh job leaves `windows-powershell (pwsh)` required with no job. The coordinator removes it from the ruleset after merge, as the human approved. Coverage under pwsh stays on Linux |
| None | `run-tests.sh` and `run-tests.ps1` | none | The shard value must match `^\d+/\d+$` before use, so it can't inject into a command. The runners still strip every other `RAVINTIO_` variable from each suite |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding.

**Top actions before production.** Remove `windows-powershell (pwsh)` from the `Protect Main Branch` required checks.
