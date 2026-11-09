# Acceptance evidence - 0000390-prose-checks

1. Checks: the full suite ran in a clean clone of the branch head. It failed two suites. Both fail on the base commit too: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. The run needed 3 fix cycles. The brand and wording checks read the baseline file. One regression copy kept a passive fixture. One PowerShell pin counted four advisory hooks.
2. Security: no critical or high finding. See `security-report.md`.
3. Execution: the linter exits 1 on a 26-word sentence and names the file and line. The Stop hook prints a note that quotes the first words and exits 0 on bad JSON. Two claims rest on text alone: the edit pass wording and the PowerShell hook wiring. See `verification-report.md`.
4. Search evidence: no program is missing.
5. Docs edit pass: a subagent reviewed `docs/architecture-overview.md` and `docs/dependency-graph.md`. It changed the new section, and `prose-check.mjs check` exits 0 on both files.
