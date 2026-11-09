# RAVINTIO Tests

This directory holds the pack's own test suite. Bash suites run on macOS,
Linux, and WSL. PowerShell suites run on Windows PowerShell 5.1 and
PowerShell 7. All suites cover the Claude Code target only.

## Layout

| Path | Contents |
|------|----------|
| `test-*.sh` | Per-feature Bash suites |
| `test-*.ps1` | Per-feature PowerShell suites, which run `setup.ps1` |
| `helpers/` | Shared assertions (`assert.sh`, `assert.ps1`), the pack text helpers, `commit_workspace_pack`, `with_timeout` (`timeout.sh`), and the `setup.ps1` workspace helper |
| `brand-guard-allowlist.txt` | The brand guard allowlist. `scripts/brand-guard.sh` (the `pre-push` check) and `test-0000160-req-006-brand-guard.sh` (CI) both read it. |
| `regression/` | The long-term regression pack and its manifest |
| `run-tests.sh` | The runner for every suite |
| `run-tests.ps1` | The runner for the PowerShell suites only |

## Reading pack text

A suite that asserts what a skill, standard, or template says reads it through
a helper in `helpers/assert.sh`. See section 8 of `standards/testing-standards.md`.

- `orch_section "<heading>"` returns a section from `SKILL.md`, the orchestrator
  references, or the roadmap standards.
- `rule_text <id>` and `assert_rule <id> <term>...` read a rule by its
  `<!-- rule: <id> -->` anchor.
- `strip_rule_anchors` removes anchors before a line-by-line comparison.
- `with_timeout <seconds> <command>...` caps a command. Source
  `helpers/timeout.sh` first.

## Workspaces that run setup

Setup copies only committed pack and override files, so a suite that runs `setup.sh` commits the pack in its workspace first. Call `commit_workspace_pack "$ws"` from `helpers/assert.sh` after the copy and after any file you plant in `ravintio-zero/` or `ravintio-overrides/`. The PowerShell helper `Invoke-Setup` commits before each run. `Save-WorkspacePack` does the same on request.

## Test scope in a run

A TDD cycle runs the new test and the tests that cover the changed files. P3 runs
the full suite once, in a clean clone of `HEAD`, with `scripts/clean-clone-test.mjs`.
`scripts/baseline-failures.mjs` compares the failed suites with the ones P0
recorded, so P3 stops only on a new failure. `testing-standards.md` section 9
holds the rules.

## Running the tests

```bash
bash ravintio-zero/tests/run-tests.sh
```

The runner discovers every `test-*.sh` and `test-*.ps1` in this directory by
glob. No suite is registered by hand. Add a conforming file and it runs on the
next invocation. After the per-feature suites, the runner executes every suite
under `regression/` and reports the two sets separately.

The runner runs PowerShell suites with `pwsh`. If `pwsh` isn't on the `PATH`,
it prints how many it skipped. Set `RAVINTIO_REQUIRE_PWSH=1` to make that skip
fail the run, or `RAVINTIO_PWSH` to point at another PowerShell 7 program.

Before any suite runs, the runner checks every file under this directory. A file
that is neither a suite nor on the runner's known list makes the run fail, and
the runner names it. If you add a helper or data file, add it to
`KNOWN_NON_SUITES` in `run-tests.sh`. To run only this check, set
`RAVINTIO_PREFLIGHT_ONLY=1`.

Both runners remove every `RAVINTIO_` variable from the environment of each
suite, so a suite gives the same result in any session. The initiative driver
sets `RAVINTIO_INITIATIVE_STEP` in every step session, and the hooks read it. A
suite that needs a variable sets it for its own call. Three variables pass
through: `RAVINTIO_PWSH`, `RAVINTIO_TIMING_FILE`, and `RAVINTIO_TEST_QUIET`. A
suite that starts a nested runner unsets `RAVINTIO_TEST_QUIET` first.

Both runners also compare tracked and untracked files before the first suite and
after the last. If a suite changes one, the run fails and names the path with
`Tree changed during the run`. The check skips ignored files and skips itself
outside a git repository.

Git ignores `.claude/skills/`, so the tree check cannot see it. Both runners
list that folder before the first suite and after the last. If a suite adds or
removes a path, the run fails and names it with `Skills changed during the run`.

You can also run a single suite directly:

```bash
bash ravintio-zero/tests/test-commit-msg-hook.sh
```

To run only the PowerShell suites, under a host of your choice:

```powershell
powershell -NoProfile -File ravintio-zero/tests/run-tests.ps1
pwsh -NoProfile -File ravintio-zero/tests/run-tests.ps1
```

Suites create their own temporary workspaces where they need isolation and
clean up after themselves, so a run leaves your working tree unaffected.

## CI

CI splits the suites into shards that run in parallel. Both runners read
`RAVINTIO_SHARD=i/n` and run only shard i of n. To run one shard yourself:

```bash
RAVINTIO_SHARD=2/4 bash ravintio-zero/tests/run-tests.sh
```

The `windows-powershell-shard` job in `.github/workflows/ravintio.yml` runs
`run-tests.ps1` on `windows-latest` under Windows PowerShell 5.1, in 3 shards.

The `bash-suites-shard` job runs `run-tests.sh` on `ubuntu-latest` in 4
shards. It sets `RAVINTIO_REQUIRE_PWSH=1`, so the run fails if `pwsh` is
missing. It also runs the `.ps1` suites under `pwsh` on Linux.

The `bash-suites` and `windows-powershell (powershell)` jobs carry the
required check names. Each one passes only when every shard passed.

## The regression pack

`regression/` holds suites promoted from completed feature runs, so behaviour
proven in one feature stays covered in every later one.

`regression/regression-manifest.json` records each promoted test: its source
feature, promotion date, and promoter. `scripts/promote-to-regression.sh`
manages the manifest. Do not edit it by hand. `test-regression-pack.sh` fails
when a manifest entry has no file, or a suite has no entry.

## Adding a test

1. Name the file `test-{feature-id}-{description}.sh` or `.ps1`, and put it in
   this directory.
2. Source `helpers/assert.sh`, or dot-source `helpers/assert.ps1` and end with
   `Complete-Suite`.
3. Exit non-zero on failure. The runner counts a suite as failed on any
   non-zero exit.
4. Keep a `.ps1` suite ASCII. Windows PowerShell 5.1 reads a file with no BOM as
   ANSI, so build non-ASCII test text from `[char]` codes.

The runner picks the file up automatically. Nothing else needs registering.

### Helper guards

- `print_summary` fails a Bash suite that calls an undefined `assert_*` function. It scans the suite for lines that start with an `assert_*` word and prints `FAIL: undefined assert function: {name}` for each name that is not a function. A call after `&&` or inside `$(...)` is not scanned.
- `assert_not_contains needle haystack message` passes when the needle is absent.
- `stale_install_skip_reason root` returns 0 and prints a reason when an initiative is active and `.claude/skills/.ravintio-manifest` is older than the newest pack skill. A suite that compares installed copies prints `SKIP: {reason}` instead of comparing.

### Step activity

- `test-0000240-req-001-driver-stream-args.sh` checks the driver passes `--output-format stream-json --verbose`, keeps the log at mode 600, and prints no step content.
- `test-0000240-req-002-activity-lines.sh` checks that the watcher prints one `I-C Run: activity:` line per event, in order, at 200 characters or fewer, and that the skill and standards describe them. `--since-bytes {n}` treats the first n bytes of the step log as seen.
