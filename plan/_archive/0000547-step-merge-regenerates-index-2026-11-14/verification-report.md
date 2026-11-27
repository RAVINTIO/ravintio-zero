# Verification report - 0000547-step-merge-regenerates-index

The change is one Markdown rule and one Bash suite. No service starts. The agent ran the suite and read the changed text.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | CLI: ran `bash ravintio-zero/tests/test-0000547-req-001-002-index-rebuild-rule.sh` | verified | exit 0, 2 passed. The `### I-D Advance` section holds the `advance-index-rebuild` anchor and its key terms (`ravintio-zero/standards/roadmap-standards.md:621`). |
| REQ-002 AC-1 | Same suite | verified | The suite checks that the `src/ravintio-zero/` and `ravintio-zero/` trees match. |
| NFR-001 | `git show 91aa050c --stat` | verified | The rule adds 3 lines to the standards file. |

A live run of a step through a conflicting base merge needs a charted initiative and a driver. The suite checks the rule text only. No criterion rests on documentation alone.
