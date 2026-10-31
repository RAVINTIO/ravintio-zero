# Decisions Index

> Change record. Index of all ADRs across all features. Updated after every pipeline run.
> Do not archive this file. Update it in place.

Last updated: 0000316-hooks-fail-closed

---

## Note on the reset

Feature 0000030 emptied `plan/_archive/`, so the ADR files for features 0000001 through 0000029 no longer exist in the working tree. They remain in git history.

This index restarts from 0000030. Decisions from earlier features still bind where their subject survives, but the ADR text has to be read from history.

Rows for features before 0000160 use the product name and paths of their time. 0000160 renamed them.

---

## All Architecture Decision Records
### Feature 0000200: reply-conventions

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature adds one Node.js hook with built-in modules only. It adds no dependency. |
| ADR-002 | A warn-only Stop hook | accepted | `check-reply-prefix.mjs` warns and logs a reply without a prefix, and always exits 0. |

### Feature 0000199: reserve-ids-from-counter

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature adds one Node.js script with built-in modules only. It adds no dependency. |
| ADR-002 | A counter file in place of a scan of every ref | accepted | `plan/backlog/.next-id` holds the next free id and `reserve-id.mjs` reserves blocks under an exclusive lock. |

### Feature 0000198: cap-echoed-plan-text

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature edits two programs and adds one suite. It adds no dependency. |
| ADR-002 | A cap helper in each program | accepted | The hook installs as one file, so each program holds its own 200-character cap function. A parity test checks both. |

### Feature 0000197: merge-guard-block-message

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature edits message text only and adds no dependency. |

### Feature 0000196: setup-argument-checks

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature keeps Bash and PowerShell and adds no dependency. |
| ADR-002 | Retired flags fail setup | accepted | A retired flag exits 1 during argument parsing and names the flag. The tool check runs straight after parsing. The refresh skill reports a retired flag and omits it. Supersedes 0000034 ADR-001. |

### Feature 0000192: rename-runner-lock-and-archive

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature keeps the declared stack and adds no dependency. |
| ADR-002 | Read both archive folder forms | accepted | I-E Delivery archives to `plan/_archive/{id}-{slug}-initiative-{date}/`. The driver's delivery check also accepts the older `-roadmap-` folder form, so no migration runs. |
### Feature 0000189: name-the-roadmap-initiative

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack choice | accepted | The feature keeps the declared stack. Migration 0005 ships Bash and PowerShell helpers, and the pack gains no dependency. |
| ADR-002 | Clean break with migration | accepted | Old names get no aliases. Migration 0005 moves consumer drafts, the CI pattern, and step logs. A model or turns variable with an old prefix stops the driver and names its replacement. |
| ADR-003 | Move on activation | accepted | I-B Activate moves the initiative to the fixed path `plan/current-initiative/initiative.md`. |
| ADR-004 | Short initiative names | accepted | Names use the short form `initiative`, and stage prefixes are `I-A` to `I-E`. `roadmap-standards.md` keeps its name. |
| ADR-005 | Old-name guard allowlist | accepted | A Bash test fails on old names outside an allowlist of exact files and two folders: `plan/_archive/` and `plan/changelog/`. |
### Feature 0000185: explain-strict-mode

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Rewrite the existing strict mode section | accepted | The run rewrites `## Strict Orchestrator Mode` in `project-operations.md` in place, rather than adding a second section. The pack gains no dependency. |
### Feature 0000173: workflow-governance-gates

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as declared | accepted | `workflow-metrics.mjs` uses Node built-in modules only. The pack gains no dependency. |
| ADR-002 | Fixed marker lines are the only metric source | accepted | The script counts `Rework:`, `Blocked:`, `Requirement change:`, and `Gate revised:` lines in the build log and loop-state files. It never reads free text. |
| ADR-003 | Thresholds live in a pack standard, and the gate only reports | accepted | `standards/workflow-governance-standards.md` holds the thresholds table. A breach shows in the build report and the PR description and never stops ship. |

### Feature 0000172: subagent-acceleration

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as declared | accepted | The release changes skill, standard, and template text and adds Bash text suites. No script, hook, or library joins the pack. |
| ADR-002 | The run speed lives in its own sentinel file | accepted | `plan/.run-speed` holds `fast` or `standard`. `plan/.run-mode` keeps its two values. A missing or unknown value counts as `standard`. |
| ADR-003 | Each phase skill lists its own fast batch | accepted | The dispatch standard holds the fast batch rules. Each phase skill lists its units under `### Fast batch`. Phases still run in order. |

