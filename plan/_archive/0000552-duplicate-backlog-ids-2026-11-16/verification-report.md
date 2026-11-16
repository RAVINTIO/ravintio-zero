# Verification report - 0000552

Started: no service. Each criterion ran as a CLI check against a scratch repo with two entry folders on id 0000900.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 --check fails on a duplicate id | `backlog-index.mjs --root {scratch} --check` | verified | Exit 1. Stderr read `check: duplicate backlog id 0000900: 0000900-a, 0000900-b`. The suite was RED before the edit with 4 failed. |
| REQ-001 AC-2 unique ids still pass | `--check` on the repo | verified | Exit 0. The new suite also passes a unique-id world. |
| REQ-001 AC-3 the generate mode still writes the index | `backlog-index.mjs --root {scratch}` | verified | Exit 0 and the index was written. `--review` also exits 0 in the suite. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
| NFR-002 safety | The new suite | verified | Generate mode exits 0 with a duplicate id. |
