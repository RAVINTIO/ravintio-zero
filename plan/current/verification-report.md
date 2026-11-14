---
title: "Verification report - 0000545-clear-feature-id-at-ship"
summary: "Execution evidence for REQ-001 to REQ-003."
status: "active"
version: "0.1.0"
---
# Verification report - 0000545-clear-feature-id-at-ship

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship

## What ran

The agent ran each new test script directly with `bash`. It also ran `git ls-files plan/.feature-id` on the branch head.

## Per criterion

| Requirement | Method | Outcome | Evidence |
|-------------|--------|---------|----------|
| REQ-001 | CLI: `test-0000545-req-001-ship-deletes-feature-id.sh` | verified | Exit 0, 2 passed, 0 failed. Ship Step 8 names `plan/.feature-id`. |
| REQ-002 | CLI: `test-0000545-req-002-queue-resolves-feature-id.sh` | verified | Exit 0, 3 passed, 0 failed. The conflict resolver keeps the PR branch text or deletion. |
| REQ-003 | Side effect: `git ls-files plan/.feature-id` | verified | Prints nothing on the branch head. |