### Feature 0000171: faster-setup-ps1-tests

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack unchanged | accepted | The faster copy uses .NET types that both PowerShell hosts load. No module or tool such as `robocopy` joins the pack. |
| ADR-002 | setup.ps1 copies files with System.IO calls | accepted | `Copy-RavintioSkills` and `Install-EnforcementHooks` copy through `System.IO` helpers in place of per-file cmdlets. The SKILL.md rewrite keeps `Set-Content`. |
| ADR-003 | Suites report setup time through a file the runner names | accepted | `Invoke-Setup` appends each time to `RAVINTIO_TIMING_FILE`. `run-tests.ps1` prints the total and case count, then deletes the file. |

### Feature 0000170: story-mapping-and-gherkin

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack unchanged | accepted | The consistency check and the ratchet hook parse Gherkin with Node.js built-ins and regular expressions. No Gherkin parser library joins the pack. |
| ADR-002 | P1 owns the story mapping pass | accepted | P1 maps stories first and writes `plan/current/story-map.md`. A gap the brief states or implies becomes a story and a requirement. Any other gap goes out of scope. |
| ADR-003 | A criterion stays one checkbox line | accepted | Each criterion is `- [ ] AC-{n}: {name}` with indented `Given`, `When`, and `Then` bullets. The limit of three counts checkbox lines. |
| ADR-004 | The ratchet guards step lines | accepted | Each `Given`, `When`, `Then`, `And`, or `But` bullet in `## Acceptance Criteria` is a guarded line. Removing or rewording one blocks unless a human approval marker names the file. |

### Feature 0000169: release-hygiene

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack unchanged | accepted | Two new scripts use Node.js built-ins only. No library, service, or third-party action joins the pack. |
| ADR-002 | CI tags the merge commit on main | accepted | A `release-tag` job on a push to `main` or `master` tags `HEAD` with the product version and skips a tag that exists. Ship creates no tag before the merge. Only that job holds `contents: write`. |
| ADR-003 | One attribution check serves ship and CI | accepted | `scripts/check-attribution.mjs` checks a PR body in ship and in `validate-branch`. The body reaches CI through `env:` only. The `commit-msg` hook keeps its own list and gains the host lines. |
| ADR-004 | Setup turns off host attribution when unset | accepted | Setup writes empty `attribution.commit` and `attribution.pr` strings to `.claude/settings.json` when the key is absent, and leaves a set key alone. |


### Feature 0000030: framework-cut-down

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Claude Code is the only supported tool target | accepted | Drops eight tool targets, the vendored external skill library, and the context-mode integration. Supersedes 0000001 ADR-001 to ADR-004. |

### Feature 0000031: five-phase-planifest-zero

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Five-phase pipeline contract and skill consolidation | accepted | Collapses the ten-phase pipeline to five phases (discovery, plan, implement, validate and accept, ship) and 21 skills to 12. |
| ADR-002 | Folder rename and product identity | accepted | Renames `planifest-framework/` to `planifest-zero/`, sets the `product.yml` id to `planifest-zero`, and fixes the Windows refresh script to derive its own path. |
| ADR-003 | One route: the feature pipeline | accepted | Drops the Change Pipeline and Fast Path routes. Every change runs the five-phase feature pipeline, and one CI parity check applies to every diff. |
| ADR-004 | Living docs describe the present only | accepted | Moves historical narrative to change records: `plan/changelog/`, `plan/_archive/`, ADR files, and git history. This index and `docs/about.md` carry stated exemptions. |

### Feature 0000032: relocate-setup-config-to-plan-state

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The setup-config record lives in plan/state/ | accepted | Moves the tracked setup-flags record from `planifest-overrides/setup-config/{tool}.md` to `plan/state/{tool}.md`. Supersedes 0000025 ADR-002. |
| ADR-002 | Refresh-setup reads the record before the marker | accepted | `planifest-refresh-setup` Step 3 reads `plan/state/{tool}.md` first at high confidence, falling back to the gitignored marker then hook inference. |
| ADR-003 | Setup removes the old record inline | accepted | `setup.sh` and `setup.ps1` delete the pre-relocation record at its exact path after a successful write, with no separate migration file. |

