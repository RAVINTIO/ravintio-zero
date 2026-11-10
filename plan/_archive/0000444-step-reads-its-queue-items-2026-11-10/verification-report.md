---
title: "Verification Report - 0000444-step-reads-its-queue-items"
summary: "What ran and what each acceptance criterion showed."
---
# Verification Report - 0000444-step-reads-its-queue-items

## What ran

- The suite `test-0000444-req-001-003-queue-items.sh` runs the helper and the driver with a stub `claude`. It passes 26 of 26 checks.
- The helper ran against the real queue at `plan/.initiative-queue/` in the main root.
- The full suite ran in 4 shards. It passes 403 feature suites and 19 regression suites with no failure.

## Criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 list | CLI: `list --step 25` and `list --step 26` | verified | Step 25 printed `rebase-step-25` and its destination. Step 26 printed nothing. Exit 0 both times |
| REQ-001 AC-2 unsafe items | Suite, with a symlinked item and an item with no step line | verified | The helper skipped the link, warned on the other, exit 0 |
| REQ-001 AC-3 check | CLI: `check --step 25` and `check --step 26` against the initiative branch | verified | Step 25 exited 1 and named the item. Step 26 exited 0 |
| REQ-002 AC-1 no item | Suite, stub `claude` records its arguments | verified | The prompt equals `Run initiative step 1` |
| REQ-002 AC-2 named item | Suite, same stub | verified | The prompt lists the folder name and `item.md` |
| REQ-002 AC-3 hostile name | Suite, folder name with a space and a body that holds an instruction | verified | Neither the name nor the body reached the prompt |
| REQ-003 AC-1 to AC-3 text | Suite reads the rule, I-D Advance, and the pickup step | verified | Each text names the helper |

## Not verifiable

The continue prompt path with a live `claude` resume. The stub suite covers the argument build only. Reason: a live resume needs a model session.
