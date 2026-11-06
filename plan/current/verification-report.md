# Verification report - 0000355-codeql-and-branch-cleanup

Started nothing. The workflows run on GitHub. A fake `gh` on `PATH` stands in for the API, and the cleanup `run` block was extracted from each workflow file and executed with `bash`.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| `codeql.yml` names `main`, `initiative/**`, and both languages | Test: `test-0000355-req-001-codeql-workflow.sh` and a Ruby YAML parse | verified | The pull request branches hold both patterns. The matrix lists `javascript-typescript` and `actions`. No `contents: write`. |
| CodeQL runs on a PR into `initiative/**` | CI | not-verifiable | Needs GitHub. The step's own PR shows it. A human must also turn default setup off first. |
| The P3 checklist names incomplete escaping | Test: `test-0000355-req-002-p3-escaping.sh` | verified | The injection points item holds "incomplete escaping" and the backslash example. |
| A marked job needs no edit to the shape test | CLI: `helpers/unguarded-jobs.sh` on fixture files | verified | A marked job prints nothing. An unmarked job, and a job after a blank line, print their names. |
| The shape test holds no fixed job list | Test: `test-0000355-req-003-workflow-marker.sh` | verified | The string `k == "squash-before-main"` is gone. `test-0000169-req-006` passes with 17 assertions. |
| The plan scan names the workflow cause | Test: same suite | verified | The scan names "Workflow job or step" and `ravintio.yml`, and stays within 15 lines. |
| The cleanup job skips fork heads, protects `main` and `master`, and holds scoped write | Test: `test-0000355-req-004-branch-cleanup.sh` | verified | Both files hold the job. Only `cleanup-branch` and `release-tag` hold `contents: write`. |
| The cleanup job deletes safely | CLI: the extracted `run` block against a fake `gh`, both files, eight cases | verified | A normal name gives 1 delete call. A missing branch, `main`, `master`, `feat/a;rm -rf x`, `feat/../main`, a name with a space, and a 201-character name give 0 delete calls. All exit 0. |
| Every pull request job skips `closed` | Test: same suite | verified | The helper lists no job in either file. |
| After the step's PR merges, its head branch is gone | CI | not-verifiable | Needs a GitHub merge. The coordinator checks `origin` after the squash. |
| Entry 0000323 matches the repo | Test: `test-0000355-req-005-entry-0000323.sh` | verified | The code scanning row names the workflow. The deletion item is gone. |
| Full suite and checks | CLI: `run-tests.sh`, `consistency-check.mjs`, `backlog-index.mjs --check`, `self-description-check.mjs` | verified | 276 feature suites and 19 regression suites pass. The three checks pass. |