### Feature 0000033: remove-telemetry-mcp

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Telemetry is not a pack concern | accepted | Removes the telemetry system from `planifest-zero` with no replacement and no extension seam. Drops `backendUrl` from the setup-config record, narrowing 0000032 ADR-001. |
| ADR-002 | Setup cleans up telemetry wiring on every run | superseded by 0000164 ADR-003 | Every setup run removes legacy telemetry hook entries, the opt-in sentinel, and the marker directories. One line per removal, a warning without failing. |
| ADR-003 | The phase vocabulary lives in prose, not in a module | accepted | Deletes `phase-enum.mjs` and states the five phase names in `pipeline-reference.md`. The `product.yml` id and its hard stop stay, for versioning. |

### Feature 0000164: hardening-and-backlog-skill

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stack unchanged | accepted | Keeps the declared stack and adds no dependency. `gate-write.mjs` uses `realpathSync` from `node:fs`. |
| ADR-002 | gate-write scopes to the project by real path | accepted | The hook exits 0 when a target's real path lies outside the project's real root. A symlink inside the project that points outside counts as outside. |
| ADR-003 | Retire the telemetry cleanup and keep the retired-hooks list | accepted | Setup drops the legacy telemetry cleanup in both shells. The list stays as `RETIRED_HOOK_NAMES` and `$RetiredHookNames`, and hook install drops settings entries for any retired hook. Supersedes 0000033 ADR-002. |
| ADR-004 | The file-backlog skill never touches the target repo's git state | accepted | `ravintio-file-backlog` writes one uncommitted entry folder. It never commits, pushes, switches branches, stashes, or opens a pull request there. |
| ADR-005 | Relabel the rename release as 0.12.0 | accepted | 0000160 becomes 0.12.0 and this release is 0.13.0. Supersedes the version decision of 0000160 ADR-001. Moves the fallback removal in 0000160 ADR-002 from 2.0.0 to 1.0.0. |

---

## Superseded

| ADR | Superseded by | Reason |
|-----|---------------|--------|
| 0000034 ADR-001 | 0000196 ADR-002 | A retired flag now exits 1 during argument parsing instead of warning and continuing. |
| 0000001 ADR-001 to ADR-004 | 0000030 ADR-001 | The context-mode hook design they governed no longer exists. |
| 0000025 ADR-002 | 0000032 ADR-001 | The record moved from planifest-overrides/setup-config/ to plan/state/. The ADR text is in git history only. |
| 0000018, 0000024, 0000026, 0000027, and 0000028 telemetry ADRs | 0000033 ADR-001 | Their subject no longer exists in `planifest-zero`. The ADR text is in git history only. |
| 0000024 product-id ADR (rationale only, partly superseded) | 0000033 ADR-003 | The `id` field and the hard stop stand. Versioning and archive attribution replace telemetry attribution as the reason. |
| 0000032 ADR-001 (record shape only, narrowed) | 0000033 ADR-001 | The record drops `backendUrl` and holds `tool`, `flags`, and `writtenAt`. Its location and tracked status stand. |
| 0000036 ADR-003 (Bash suites out of CI only, narrowed) | 0000037 ADR-002 | The `bash-suites` job runs the Bash suites in CI. The Windows job stands. |
| 0000037 ADR-003 (decision item 4 only, narrowed) | 0000041 ADR-003 | The non-array warning no longer prints the old value. Warn, replace, and exit 0 stand. |
| 0000031 ADR-001 (phase numbers and prefixes only, superseded in part) | 0000042 ADR-003 | Phases take the numbers P0 to P4 and number-plus-name prefixes. The five-phase contract and skill consolidation stand. |
| 0000023 run-mode gate rules (in skills and tests, no ADR) | 0000042 ADR-002 | The two earlier run modes become `gated` and `autonomous`. |
| 0000042 ADR-002 (merge rule only, amended) | 0000043 ADR-003 | The agent may squash-merge its own step PR into an `initiative/*` branch after a clean P3 and green CI. Merging into `main` stays human-only. |
| 0000031 ADR-002 (folder and product id only, superseded in part) | 0000160 ADR-001 | The pack folder is `ravintio-zero/` and the product id is `ravintio-zero`. |
| 0000042 ADR-004 (brand word only, superseded in part) | 0000160 ADR-004 | A separate brand guard test blocks the earlier product name. The wording allowlist test for the retired word stands. |
| 0000043 ADR-004 (driver child contract, extended) | 0000151 ADR-005 | Each initiative child gets a model, an optional turn cap, a step log, and telemetry labels. The fresh `claude -p` session per step stands. |
| 0000042 ADR-002 (exception stops, extended) | 0000151 ADR-004 | A sixth exception stop covers a library or service missing from the approved list. It applies to both run modes. |

