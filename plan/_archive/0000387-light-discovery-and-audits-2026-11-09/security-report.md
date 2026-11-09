---
title: "Security Report - 0000387-light-discovery-and-audits"
summary: "Security findings for the light discovery and audits change."
---
# Security Report - 0000387-light-discovery-and-audits

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| No injection point. The change adds Markdown rules and Bash tests that read repo fixtures. | `ravintio-zero/tests/test-0000387-req-003-005-coaching-checks.sh` | Low | The test reads only its fixture folder and runs `grep` on it. |
| The light track skips the Scope Lock Challenge, so a larger change could pass with less review. | `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-light-discovery.md` | Low | The reference switches to the full track when the change grows, and the human confirms the track. |
| No credential, path traversal, or data exposure change. No dependency added. | none | Low | Approved dependencies: none. |

## Risk register cross-check

- R-001 and R-002 (size caps): mitigated. SKILL.md holds 8,923 bytes and the boot template holds 3,780 bytes, under the raised caps.
- R-003 (light run skips a check): mitigated by the switch rule.
- R-004 (pinned wording): mitigated. The full suite passes.

**Overall risk rating:** Low. No critical or high finding.
