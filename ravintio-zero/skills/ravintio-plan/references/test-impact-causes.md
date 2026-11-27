# Plan reference: Test impact causes

> Read this file when you run the Test impact scan. The plan `SKILL.md` points here from its Pack Index. Each cause below tells you what to grep for when the run triggers it.

- **Skill count:** the run adds or removes a skill. Grep for `skills/` with `wc -l`.
- **Skill-text budget:** the run edits any `SKILL.md`. Grep for the line cap. If the run adds a file name, command, or flag, also grep for suites that loop over every skill and match that term. List each match. `test-0000151-req-008-quiet-test-output.sh` is one, because it requires `RAVINTIO_TEST_QUIET=1` on every `run-tests` command.
- **Size cap:** the run edits a skill that a cap test measures, such as the orchestrator. Grep for the skill name and `-le`. List every test that measures the skill with each cap value, not the first match. Plan the unit's growth against the lowest cap.
- **Backlog entry id:** the run pulls in an entry. Grep for the entry id.
- **Workflow job or step edit:** the run adds or edits a job or step in a workflow file. Grep for `ravintio.yml`.
- **Reference file edit:** the run edits a file in a skill's `references/` folder. Grep for the file name to find frozen-line tests. For an orchestrator reference, also list `test-0000151-req-011-orchestrator-references-split.sh`. It freezes every base line of the skill and caps the boot template, so read the cap from the suite.
- **New test file:** the run adds a test file. List the repo-wide style tests, such as `test-0000164-req-008`.
- **Non-suite file:** the run adds a file under `ravintio-zero/tests/` that is not a `test-*.sh` suite. List `run-tests.sh` and `run-tests.ps1`.
- **Fixture-pinned line:** the run edits an existing pack line. Grep `ravintio-zero/tests/fixtures/` for the line.
- **Pack file edit:** the run edits a pack file under `src/ravintio-zero/` or `ravintio-zero/`. List `test-0000493-req-004-handoff-text.sh`. The same unit edits both trees, and P0 lists `src/ravintio-zero/` in `## Component Paths`.
- **Output order:** the run adds, removes, or moves a line that a script prints. Search the tests folder for suites that match the line text of each changed line. Also search for suites that read the last line of the output, such as `tail -1`. List each match.
- **Hook change:** the run adds, removes, or changes a hook. Search the tests folder for four pins. The first is the hook name. The second is hook count words, such as "five commands". The third is the `expected-after.txt` fixture and `pack-facts`. The fourth is the margin or status text that the hook checks. List each match.
- **Path move:** the run renames or moves a folder. Search the tests folder for `$ZERO_DIR/..` and `SCRIPT_DIR/../..`, which find the repo root by depth. Also list each state file that keys data by path, such as `plan/state/prose-baseline.json`. List each match.
- **History move:** the run moves or copies archived content into a live folder. Search `ravintio-zero/tests/` for `plan/_archive/`, which finds the suites that skip the archive as history. List each match.
- **Prose rewrite:** the run changes sentences in pack files, as a wording pass does. Grep `ravintio-zero/tests/` and `ravintio-zero/tests/fixtures/` for each changed sentence. List the matches in the execution plan, in the unit that edits the sentence.
- **Pack content:** the run adds a content file under `ravintio-zero/`, such as a standard, a template, or a skill. List `test-0000042-req-010-pack-wording-allowlist.sh`, which bans a word in new pack text, and the other repo-wide wording tests. Record them in the execution plan, in the unit that adds the file.