### Feature 0000034: setup-hardening

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Retired setup flags warn and continue | accepted | Setup accepts four retired flags with one warning each and skips the `--backend-url` value. Supersedes the no-op rejection in 0000030 ADR-001. |
| ADR-002 | settings.json writes go through a temporary file and a rename | accepted | Every `settings.json` write uses a same-folder temporary file, keeps the original's mode, and never follows a planted link. |
| ADR-003 | The stack stays as it is | accepted | No new language, runtime, or test framework. |


### Feature 0000035: powershell-setup-parity

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | setup.ps1 writes the same hook entries as setup.sh | accepted | `setup.ps1` wires all six enforcement hooks in the `setup.sh` entry shape, and a static parity suite checks the match. |
| ADR-002 | setup.ps1 supports Windows PowerShell 5.1 | accepted | `setup.ps1` uses no PowerShell 7-only feature, so it runs on the PowerShell that ships with Windows. |
| ADR-003 | setup.ps1 flags are case-sensitive | accepted | The flag `switch` matches case, as `setup.sh` does. Both scripts remove a leftover temporary file at the start of each run. |

### Feature 0000036: test-runner-coverage

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stray test files fail the run | accepted | `run-tests.sh` names every file under `tests/` that is neither a suite nor a known non-suite, and exits 1. |
| ADR-002 | PowerShell suites use a plain assert helper | accepted | `test-*.ps1` suites use `helpers/assert.ps1` with no Pester. `run-tests.sh` runs them with `pwsh` or reports the skip. |
| ADR-003 | CI runs the PowerShell suites on Windows under both hosts | accepted | A `windows-latest` job runs `run-tests.ps1` with `powershell` and with `pwsh`. Bash suites stay out of CI for now. |

### Feature 0000037: self-host-on-planifest-zero

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The repo self-hosts on planifest-zero | accepted | Repoints `core.hooksPath` to `planifest-zero/hooks`, then deletes `planifest-framework/`. The setup record moves to `plan/state/claude-code.md`. |
| ADR-002 | The Bash suites run in CI on Ubuntu | accepted | A `bash-suites` job runs `run-tests.sh` with `PLANIFEST_REQUIRE_PWSH=1` and `contents: read`. The `validate-telemetry-schema` job goes. |
| ADR-003 | Setup repairs the hook entries it owns | accepted | `setup.sh` removes Planifest `PreToolUse` entries on any matcher. Both scripts warn on a non-array hook event and replace it. |
| ADR-004 | P0 states standard-iterative mode without asking | accepted | When standard-iterative is the only signal, the orchestrator states the mode and its signal. Every other case keeps the question. |

### Feature 0000038: setup-hook-filter-fixes

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or test framework. |
| ADR-002 | Setup filters Planifest hook commands one at a time | accepted | Both scripts remove only Planifest commands from a `PreToolUse` or `UserPromptSubmit` entry and keep user commands. `setup.sh` matches `UserPromptSubmit` by path boundary. Refines 0000037 ADR-003. |

### Feature 0000039: setup-hardening-release-sizing

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | Invalid JSON exits 1 with a fixed message | accepted | The hook install step prints one fixed line naming the file, leaves it unchanged, and exits 1. The telemetry cleanup still warns and carries on. |
| ADR-003 | A single-object `hooks` value counts as a one-item array | accepted | Both scripts apply the per-command filter to a single-object `hooks` value. Refines 0000038 ADR-002. |
| ADR-004 | The release budget lives in `product.yml` | accepted | An optional `releaseSize` field sets a budget of 4, 8, or 14 points, with `medium` as the default. It replaces the fixed 3-story rule. |

### Feature 0000040: setup-json-checks-and-park

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | Valid JSON that is not a settings object exits 1 | accepted | Both scripts print one shared fixed line, leave the file unchanged, and exit 1. Extends 0000039 ADR-002. |
| ADR-003 | Only `setup.ps1` rejects case-duplicate keys | accepted | `ConvertFrom-Json` can't read them, so `setup.ps1` gives the shared line. `setup.sh` accepts them. |
| ADR-004 | JSON depth is capped at 1024 | accepted | `Test-JsonText` uses a counter and a `Stack[char]`, runs in linear time, and fails past 1024 levels. |
| ADR-005 | Park keeps the work on the feature branch | accepted | Park pushes the branch and files a `parked` backlog entry by chore PR. Pickup resumes or discards it. |

