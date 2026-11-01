---
title: "Security Report - 0000318-titled-coordinator-prs"
summary: "No critical or high finding. The step widens no guard."
---
# Security Report - 0000318-titled-coordinator-prs

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The new wording lets the agent squash a coordinator PR into `initiative/*`. The hook already allowed this, because it checks only the PR base. The initiative PR to `main` stays human-only. | `ravintio-zero/standards/roadmap-standards.md` (`## Merge carve-out`, `## Coordinator PRs`) | Low | `merge-guard.mjs` is unchanged. `test-0000318-req-004-merge-guard-pinned.sh` pins the allow and block set. |
| The `MERGE_GUARD` environment override in the pin test skips the "hook unchanged" check when set. | `ravintio-zero/tests/test-0000318-req-004-merge-guard-pinned.sh:14,60` | Low | The test reads it only for local failure proofs. CI sets nothing, so the check runs. |
| `reserve-id.mjs --commit` commits the counter file on the current branch. On the initiative branch that is a direct commit. | `ravintio-zero/skills/ravintio-initiative/SKILL.md:92` | Low | Not mitigated. Filed as entry 0000332. The history script in step 7 would report it. |
| No credential pattern, hook bypass, forced add, or force-push appears in the new text or tests. | Diff against the initiative branch | None | Not applicable. |

**Overall risk rating:** low.

**Risk register:** R-001 stays open and is mitigated by the pinning test. R-002 stays open: the standards limit coordinator PRs to a stopped driver. R-003 closes: the initiative skill has 114 lines against a cap of 120. A-001 closes: the pinning test shows the hook allows a squash into `initiative/*`.

**Top actions before production:** none.
