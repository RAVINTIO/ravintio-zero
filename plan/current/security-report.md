# Security report - 0000384-plan-checks

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The `gh` binary can be replaced through `RAVINTIO_GH_BIN` | `ravintio-zero/scripts/human-settings-check.mjs:61` | Low | The caller owns the environment already. The variable exists for tests. Documented in the script header. |
| Endpoint text comes from a chart row | `ravintio-zero/scripts/human-settings-check.mjs:72` | Low | An allowlist regex with restricted segments checks the endpoint. `execFileSync` takes an argument array, so no shell runs. Tests cover `..`, `;`, and foreign endpoints. |
| Migration writes and deletes files by path | `ravintio-zero/migrations/migrate-adr-home.mjs:39` | Low | The script refuses a symlink, acts under `--root` only, and writes new targets by explicit path. A dry run lists every change. |
| Wording tests now treat `docs/adr/` as history | `ravintio-zero/tests/test-0000160-req-006-brand-guard.sh` and nine more suites | Low | The exclusion matches the `plan/_archive/` precedent. The archive-immutability test carves out `plan/_archive/*/adr/` only. |

Credential handling: no secret appears in any changed file. The scan found no match.
Dependency risk: the step adds no dependency.
Data exposure: the settings script prints the actual value truncated to 80 characters with control characters stripped.

Risk register: R-001 mitigated by the dry run, the idempotence suite, and the reference check. R-002 and R-003 mitigated by fixture and pin updates. R-004 mitigated as above. R-005 accepted, features 0000002, 0000013, and 0000029 have no ADRs in history.

Overall risk rating: low. No critical or high finding.