### Feature 0000041: setup-cleanup-and-park-hardening

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | The telemetry cleanup skips unreadable settings | accepted | Both cleanups skip in silence on a parse or shape failure. The hook install step reports the fault once. Extends 0000033 ADR-002. |
| ADR-003 | The non-array warning drops the old value | accepted | Both scripts name the event and the file only. Supersedes decision item 4 of 0000037 ADR-003. |

### Feature 0000042: autonomous-mode-and-prefixes

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | Gated and autonomous run modes | accepted | Replaces the two earlier run modes with `gated` and `autonomous`. Autonomous runs to a raised PR. Five exception stops apply to both modes. |
| ADR-003 | Phase numbers P0 to P4 and number-plus-name prefixes | accepted | Phases run P0 Discovery to P4 Ship. Messages start with `P0 Discovery:` to `P4 Ship:`. A guard test blocks stale cites. Supersedes 0000031 ADR-001 in part. |
| ADR-004 | Pack wording and identifier map | accepted | No tracked file outside history describes Planifest Zero with the retired word. Identifiers follow one map, and an allowlist test enforces the rule. |

### Feature 0000043: autonomous-roadmaps

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as declared | accepted | No new language, runtime, or dependency. Adds one Node hook, `merge-guard`, and one Node script, `initiative-run.mjs`. |
| ADR-002 | Roadmap storage and lifecycle | accepted | Drafts live in `plan/roadmap/`. The one active initiative lives in `plan/current-initiative/` on the initiative branch. Ids share the backlog sequence. |
| ADR-003 | Agent squash-merge into initiative branches | accepted | The agent may run `gh pr merge --squash` for its own step PR into `initiative/*` after a clean P3 and green CI. `merge-guard` enforces it. Amends the 0000042 run-mode merge rule. |
| ADR-004 | Driver script runs each step in a fresh session | accepted | `initiative-run.mjs` runs each step as its own `claude -p` session in auto permission mode. A lock file stops a second driver. |
| ADR-005 | Tag after the squash merge in an initiative step | accepted | An initiative step squash-merges first, then tags the squash commit and pushes the tag. Outside an initiative, tag-before-PR stays. |
| ADR-006 | Self-confirmed initiative steps and stage prefixes | accepted | A step's P0 builds the brief from its backlog entries and self-confirms. I-A Chart is the single human approval, including predicted additive schema changes. Stages I-A to I-E sit beside P0 to P4. |
| ADR-007 | Progress markers and interrupted-unit resume | accepted | Each dispatched unit logs `In progress:` before it starts and `Done:` with its work. On resume, the session stashes left-over changes and reruns an interrupted unit from its start. |

### Feature 0000151: hardening-efficiency-and-ci

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as declared | accepted | No new language, runtime, or package. Adds one Node helper, `initiative-labels.mjs`, and edits existing files. |
| ADR-002 | Hook block reasons go to stderr and stdout | accepted | `gate-write`, `em-dash-guard`, and `ratchet-check` write each block reason to both streams, as `merge-guard` does. The stdout write stays plain text. |
| ADR-003 | Ship clears sentinels before the PR | accepted | Ship runs Step 7 tag, Step 8 clear sentinels, Step 9 push and PR, Step 10 final gate. The tag is pushed with the branch. |
| ADR-004 | A sixth exception stop for unapproved dependencies | accepted | P1 or P2 adding a library or service that is missing from the approved list stops the run. It applies to both run modes. |
| ADR-005 | Initiative driver child contract | accepted | The driver passes `--model` and `--max-turns`, writes `plan/.initiative-logs/step-{position}.log`, and appends percent-encoded labels to `OTEL_RESOURCE_ATTRIBUTES`. |
| ADR-006 | Orchestrator references split | accepted | Rarely used orchestrator sections move word for word to `references/orchestrator-*.md`. A line-preservation test proves no rule was lost. |
| ADR-007 | Setup prunes retired hooks by list | accepted | Setup deletes an installed hook only if its name is on the retired list, which starts with `phase-enum`. |
| ADR-008 | Park refuses symlinked entry paths | accepted | Park refuses any symlink in the entry path, checking with `lstat` and real-path containment before it creates, writes, or removes. |

