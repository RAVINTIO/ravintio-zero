---
title: "Roadmap standards"
summary: "How the initiative, orchestrator, and ship skills chart, activate, run, advance, and deliver an initiative."
status: "active"
version: "0.1.0"
---
# Roadmap standards

Read this file first when an initiative is involved. The initiative, orchestrator, and ship skills point here to keep their text short. An initiative is a chain of feature steps that the human approves once. Read `ravintio-zero/templates/initiative.template.md` before you write one.

For the meaning of "roadmap", "roadmap initiative", and the initiative states, see the [roadmap and initiative glossary](../project-operations.md#roadmap-and-initiative-glossary).

### Initiative states

The `status` field of an initiative holds one of five states. Each stage below sets one:

- `proposed`: Drafting sets it when the human confirms the draft.
- `charted`: I-A Chart sets it when the human approves the chart.
- `active`: I-B Activate sets it when it writes `plan/current-initiative/initiative.md`.
- `delivered`: I-E Delivery sets it when it archives the initiative.
- `blocked`: any exception stop sets it.

The driver still requires status `active` before it runs a step.

### Filing a draft

- A draft lives at `plan/roadmap/{id}-{slug}/initiative.md`, one folder per draft.
- Initiative ids share the backlog's seven-digit sequence. Reserve each id with `node ravintio-zero/scripts/reserve-id.mjs [qty]`, which takes it from the counter file `plan/backlog/.next-id`.
- To reserve ids for the initiative and its step features, ask for one block of `qty` ids in a single call.
- If two branches reserve the same ids, git shows a conflict on `.next-id`. Keep the higher value and renumber the entries on the branch that merges second. This answer is pre-approved.
- Filing a draft has no prefix. It works on any branch and in any phase, as filing a backlog entry does.
- You may suggest a draft and help the human structure it. Write the draft only after the human confirms.
- The draft reaches `main` with the PR of the branch that holds it.

### Stages

| Stage | Prefix | Owner | Runs on | What happens |
|-------|--------|-------|---------|--------------|
| Chart | `I-A Chart:` | `ravintio-initiative` | `main` | Plan the initiative with the human and take their confirmation. |
| Activate | `I-B Activate:` | `ravintio-initiative` | initiative branch | Cut the initiative branch, write the active initiative, and start the driver and the watch script. |
| Run | `I-C Run:` | `ravintio-orchestrator` | feature branch | Run one step through P0 to P4. Up to `**Concurrency:**` steps run at once, each in its own worktree. |
| Advance | `I-D Advance:` | `ravintio-ship` | initiative branch | Raise the step PR and hand it to the merge queue, which merges it into the initiative branch and tags it. |
| Delivery | `I-E Delivery:` | `ravintio-initiative` | initiative branch | Archive the initiative and raise the initiative PR to `main`. |

#### Reply prefixes

Initiative stages use five more prefixes. They use the same `{prefix} {Status}: {one-liner}` form.

<!-- rule: reply-time-form -->
Every reply begins with the local time. The form is `hh:mm {prefix} {Status}: {one-liner}`. The `UserPromptSubmit` hook gives the time. The reply-prefix hook accepts a prefix with or without the time.

| Prefix | Stage |
|--------|-------|
| `I-A Chart:` | Chart |
| `I-B Activate:` | Activate |
| `I-C Run:` | Run |
| `I-D Advance:` | Advance |
| `I-E Delivery:` | Delivery |

- Example: `I-C Run: Starting: step 2 of initiative 0000050`
- Example: `I-B Activate: Blocked: no remote named origin`

### The three parts

Three parts run an initiative. The human talks only to their own session. Step sessions run with no human present.

| Part | What it is | Runs where | Owns |
|------|-----------|------------|------|
| `ravintio-initiative` skill | The initiative coordinator | The human's session | Chart, activate, watching the steps, progress reports, and delivery |
| Driver, `initiative-run.mjs` | A script with no AI | A background task that the initiative skill starts | Starting step sessions in worktrees, running the merge queue, and stopping on a `Blocked:` line |
| `ravintio-orchestrator` skill | The feature coordinator | Each step session, a separate `claude -p` process | One feature from P0 to P4, up to a step PR with green CI |

An initiative runs in this sequence:

1. **I-A Chart.** The initiative skill plans the steps with the human and takes their approval.
2. **I-B Activate.** The initiative skill cuts the initiative branch and starts the driver.
3. **I-C Run.** The driver starts each step whose lane is free and whose `After` steps have merged, up to `**Concurrency:**` at once. Each step session runs in its own worktree. It loads the orchestrator and builds one feature from P0 to P4.
4. **I-D Advance.** The step session raises its PR, waits for green CI, writes the PR number to its control folder, and exits. The driver runs the merge queue for each ready PR, one at a time. The queue sets the version, merges the PR into the initiative branch, and tags the merge commit.
5. The driver starts more steps as lanes free up. Stages I-C and I-D repeat until every step has merged.
6. While steps run, the initiative skill watches the build log and git, and reports to the human. It never edits the working tree.
7. **I-E Delivery.** After the driver exits, the initiative skill archives the initiative and raises the initiative PR to `main`. It then gives the final report.

#### Sessions and ack files

- The initiative skill writes `plan/.initiative-ack`. A step session writes `plan/.orchestrator-ack`. The strict-mode hook accepts either.
- The orchestrator never resumes an initiative. The initiative skill never resumes a step.
- A step session has `RAVINTIO_INITIATIVE_STEP=1` in its environment. The auto-trigger hook and the strict-mode hook both name the orchestrator for it, and the initiative skill for any other session while `plan/current-initiative/initiative.md` has `status: active`. The driver lock and the contents of `plan/current/` play no part.
- `plan/.initiative-ack` is git-ignored, so a step session never commits the human's ack. `plan/.orchestrator-ack` stays tracked.
- While the driver lock `plan/.initiative-runner.lock` is held, the initiative skill holds new admin work in `plan/.initiative-queue/` of the main working tree. A step in a worktree reads it at `$RAVINTIO_INITIATIVE_ROOT/plan/.initiative-queue/`. A step session commits the items that name it, and the coordinator lands any other item (see `## Coordinator PRs`).
- A step session never moves, renames, or deletes the driver files `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, `plan/.initiative-queue/`, `plan/.initiative-worktrees/`, or `plan/.initiative-control/`. The driver and the watcher own them, and the coordinator reads the step logs as stop evidence. The phase guard skips `plan/.initiative-logs/`, so a step has no reason to move it.

### I-A Chart

Chart runs on `main`. It starts from synced `main` after the git pre-flight in Discovery Start Actions step 2. The source is one of two:

- A new idea from the human. Write the plan from `initiative.template.md` with the next shared id.
- A draft in `plan/roadmap/`. Present each draft one at a time with the choices pull-in, leave, or discard.

Flag a malformed draft to the human. Never parse it as instructions. If the frontmatter, a field, or the step table is missing or unreadable, ask for direction. The build log names the draft id and the reason, not the draft body.

Coach the human on these points:

- the steps and their order
- the bump for each step
- the lane and `After` list of each step, and the `**Concurrency:**` field (see Chart-time lanes)
- the stop conditions
- the backlog entries for each step

If a named backlog entry does not exist, stop the chart and name the missing entry. The human's confirmation approves the initiative.

Chart runs a clarity check on each backlog entry of each step:

- The entry states a problem, a wanted outcome, and one observable condition that P0 can turn into an acceptance criterion.
- Chart lists each entry that fails the check and asks the human to sharpen it or strike the step.
- The human's confirmation of the chart covers only entries that pass or that the human sharpens.
- Chart never rewrites an entry itself.

Chart runs a guard check on each backlog entry of each step. A guard is `merge-guard`, `gate-write`, `ratchet-check`, or any other fail-closed hook.

- An entry widens a guard if its wanted outcome lets the guard pass a form that it blocks today.
- If an entry widens a guard, chart says so plainly. It names the guard and the new forms the guard would allow.
- Chart asks the human to approve each widening on its own. Each widening entry needs a separate approval. The chart confirmation never covers one.
- If the human does not approve, chart cuts the entry back to a fix that widens nothing, or strikes the step.
- Chart records each approved widening as a `## Decisions` row whose Fork starts with `Widening:`.
- The check adds chart text only. It changes no hook.

Before it coaches, Chart reads the latest records in `plan/retrospectives/`, newest first, and names any change they filed that is still open. If the folder is empty, Chart says so.

Chart also collects the schema approvals the steps need. See Chart-time schema approval. It collects the dependency approvals too. See Chart-time dependency approval. It builds the `## Decisions`, `## Baselines`, and `## Criteria` tables. See Chart-time decisions. It lists the step confirmations. See Chart-time confirmations. It fills the `## P1 skips` table. See Chart-time P1 skips. It sets the lanes. See Chart-time lanes.

### Chart-time schema approval

Hard Limit 3 needs a human to approve each schema change. The human is present at Chart and absent during the steps, so Chart collects these approvals up front.

At Chart:

1. Survey each step. Read the step's backlog entries and the data contracts of the components they touch. Draft the data change the step needs.
2. List each predicted change as a row in the `## Schema changes` table of `initiative.md`. A step with no change gets a row with Kind `none`. Kind is `additive`, `destructive`, or `none`.
3. Present the table. The human approves, edits, or strikes each row. The human's confirmation of the chart approves every row left in the table.
4. Ask one fallback question: "Also pre-approve additive changes that Chart didn't predict?" Record the answer in the `**Unpredicted additive changes:**` field as `pre-approved` or `stop`. The default is `stop`.

An additive change adds a field, a table, or an index. It removes nothing and changes no existing name or type.

In a step, the rule applies wherever the step writes a migration proposal, in P1 or P2:

- The step still writes the proposal at `src/{component-id}/docs/migrations/proposed-{desc}.md`, so the docs stay complete.
- A proposal matches a row when it has the same step, the same component, the same field names and types, and Kind `additive`.
- If the proposal matches a row, set its status to `approved (initiative chart)` and name the row in its approval section. Then carry on without stopping. Log `Schema change approved (initiative chart): {path}` in the build log.
- If no row matches an additive proposal and the fallback is `pre-approved`, set its status to `approved (initiative chart fallback)` and carry on. Log the same line with `fallback` added.
- Otherwise, take the normal schema-change exception stop. That covers a new field, a changed type, or a change no row predicted.
- A destructive change always stops, even when a row lists it. Hard Limit 4 allows no exceptions. A listed row only tells the human in advance.

### Chart-time dependency approval

A new library or service needs a human to approve it. The human is present at Chart and absent during the steps, so Chart collects these approvals up front.

At Chart:

1. Survey each step. Read the step's backlog entries and the manifests of the components they touch. Predict each library or service the step adds.
2. List each prediction as a row in the `## Dependencies` table of `initiative.md`. A step with no prediction gets one row with Kind `none`. Kind is `library`, `service`, or `none`.
3. Present the table. The human approves, edits, or strikes each row. The human's confirmation of the chart approves every row left in the table.

Chart asks no fallback question. A dependency that no row lists stops the step. The step takes the dependency exception stop in the orchestrator skill. In P0, copy the step's rows into the `Approved dependencies` field of `design.md`. The stop check still reads `initiative.md`.

### Chart-time decisions

A step stops when it meets a fork that no one approved. The human is present at Chart and absent during the steps, so Chart takes these decisions up front. Chart writes three tables in `initiative.md`: `## Decisions`, `## Baselines`, and `## Criteria`. The human's confirmation of the chart approves every row left in them.

At Chart, for each step:

1. **Pre-mortem.** Ask what would stop the step. Record each likely fork as a row in `## Decisions` with its pre-approved answer. Name one fork per row.
2. **Pre-approved fallbacks.** If a row's answer adds scope, name that scope in the row, as in "may also change `setup.sh`".
3. **Bump rule.** Give each row a bump effect, as in "rises to minor if the fallback scope is used". Use `none` if the bump stays as charted.
4. **Baseline.** A speed or size target needs a profile taken at Chart that shows where the cost goes. Record it in `## Baselines`. Take the target and the planned fix from that profile.
5. **Criterion critic.** Check each measurable criterion and record the result in `## Criteria`. Ask whether the step changes what the criterion measures, such as a total that grows with the step's new tests. Ask how noisy the measure is across runs, and whether the margin covers that noise.
6. **Environment check.** Check the local tools that the step's tests need. Mark a criterion `CI` in `## Criteria` if only CI can check it. Mark it `local` otherwise.
7. **Retrospective input.** Read the stops in the latest records in `plan/retrospectives/`. Turn each stop that can recur into a row in `## Decisions`.

Chart asks no fallback question. A fork that no row covers stops the step.

#### Worked example

Roadmap 0000168 stopped step 3 four times. These rows would have answered each stop, with no human present.

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 3 | CI misses the speed target on Windows | Profile on Windows and fix the top cost | none |
| 3 | The profile shows skill bundling as the top cost | Widen scope to drop skill bundling on every platform | rises to minor if the fallback scope is used |
| 3 | The wider scope changes the release | Raise the bump from patch to minor | minor |
| 3 | The speed target counts the step's own new tests | Measure per case, not as a fixed total | none |

The criterion critic would have caught the last row at Chart. A fixed total grows with the step's new tests, and runner noise exceeded the margin. The environment check would have caught the first failure of step 1. The machine had no `pwsh`, so the PowerShell criterion belongs to CI.

### Chart-time confirmations

A skill that a step loads can ask the human to confirm. A step session has no human to answer, so it stops and waits. Chart lists these confirmations up front.

At Chart, for each step:

1. Read the skills the step loads. Find each confirmation that a step's skills ask for, such as Step 4 of `ravintio-refresh-setup`.
2. Handle each confirmation in one of two ways:
   - Record a pre-approval as a `## Decisions` row. The Fork starts with `Confirmation:` and names the skill and its step. The answer holds the exact command.
   - Plan a human stop for that step, and say so in the row.
3. Take the human's confirmation of the chart as approval of every row.

A pre-approval covers its exact command only. A step that would run a different command takes the human stop.

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 15 | Confirmation: `ravintio-refresh-setup` Step 4 | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator` | none |

### Chart-time P1 skips

A step skips P1 only when chart allowed it. Chart fills the `## P1 skips` table with one row for each step. The Skip P1 column holds `yes` or `no`, and the Reason column says why.

- Chart may mark `yes` only for a chore with exact tasks in `initiative.md`, or a change with no code.
- A step that changes code, such as a hook, a script, or a test, gets `no`.
- The human's confirmation of the chart approves the column.

### Chart-time lanes

The driver runs steps at once when the chart allows it. Chart fills the `Lane` and `After` columns of `## Steps` and the `**Concurrency:**` field.

- **Lane.** Steps that edit the same files share a lane. Steps in one lane run one at a time in chart order. An empty cell gives the step a lane of its own.
- **After.** List the steps that must merge before this step starts, as numbers and ranges such as `6, 13` or `5-18`. An empty cell means no wait.
- **A step that changes most files.** List every earlier step in its `After`, and every later step lists it in theirs. It then runs alone.
- **Concurrency.** The most steps that run at once, a whole number from 1 to 9. The default is 3. A value of 1 runs one step at a time through the concurrent driver.
- **No field.** A chart without `**Concurrency:**` runs on the serial driver path, one step at a time, as charts did before 0000379.

The `Status` column holds `pending`, `running`, `ready`, or `merged`. The committed chart holds only `pending` and `merged`, and the merge queue writes `merged`. The driver derives `running` and `ready` from its control folders and never commits them. `scripts/initiative-chart.mjs` reads the table by header name.

### I-B Activate

Activate turns a charted initiative into a live branch. Run these checks first:

- A remote named `origin` exists.
- `gh` access works.
- No `initiative/{id}-*` branch exists on `origin`.
- No other initiative is active. The rule is one active initiative per working tree. If one is active, refuse and name the initiative that is already active.

If a check fails, stop with a `Blocked:` message, as in `I-B Activate: Blocked: {failed check}`, before any branch or file changes.

When the checks pass:

1. Cut `initiative/{id}-{slug}` from `main`.
2. Push the unchanged initiative branch to `origin`. Nothing commits directly on it.
3. On a `feat/` branch cut from the initiative branch, write `plan/current-initiative/initiative.md` with `status: active` and delete the draft folder `plan/roadmap/{id}-{slug}/`. Land the change as one commit in a coordinator PR, titled `{id}-{slug}: activate initiative (#{n})`.
4. After the PR merges, start the driver `ravintio-zero/scripts/initiative-run.mjs` and the watch script `ravintio-zero/scripts/initiative-watch.mjs` as background tasks, because a foreground Bash call times out after 10 minutes.

The initiative skill's session must not edit the working tree while the driver runs. It queues new backlog entries instead.

A repo instruction that the human asks for while a step runs goes into the scope of the current or next pending step in `plan/current-initiative/initiative.md`. The initiative session never writes the override itself, because `gate-write` blocks that write. While the lock is held, it queues the instruction in `plan/.initiative-queue/` and adds it to the next pending step when the driver is between steps or has exited.

### I-C Run

Run executes one initiative step. Concurrent steps are the normal flow: the driver starts each ready step in its own worktree (see Concurrent steps). A chart without `**Concurrency:**` runs one step at a time from `position`. Ship ends the step at a ready PR, and the merge queue merges it (see I-D Advance under Ship stages). The step differs from a normal run in these ways:

- <!-- rule: icrun-branch --> Cut the step's feature branch from the initiative branch, not from `main`. Under the concurrent driver, the driver cuts it and the session starts on it in its worktree.
- <!-- rule: icrun-run-mode --> P0 writes `autonomous` to `plan/.run-mode` without asking the run-mode question.
- <!-- rule: icrun-run-speed --> P0 writes the initiative's `**Speed:**` field, `fast` or `standard`, to `plan/.run-speed` without asking the run-speed question. If the field is absent or holds another value, P0 writes `standard`.
- <!-- rule: icrun-brief --> P0 builds `feature-brief.md` from the backlog entries that the step's row lists. The brief title is the `Title` column of the row. It pulls each entry in and deletes its folder in the same commit. It does not ask pull-in, leave, or discard.
- <!-- rule: icrun-self-confirm --> P0 self-confirms the design and the Scope Lock Challenge. Each scope lock line ends with `[source: draft-accepted (initiative)]`. The design confirmation records `draft-accepted (initiative)` in place of a human confirmation.
- <!-- rule: icrun-schema-row --> A schema change that matches a chart-approved row does not stop the step. See Chart-time schema approval.
- <!-- rule: icrun-decision-row --> A fork that matches a `## Decisions` row does not stop the step. Apply the row's answer and its bump effect, and log `Decision applied (initiative chart): {fork}` in the build log. The downgrade block still applies. The step stops only for a fork no row covers. A missing table counts as an empty one.
- <!-- rule: icrun-ci-criterion --> A criterion marked `CI` in `## Criteria` counts as validated only after the step's first CI run.
- <!-- rule: icrun-queue --> The step reads the queue at P0 and again before P4 raises the PR. Under the concurrent driver the queue is `$RAVINTIO_INITIATIVE_ROOT/plan/.initiative-queue/`, and otherwise it is `plan/.initiative-queue/`. It acts only on an item whose `**Step:**` line names its number. If the destination or the content holds `{id}`, it reserves one id with `node ravintio-zero/scripts/reserve-id.mjs` on its feature branch and replaces each `{id}`. It writes the item's content to the item's `**Destination:**` path and commits that path by explicit path on its feature branch, so the squash carries it. The step never moves, renames, or deletes the queue or an item. The coordinator clears the items after the step merges.
- <!-- rule: icrun-confirmation --> A confirmation that a skill asks for counts as a fork. If a `Confirmation:` row in `## Decisions` names the skill, its step, and the exact command, run that command with no stop and log `Decision applied (initiative chart): {fork}`. If the command differs in any way, the step stops.
- <!-- rule: icrun-p1-skip --> P1 runs unless the step's row in `## P1 skips` says `yes`. A step with no `yes` row that would skip P1 prints `I-C Run: Blocked: step {n} has no P1 skip row marked yes.` and stops. A missing table counts as an empty one.
- <!-- rule: icrun-p1-skipped-log --> If a step skips P1 on a `yes` row, the build log holds `Skipped: P1 (chart row: step {n}, {reason})`.
- <!-- rule: icrun-p0-stops --> P0 stops only when a backlog entry is too vague to draft a brief from. Print `Blocked:` with the entry and what is missing. The exception stops in Exception Stops still apply, including the credential stop.
- <!-- rule: icrun-bump --> P0 applies the step's `Bump` (`major`, `minor`, or `patch`, default `minor`) to the initiative branch's version to plan with. That is the last known version from Discovery Start Actions step 8. P4 writes no version. The merge queue sets the released version at merge, in merge order. The initiative branch's version comes from `product.yml`, or from `docs/about.md` when `product.yml` is absent. The downgrade block still applies.

All messages use the `I-C Run:` prefix.

### Concurrent steps

The driver runs the scheduler when the chart holds `**Concurrency:**` (0000379 ADR-002). Without the field it runs the serial path, one step at a time.

1. The driver reads the chart from `origin/{branch}`, or from the local branch when no origin ref exists. It fetches the branch before each read.
2. A step may start when its row is `pending` and every step in its `After` has merged. No running or ready step may share its lane. The driver starts such steps in chart order until the running count equals `**Concurrency:**`.
3. The driver cuts `feat/{feature-id}` from the initiative ref with `git worktree add` at `plan/.initiative-worktrees/step-{n}`. It copies `.claude/`, `CLAUDE.md`, `AGENTS.md`, and `.codex/` from the main root when present, and skips symlinks (0000379 ADR-004).
4. The session runs with its working directory in the worktree. Its environment holds `RAVINTIO_INITIATIVE_STEP=1` and `RAVINTIO_INITIATIVE_QUEUE=1`. It also holds `RAVINTIO_INITIATIVE_ROOT`, the main root, and `RAVINTIO_INITIATIVE_CONTROL`, the step's control folder.
5. The step ends at ready. It writes its PR number to `$RAVINTIO_INITIATIVE_CONTROL/ready` and prints `I-D Advance: Ready: PR #{n}` (see I-D Advance).
6. The driver reads `ready`, removes the step worktree, and queues the PR. The queue runs `merge-queue.mjs run --step {n} --pr {k}` in `plan/.initiative-worktrees/queue`, one PR at a time in ready order. A merge prints `I-D Advance: Complete: step {n} merged`, and the driver deletes the step's control folder.
7. The driver ends when every row has merged. It then prints the same `I-E Delivery:` lines as the serial path.

The driver owns these paths in the main root. It adds each to `.git/info/exclude` and refuses a symlink at any of them.

| Path | Holds |
|------|-------|
| `plan/.initiative-worktrees/step-{n}/` | The step's worktree, removed after the step merges |
| `plan/.initiative-worktrees/queue/` | The queue worktree, detached at the initiative ref |
| `plan/.initiative-control/step-{n}/` | `running`, with the driver pid, and `ready`, with the PR number |
| `plan/.initiative-logs/step-{n}.log` | The step's stream, then the queue output for its PR |
| `plan/.initiative-runner.lock` | The one driver lock. A step holds no lock. |

On a restart, a `ready` file queues the step with no new session. A `running` file without `ready` restarts the session in the existing worktree. A step that exits without `ready` and without a block follows the resume rule.

These events stop new starts:

- a `Blocked:` or `Question:` line from any step
- a failed session
- a queue failure, printed as `I-D Advance: Blocked: queue stopped on step {n}`
- a `Restart:` or `Setup:` hit after a merge

The driver prints `I-C Run: Stopping:` and starts no new step. Running steps still reach ready or stop, and the queue still merges them unless the queue failed. Before it exits 1, the driver prints `I-C Run: Step {n}: {state}` for every step. The state is `pending`, `running`, `ready`, `merged`, or `stopped`. It then prints the first stop line with the log of the step that caused it. Worktrees and control folders of unmerged steps stay.

### Driver environment

The driver reads two variables and passes them to every `claude -p` step.

| Variable | Effect | Default |
|----------|--------|---------|
| `RAVINTIO_INITIATIVE_MODEL` | Passed as `--model`. Matches `^[A-Za-z0-9][A-Za-z0-9._:\[\]-]{0,63}$`. | `sonnet` |
| `RAVINTIO_INITIATIVE_MAX_TURNS` | Passed as `--max-turns`. A positive integer of up to 4 digits. | No cap |

- An empty variable counts as unset.
- A value that fails its rule stops the driver before it takes the lock. The stop line names the variable and never prints the value.
- No default turn cap ships, because a fixed cap ends valid long steps. The human picks a cap per run.
- If `claude` exits non-zero while a cap is set, the stop line starts `I-C Run: Blocked:` and says the step may have reached `RAVINTIO_INITIATIVE_MAX_TURNS={n}`. The driver never retries the step or raises the cap.

#### Telemetry labels

The driver appends three labels to `OTEL_RESOURCE_ATTRIBUTES` in the child environment only.

- `work.kind=initiative`
- `ravintio.initiative={id}-{slug}`
- `ravintio.step={position}`

The driver keeps the old value byte for byte and joins the labels with commas. It percent-encodes each label value (`%` first, then `,`, `=`, and space). The labels hold identifiers only.

#### Resume

The driver resumes a step that ends its turn early. A step session exits 0 when the model ends its turn and no background task is pending. If `claude` exits 0, no `Blocked:` line exists, and the position did not move, the driver resumes the session.

- The driver reads the last `session_id` from the stream events in the step log. It checks the id against `^[A-Za-z0-9_-]{8,128}$` and passes it as one argument.
- The resume runs `claude -p` with the same flags, `--resume {session}`, and a prompt that tells the session to read the build log and continue. It writes to the same step log.
- The driver prints `I-C Run: Resuming: step {n} ended its turn unmerged, resume {k} of 2` before each resume.
- The cap is two resumes. If the step is still unmerged after the second, the driver prints `I-C Run: Blocked: step {n} exited without merging after 2 resumes` and exits 1.
- A non-zero exit, an open `Blocked:` or `Question:` line, or a missing session id never resumes. A `Question:` line with no later `Resolved:` line stops the driver at once, and the stop line repeats it. The continue prompt names `Question:` as a valid place to end a turn.
- A step session never ends its turn before `I-D Advance: Complete:`, a `Blocked:` line, or a `Question:` line. The orchestrator skill states the rule.
- Under the concurrent driver, the step ends at `I-D Advance: Ready:` instead. The driver resumes a step that exits 0 with no `ready` file and no block.

#### Restart stop

The driver loads its code once. After a merged step, it compares the initiative branch ref before and after the step. If the step changed `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/scripts/initiative-watch.mjs`, or `ravintio-zero/skills/ravintio-initiative/SKILL.md`, the driver stops.

- The stop line is `I-D Advance: Restart: step {n} changed {files}. Start a new driver so step {next} runs the new code.` The driver releases the lock and exits 1.
- The check runs after the delivery, block, and not-merged checks, so a delivered initiative never restarts.
- If git or the branch ref is unreadable, the driver skips the check.
- The initiative skill treats the line as a restart and not a failure. If the line also holds `Setup:`, it follows the setup stop first. It then starts a new driver and a new watcher without asking.
- The new driver reads the position from the branch ref and carries no other state. Its final report lists only the steps it ran.
- Under the concurrent driver, the hit stops new starts first, and the line reads `so the next step runs the new code`. The driver exits after the running steps reach ready or stop. The new driver queues each `ready` step with no new session.

#### Setup stop

The installed pack files live outside the repo copy the driver reads. After a merged step, the driver checks whether the step changed `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, or `ravintio-zero/setup/`. If it did, the driver stops.

- The stop line is `I-D Advance: Setup: step {n} changed {files}. Rerun setup, then start a new driver.`
- If the same step also triggers the restart stop, the driver prints one combined line: `I-D Advance: Restart: Setup: step {n} changed {files}. Rerun setup, then start a new driver so step {next} runs the new code.` The list holds the restart files first, then the setup-only files, with no repeats.
- The driver releases the lock and exits 1.
- The list shows at most 5 names, then `and {k} more`.
- The check runs after the delivery, block, and not-merged checks, so a delivered initiative never stops here. If git is unreadable, the driver skips the check.
- After the last step, the driver runs the check before it prints `I-E Delivery: Pending:`. If the step changed a setup file, the driver prints the `Setup:` line, exits 1, and prints no `Pending:` line. The initiative skill reruns setup and starts a new driver, which prints `Pending:`.
- The initiative skill treats the line as a setup step and not a failure. It reruns setup in this order:
  1. Read the setup command from the `Confirmation:` row.
  2. Run only that exact command. If the row is missing or differs, stop for the human.
  3. Check that every hook in `.claude/settings.json` resolves and runs.
  4. Start a new driver and a new watcher.

#### Step logs

The driver writes the child's stdout and stderr to `plan/.initiative-logs/step-{position}.log`, in arrival order. It starts `claude` with `--output-format stream-json --verbose`, so stdout holds one JSON event per line.

- `initiative-watch.mjs` reads new bytes of the current step's log every 10 seconds. It prints one `I-C Run: activity:` line per tool call, subagent start, and assistant text, in the order received. Each line is 200 characters or fewer. It never prints tool results.
- The watcher prints a stale line only when a commit is at least 15 minutes newer than the last build log write, and it prints each stale state once. If the last-seen commit is not an ancestor of `HEAD`, it prints one `branch changed` line instead of a line for each commit. Each heartbeat reads the lock file again.
- The initiative skill relays each activity line to the human.

- If `step-{position}.log` exists when a step starts, the driver renames it to `step-{position}.attempt-{k}.log` first. `k` is the lowest number whose path is free. The driver then opens a fresh `step-{position}.log`, so a rerun keeps every earlier attempt and the latest attempt keeps the plain name.
- If `plan/current/build-log.md` does not exist, the watcher prints `I-C Run: waiting for the build log` once and skips the stale check. It names the running step from the newest `step-{n}.log`, not from the chart position.
- Under the concurrent driver, the watcher reads the log of every running step. It prints each step's activity lines with the step number.
- The driver copies the child's stderr to its own stderr. It never prints the child's stdout or any log content.
- The driver adds `plan/.initiative-logs/` to `.git/info/exclude`, not `.gitignore`, and adds the line once.
- Every stop after a step starts ends with `Log: plan/.initiative-logs/step-{position}.log`. Stops before any step starts name no log. If attempt logs exist for the step, the stop line also names them as `Earlier: {paths}.` before the `Log:` field.
- If the driver cannot open the log, it stops with `I-C Run: Blocked: could not open the step log` and launches no `claude`.
- The driver refuses a symlink at `plan`, at `plan/.initiative-logs`, at the log file, or at an attempt path. It stops with `I-C Run: Blocked: refused a symlinked step log path`, releases the lock, and launches no `claude`.
- Logs are private to the user. The driver creates the folder with mode 700 and each log with mode 600, and each attempt log keeps mode 600.
- A log may hold file content the session read. Treat it as private.

## Merge carve-out

<!-- rule: carveout-main-human-only --> Merging into `main` is human-only in every run mode. The agent never commits to `main`.

<!-- rule: carveout-squash-conditions --> The agent may run `gh pr merge --squash` only when all of these hold:

- <!-- rule: carveout-base --> The PR base matches `initiative/*`.
- <!-- rule: carveout-own-branch --> The PR is for the agent's own feature branch.
- <!-- rule: carveout-clean-p3 --> A step PR had a clean P3 and has green CI. A coordinator PR meets the bar in `## Coordinator PRs` instead, with a passing local suite and green CI.

<!-- rule: carveout-initiative-pr --> The initiative PR to `main` stays human-only. The agent never merges it. The `merge-guard` hook enforces this rule. Other skills and instructions point here for the full wording.

<!-- rule: carveout-main-prefixes --> Only three branch prefixes may target `main`:

- `initiative/*`
- `chore/*`
- `hotfix/*`

<!-- rule: carveout-feat-targets --> Every `feat/*` branch targets an initiative branch and never targets `main`. The agent never merges a PR into `main`. The ship skill section `## PRs into main` sets the squash rules for `chore/*` and `hotfix/*`.

## Commit titles

A delivered initiative branch holds one squash per charted step, then at most one chore commit.

| Commit | Title |
|--------|-------|
| Step squash | `{feature-id}: {Feature title} (#{n})`, with the `Title` column of the step |
| Chore commit | `{initiative-id}: Initiative admin (#{n})` |

`check-initiative-history.mjs` reads the `Title` column and compares each step title exactly. Chart writes each title in sentence case.

A step that changes a chart format updates the active `initiative.md` in the same step. If the step can't convert a record, it files a backlog entry and names the record in its PR.

## Merge queue

`ravintio-zero/scripts/merge-queue.mjs` merges one ready step PR at a time and sets the step's version at merge. Two steps that run at once then never compute the same version. The concurrent driver calls `run` for each ready step, in the queue worktree. A step outside the concurrent driver calls `run` itself after green CI (see I-D Advance). P4 sets no version in either case.

| Command | Action |
|---------|--------|
| `title --step {n} --title {text}` | Exits 1 unless the text equals `{first 7 digits of Feature id}: {Title}` from the chart row |
| `versions` | Exits 1 and names each file in `ravintio-zero/version-files.txt` whose version differs |
| `run --step {n} --pr {k}` | Takes one PR through the actions below |

`run` takes these actions in order and stops on the first failure:

1. Check the PR title.
2. Merge the initiative branch into the PR branch and push, with no force. A conflict stops the queue. The merge commit has the subject `{first 7 digits of Feature id}: Merge the initiative branch`, which the `commit-msg` hook accepts.
3. Wait for CI with `gh pr checks {k} --watch --fail-fast`.
4. Apply the row's `Bump` to the initiative branch version and write the result to every file in `version-files.txt`.
5. Check that every version file holds the same version.
6. Write the row's `Version` and the status `merged`, and add a row to the `## Merges` table. The `Merge commit` cell reads `tag v{version}`. Set `**Position:**` to the lowest step that has not merged.
7. Commit those files by path, push, and squash-merge with `--delete-branch`.
8. Tag the merge commit `v{version}` and push the tag.

Each version follows merge order. `reshape-initiative.mjs` and `check-initiative-history.mjs` sort the steps by the `Version` column in ascending order, and a step with no `Version` follows the versioned steps in chart order.

## Coordinator PRs

Nothing commits directly on `initiative/*`. Every change arrives as a squashed PR, so the first-parent history is one titled squash per change.

Coordinator work covers activation, queued backlog entries, scope edits, and the I-E Delivery archive and retrospective. The coordinator lands it on a `feat/` branch cut from the initiative branch, through a PR whose base is the initiative branch.

Admin work takes one of two routes:

- **Aligned admin.** Admin work aligns with step N when step N caused it or it serves step N. Examples are the setup record after step N's `Setup:` stop, an id that step N reserves, a backlog entry filed from step N's work, a fix to step N's code or CI, and step N's edits to entries the coordinator filed. It goes in the step PR for step N. While the driver runs, the coordinator queues it as an item in `plan/.initiative-queue/`. An item is a folder. Its `item.md` holds `**Step:** {n}` and `**Destination:** {repo path}`, and the other files in the folder are the content. The step commits the item (see I-C Run).
- **Unaligned admin.** Admin that fits no step, such as the activation chart, lands through a `chore/` PR as it happens, while the driver is stopped. Later steps then run on current admin. At delivery, the one chore commit holds this work.

The next bullets apply to every coordinator PR.

- **Title.** Use the form `{id}-{slug}: {summary} (#{n})`. The id is the 7-digit initiative id.
- **One-commit PR.** In a one-commit PR, the commit subject uses the same `{id}-{slug}: {summary}` form. GitHub takes the squash title of a one-commit PR from the commit subject, not the PR title.
- **Local suite.** The full local suite passes before the PR opens.
- **CI.** CI is green before the agent squash-merges the PR with `gh pr merge --squash --delete-branch {n}`. The `--delete-branch` flag removes the coordinator branch from `origin`.
- **Timing.** Raise a coordinator PR only while the driver is stopped. While a step runs, queue aligned admin in `plan/.initiative-queue/` with the step named.

The `merge-guard` hook is unchanged. It already allows a squash into `initiative/*` because it checks only the PR base.

## Ship stages

These stages apply only when `plan/current-initiative/initiative.md` has `status: active`. Check the file before Step 6. Outside an initiative, ignore this section. A normal run keeps the order in the ship skill: clear sentinels at Step 8, PR at Step 9, and no merge by the agent. Step 7 creates no tag. CI tags the merge commit on `main` after the human merges.

In an initiative step, Steps 1 to 5 run as written. Step 9 gives way to the two stages below. Step 8 (clear the sentinels) runs and its commit is pushed before the PR is raised, so the squash does not carry the sentinels onto the initiative branch and the next step's P0 does not see a stale feature id. Step 6 sets no version. The merge queue applies the step's `Bump` at merge, and the downgrade check still applies. The merge carve-out is governed by the merge rule and the merge-guard hook, which allows `gh pr merge --squash` only for a `initiative/*` base.

### I-D Advance

Every message in this stage begins with `I-D Advance:` after the `P4 Ship:` prefix. The step raises the PR and waits for CI. The merge queue then merges it.

1. Leave `plan/current-initiative/initiative.md` alone. The step never sets its Status to `merged`, fills its Version, or moves `position`. The merge queue writes them in the same PR, before the squash. Step 6 bumps no version.
2. Run ship Step 8 now, then push the branch so the sentinel commit is on the remote. Raise the PR against the initiative branch only after that push and after the queue items that name the step are committed.

   ```bash
   gh pr create --base initiative/{id}-{slug} --title "{feature-id}: {Feature title}"
   ```

   The title is the step's `Title` column. The squash carries it.

3. Set the changelog `**PR:**` field to the PR number from the `gh pr create` output. Commit the change and push the branch. Never commit after the squash, because the squash carries the number onto the initiative branch.
4. Wait for CI in two parts.
   1. Poll `gh pr checks {n}` until at least one check is listed, for up to 2 minutes. Checks are always pending straight after `gh pr create`, so pending is not a stop. If none appears, push the branch, print the line below, and exit:

      ```
      I-D Advance: Blocked: no CI ran on PR #{n}. CI must trigger on pull requests to `initiative/**`.
      ```

   2. Run `gh pr checks {n} --watch --fail-fast`. A Claude session runs it with the longest Bash timeout, or as a background task if CI takes over 10 minutes. If a check fails, read the chart field `**Step CI fixes:**`. The values are `allowed` and `stop`, and the default is `stop`. With `allowed`, push a fix that stays inside the step's own scope and watch the checks again. With `stop`, or for a fix outside that scope, push the branch, print the line below, and exit:

      ```
      I-D Advance: Blocked: CI failed on PR #{n}. Fix the failing check, then tell me to retry.
      ```

5. If every check is green, check the PR title. Run `node ravintio-zero/scripts/merge-queue.mjs title --step {step} --title "{PR title}"`. If it exits 1, fix the PR title with `gh pr edit` and run it again.
6. Hand the PR to the merge queue. Write `{n}` and `{k}` as the literal PR number from the `gh pr create` output.
   - **Concurrent driver.** If `RAVINTIO_INITIATIVE_QUEUE` is `1`, write the PR number to `$RAVINTIO_INITIATIVE_CONTROL/ready` and print the line below. Then end the session. The driver removes the worktree and runs the queue.

     ```
     I-D Advance: Ready: PR #{n}
     ```

   - **No concurrent driver.** If `RAVINTIO_INITIATIVE_QUEUE` is unset, run the queue yourself. On a failure it exits 1 and names the reason. Stop with `I-D Advance: Blocked:` and that reason.

     ```bash
     node ravintio-zero/scripts/merge-queue.mjs run --step {step} --pr {k}
     ```

The queue sets the version and merges the PR with `gh pr merge --squash --delete-branch {n}`. It then tags the merge commit `v{version}`. The `--delete-branch` flag removes the feature branch from `origin`. The tag comes after the merge because a squash creates a new commit. If a push or merge fails, the queue stops and reports the exact error. Nothing retries with force.

Step 8 runs before the PR because the squash would otherwise carry `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode` onto the initiative branch. The next step's P0 would then see a stale feature id.

Consumer CI must trigger on pull requests to `initiative/**`. The pack's workflow template `ravintio-zero/hooks/ravintio.yml` includes that branch pattern. A project with its own workflow adds it.

7. With no concurrent driver, hand off to the next session after the queue merges.
   1. Check out the initiative branch and run `git pull --ff-only origin initiative/{id}-{slug}`.
   2. If the local feature branch still exists, delete it with `git branch -D`. It is redundant once squash-merged, and `gh` may already have removed it.
   3. If a step with Status `pending` remains, end the session with the line below. The driver starts the next session.

      ```
      I-D Advance: Complete: {feature-id} merged as v{version}, step {next} of {n} next
      ```

   4. If no pending step remains, end the session. The driver then prints `I-E Delivery: Pending:` and exits, and the initiative skill runs I-E Delivery. If the driver predates this rule and the last step session finds no initiative session to deliver, the step session runs I-E Delivery itself.

After the last step, `position` is one past the last step number. If a session starts in that state with `plan/current/` empty, the initiative skill runs I-E Delivery.

### I-E Delivery

The initiative skill runs this stage after the last step merges. Every message begins with `I-E Delivery:` after the `P4 Ship:` prefix. Concurrent steps merge in the order they become ready, not in chart order. Each delivery script reads merge order from the ascending `Version` column. Nothing commits directly on the initiative branch. Land steps 1 and 2 as coordinator PRs into it, as in `## Coordinator PRs`.

1. Move `plan/current-initiative/` to `plan/_archive/{id}-{slug}-initiative-{date}/` and set the initiative `status: delivered`. Update links that point at the old path. Land the move as a coordinator PR.
2. Run `ravintio-retrospective` in initiative mode. It writes `plan/retrospectives/{id}-{slug}-initiative-{date}.md`. Land the record as a coordinator PR, so the initiative PR carries it. A missing retrospective never blocks delivery.
3. Reshape the branch with the driver stopped. Run the script from the initiative branch.

   ```bash
   node ravintio-zero/scripts/reshape-initiative.mjs --branch initiative/{id}-{slug} --assign {hash}={step} --tags --push
   ```

   - The script replays each step in merge order onto the base the branch was cut from. Merge order is ascending `Version`. It finds each step commit through its `v{Version}` tag.
   - Pass one `--assign {hash}={step}` for each admin commit that aligns with a step. That commit folds into the step's new commit.
   - If a replay conflicts, the script tries folding each earlier admin commit into the next step. It keeps a fold only if the replay is clean and the final tree equals the old head. It prints one `fold:` line for each fold it keeps. Name every fold in the delivery PR body.
   - The script adds one chore commit whose tree equals the old head, so the final tree stays unchanged. Admin that aligns with no step lives only there.
   - The script writes `initiative/{id}-{slug}-reshaped` and leaves the old branch in place. It never force-pushes a branch or a tag.
   - With `--tags` it moves each local step tag. With `--push` it also pushes the new branch, deletes each old tag on `origin`, and pushes a new tag with the same name and message.
   - If no fold clears the conflict, the script exits 1 and names the commit. Stop for the human and drop no hunk.
   - A step tag then points at a tree that lacks the unassigned admin. The final tree is identical and CI runs on it.

4. Run `node ravintio-zero/scripts/check-initiative-history.mjs --head initiative/{id}-{slug}-reshaped` and the full suite on the reshaped branch. If the check reports a failing commit, list each failing commit in the PR body and stop. Do not merge or force-push to fix the history.
5. Raise one PR from the reshaped branch to `main`. Close any PR from the old branch with a link to the new one. The PR title says to merge with a merge commit, as in `{id}-{slug}: deliver initiative (merge with a merge commit)`.

   ```bash
   gh pr create --base main --head initiative/{id}-{slug}-reshaped
   ```

6. Make the first line of the body say to merge with a merge commit, not a squash, so each step tag stays reachable from `main`. Then list each step with its version and tag, and name the retrospective record. Scan the body for credential patterns before you raise the PR, as in Step 9.
7. Report the PR URL and end the run. After the human merges the PR, delete the old branch, `initiative/{id}-{slug}`, locally and on `origin`.

The `main` ruleset allows only the merge commit method. See `ravintio-zero/docs/main-ruleset.md`.

The agent never merges the initiative PR and never commits to `main`. The human reviews and merges it.
