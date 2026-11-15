# Plan reference: Test impact causes

> Read this file when you run the Test impact scan. The plan `SKILL.md` points here from its Pack Index. Each cause below tells you what to grep for when the run triggers it.

- **Skill count:** the run adds or removes a skill. Grep for `skills/` with `wc -l`.
- **Skill-text budget:** the run edits any `SKILL.md`. Grep for the line cap.
- **Size cap:** the run edits a skill that a cap test measures, such as the orchestrator. Grep for the skill name and `-le`.
- **Backlog entry id:** the run pulls in an entry. Grep for the entry id.
- **Workflow job or step edit:** the run adds or edits a job or step in a workflow file. Grep for `ravintio.yml`.
- **Reference file edit:** the run edits a file in a skill's `references/` folder. Grep for the file name to find frozen-line tests.
- **New test file:** the run adds a test file. List the repo-wide style tests, such as `test-0000164-req-008`.
- **Non-suite file:** the run adds a file under `ravintio-zero/tests/` that is not a `test-*.sh` suite. List `run-tests.sh` and `run-tests.ps1`.
- **Fixture-pinned line:** the run edits an existing pack line. Grep `ravintio-zero/tests/fixtures/` for the line.
- **Pack file edit:** the run edits a pack file under `src/ravintio-zero/` or `ravintio-zero/`. List `test-0000493-req-004-handoff-text.sh`. The same unit edits both trees, and P0 lists `src/ravintio-zero/` in `## Component Paths`.
- **Output order:** the run adds, removes, or moves a line that a script prints. Search the tests folder for suites that match the line text of each changed line. Also search for suites that read the last line of the output, such as `tail -1`. List each match.
- **Hook change:** the run adds, removes, or changes a hook. Search the tests folder for four pins. The first is the hook name. The second is hook count words, such as "five commands". The third is the `expected-after.txt` fixture and `pack-facts`. The fourth is the margin or status text that the hook checks. List each match.
- **Path move:** the run renames or moves a folder. Search the tests folder for `$ZERO_DIR/..` and `SCRIPT_DIR/../..`, which find the repo root by depth. Also list each state file that keys data by path, such as `plan/state/prose-baseline.json`. List each match.
- **History move:** the run moves or copies archived content into a live folder. Search `ravintio-zero/tests/` for `plan/_archive/`, which finds the suites that skip the archive as history. List each match.