### Feature 0000160: ravintio-rebrand

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The RAVINTIO rename map | accepted | Prose writes RAVINTIO in block capitals. Identifiers use lowercase `ravintio` and variables use `RAVINTIO_`. History folders stay as written. Supersedes 0000031 ADR-002 in part. |
| ADR-002 | Legacy aliases stay accepted through 0.x | accepted | Two initiative variables and the em dash sentinel keep their earlier names as fallbacks. The new name wins. The fallbacks go at 1.0.0. 0000164 ADR-005 moves the removal point from 2.0.0 to 1.0.0. |
| ADR-003 | Consumer migration 0004 | accepted | Bash and PowerShell helpers move the overrides folder and the workflow, remove old markers, move the old pack folder to `.ravintio-backup/` instead of deleting it, and archive 0004. A migration with a false `Applies when:` condition stays pending. Setup stops while an old folder remains. |
| ADR-004 | Brand guard test | accepted | A test fails on any tracked path or line outside history that holds the earlier product name, unless a path and line allowlist entry matches. A stale entry also fails. |
| 0000160 ADR-001 (version decision only) | 0000164 ADR-005 | The rename release is 0.12.0, not 1.0.0. The rename map stays in force. |
| 0000160 ADR-002 (removal point only) | 0000164 ADR-005 | The legacy fallbacks go at 1.0.0, not 2.0.0. |
| 0000033 ADR-002 | 0000164 ADR-003 | Setup no longer removes legacy telemetry wiring. A pre-0000033 consumer removes it by hand. |

### Feature 0000239: test-suite-reliability

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Scan the suite for undefined asserts | accepted | `print_summary` scans the running suite for lines that start with an `assert_*` word and fails each name that is not a function. macOS Bash 3.2 has no not-found handler. |

### Feature 0000240: stream-step-session-activity

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Read the stream in the watcher | accepted | The driver only switches the output format. The watcher reads the step log by byte offset and prints one activity line per event, so one monitor carries every line. |

### Feature 0000241: watcher-false-events

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Track commits by ancestry and stale by key | accepted | The watcher lists new commits with `git log {last-seen}..HEAD` when the last-seen commit is an ancestor of `HEAD`. Otherwise it prints one branch-change line. A stale state prints once. |

### Feature 0000245: boot-rules-into-skills

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Targeted overrides append to the named skill | accepted | An override with `target: {skill}` is appended to that installed skill between markers. A bad target falls back to the boot file. |
| ADR-002 | Hook Enforcement lives in a reference file | accepted | The hook list moves to `standards/hook-enforcement.md`. The boot files point to it and each blocking hook message names it. |

### Feature 0000246: plan-checks-count-and-cap-tests

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The plan skill scans tests by grep | accepted | The plan skill greps `ravintio-zero/tests/` for tests that hold a skill count, a skill-text budget, a size cap or a backlog entry id. The execution plan lists each match under `## Test impact`. |

### Feature 0000247: git-state-hygiene

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | reserve-id commits the counter by path | accepted | `reserve-id.mjs --commit` runs `git commit -m {subject} -- {counter}`, so the commit holds the counter file alone. The initiative, retrospective, and postmortem skills pass the flag. |

### Feature 0000248: ship-merge-and-wall-clocks

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | the build log check is its own script | accepted | `build-log-check.mjs` checks the build log at ship Step 3, before Archive. `consistency-check.mjs` runs at P1, before the phase blocks exist, so it stays apart. |

### Feature 0000313: driver-setup-stop

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | one stop line for both stops | accepted | A step that changes a restart file and a setup path gets one `I-D Advance: Restart: Setup:` line. A restart-only or setup-only step keeps its own line. |

### Feature 0000314: step-logs-stay-in-place

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | skip the step log folder in the phase guard | accepted | The phase guard skips `plan/.initiative-logs` only. It keeps scanning every other path, so a new untracked skill file is still checked. |

### Feature 0000315: isolated-test-state

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | clear the environment in the runner | accepted | The runners remove every `RAVINTIO_` variable from each suite except `RAVINTIO_PWSH`, `RAVINTIO_TIMING_FILE`, and `RAVINTIO_TEST_QUIET`. They compare tracked and untracked files before and after the run and fail on a change. |

### Feature 0000316: hooks-fail-closed

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | run every hook through a launcher from the project root | accepted | Setup wires each hook as `guard-run.mjs {guard\|advisory} {hook}.mjs` under `${CLAUDE_PROJECT_DIR}` and sets `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1`. In guard mode a missing or crashing script exits 2 and names the script. |
