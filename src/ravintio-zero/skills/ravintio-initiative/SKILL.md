---
name: ravintio-initiative
description: Coordinates an initiative from chart to delivery in the human's session. Charts the steps, activates the branch, starts the driver and a watch monitor, reports progress, queues backlog entries, and delivers the initiative PR. Never resumes or runs a step. Loaded when an initiative is active and the session is not a step session.
---

# RAVINTIO - initiative

> You coordinate an initiative the way the orchestrator coordinates a feature. You talk to the human. Step sessions run with no human present, and you never run one.

**Prefix.** Begin every reply with the stage prefix: `I-A Chart:`, `I-B Activate:`, `I-C Run:` while steps run, or `I-E Delivery:` for delivery and the final report. Use the form `hh:mm {prefix} {Status}: {one-liner}`, with the time from `date +%H:%M`, read before each reply. **Pack files.** Read `ravintio-zero/standards/roadmap-standards.md` first. Read `ravintio-zero/templates/initiative.template.md` before you write a plan.

## The three parts

| Part | Runs where | Owns |
|------|-----------|------|
| This skill | The human's session | I-A Chart, I-B Activate, reports, queue, I-E Delivery |
| Driver `ravintio-zero/scripts/initiative-run.mjs` | A background task you start | Up to `**Concurrency:**` step sessions at once, each in a worktree, the merge queue, and the stop on a `Blocked:` line |
| `ravintio-orchestrator` | Each step session, a separate `claude -p` process | One feature from P0 to P4, then I-C Run and I-D Advance |

## Hard limits
1. Never run, resume, or edit a step. A step session owns `plan/current/`.
2. Never edit the working tree while the driver holds the lock `plan/.initiative-runner.lock`.
3. Never merge into `main` and never commit to `main`. The human merges the initiative PR.
4. Write `plan/.initiative-ack` with your session id. Never write `plan/.orchestrator-ack`.
5. A step session never moves, renames, or deletes `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, `plan/.initiative-queue/`, `plan/.initiative-worktrees/`, or `plan/.initiative-control/`. The driver and the watcher own them.
6. The hard limits of the orchestrator apply here too.

## Session start
1. Read the resume findings that the session start hook injected. If none are in context, run `node ravintio-zero/scripts/resume-detect.mjs`. If a finding reads `resume detection did not run`, check the files yourself.
2. If a `pending migration` finding names a migration whose `Applies when:` condition is true, run `ravintio-migrator` first.
3. Read `plan/current-initiative/initiative.md`. If no `initiative active` finding is present, offer I-A Chart and say whether an earlier initiative exists.
4. If the findings hold `initiative active` and `driver lock held`, report and start the monitor. Do not start a second driver.
5. If they hold `initiative active` and `driver lock free`, report the `initiative position` and offer to restart the driver.
6. If `position` is past the last step and `initiative.md` remains, run I-E Delivery.

## I-A Chart and I-B Activate

Follow the I-A Chart and I-B Activate sections of the roadmap standards. Activation lands as a coordinator PR. Chart builds the `## Decisions`, `## Baselines`, `## Criteria`, and `## P1 skips` tables. Chart also does these:

- **Guard.** Run a guard check on each entry. Check whether it widens a guard, such as `merge-guard`, `gate-write`, `ratchet-check`, or another fail-closed hook. Name the guard and the new forms it would allow. Ask for a separate approval for each widening, apart from the chart confirmation.
- **Lanes.** Coach a `Lane` and an `After` list for each step, and the `**Concurrency:**` field (default 3). Steps that edit the same files share a lane. A step that changes most files lists every earlier step in `After`, and every later step lists it. See Chart-time lanes.
- **Confirmation.** Plan each step confirmation, per rule `agree-explicit` in `orchestrator-p0-coaching.md`. List each one that a step's skills ask for. Record the exact command as a `Confirmation:` row in `## Decisions`, or plan a human stop for that step.

**Questions.** Restate the human's words as one concrete plan, name the default, and ask "Go?". Offer other options only for a real fork. Ask at most one question per reply. Never ask about what the human already said. **Activate.** Run `node ravintio-zero/scripts/initiative-activate.mjs --yes` after one "Go?". Add a step with `node ravintio-zero/scripts/initiative-add-step.mjs`. For a coordinator PR, run `node ravintio-zero/scripts/coordinator-pr-check.mjs {base}`. If it prints `plan-only`, skip the full suite. See Coordinator questions and commands in the roadmap standards.

Concurrent steps are the normal flow. The driver starts each ready step in its own worktree, up to `**Concurrency:**` at once, and runs the merge queue for each ready PR. At Activate, start two background tasks:

- The driver: `node ravintio-zero/scripts/initiative-run.mjs`.
- The monitor: `node ravintio-zero/scripts/initiative-watch.mjs`. It prints one line per event and a heartbeat every 5 minutes.

A host monitor expires after 30 minutes. Start a new one until the driver exits. If the host has no monitor tool, report on each prompt and at each phase end.

## Reports

Report at least every 5 minutes while the driver runs, at each phase end, and on request. Report an event at once when the build log gains a phase `Complete:`, `Blocked:`, or `Resolved:` line. When the build log changes to a new step, also report the `Complete:` lines already in it.

An interval report names:

- each running step and its phase
- the last build log line and its age
- the commits since the last report
- any stop
- whether the driver still runs

While steps run, the monitor also prints `I-C Run: activity:` lines with the step number, one per tool call, subagent start, or assistant text. Relay each one to the human at once, in the order received. Do not wait for the next interval report.

If nothing changed, say so and give the time since the last change. If the step keeps committing and its build log has not changed for 15 minutes, say the log is stale.

A progress report, on request and at each phase end, has two parts:

- **Initiative:** steps merged out of the total, backlog entries done out of the total, and a table of each step's feature, entries, version, and status.
- **Current step:** report each running step and each ready step waiting for the queue. For each running step, give the phase, the progress within it, and what comes next. Progress is units done out of planned in P2, and criteria verified out of total from P3. Add highlights, such as what the step changes for the user, and any risk.

## Stops

If the driver prints `Blocked:` or exits non-zero, report the stop line and the step log path `plan/.initiative-logs/step-{n}.log`. Relay each `I-C Run: Step {n}: {state}` line too, which names every step's state. Never resume the step. Ask the human how to proceed. After the human acts, offer to restart the driver.

A `Restart:` line is not a failure. It means a merged step changed the driver, the watcher, or this skill, and the running code is old. Report the line. Then start a new driver and a new watcher without asking. Read this skill again first if the line names it.

The driver runs the approved setup command itself when the `Confirmation:` row names it, and prints `ran the approved setup command`. A `Setup:` line (`I-D Advance: Setup: step {n} changed {files}. Rerun setup, then start a new driver.`) means the driver did not run it. The line is a planned stop, not a failure. Report the line, then:

1. Read the setup command from the `Confirmation:` row in `## Decisions` of `plan/current-initiative/initiative.md`.
2. Run that exact command. If no row names it, or the command differs in any way, stop and ask the human.
3. Check that every hook in `.claude/settings.json` resolves and runs. If one fails, stop and report the hook.
4. Start a new driver and a new watcher.

A line that starts `Restart: Setup:` names both. Rerun setup first. Read this skill again if the line names it. Then start one new driver.

## Backlog queue

While the driver holds the lock, queue admin work. Do not edit the working tree and do not reserve an id. Write each item as a folder in `plan/.initiative-queue/`. Its `item.md` holds `**Step:** {n}` and `**Destination:** {repo path}`, and the other files are the content. For a new backlog entry, set the destination to `plan/backlog/{id}-{slug}/entry.md` and write `{id}` where the id goes. The step reserves the id and fills it in.

Name the step that the work aligns with, or the next pending step. After a step merges, clear the items that named it. Never move or delete an item while a step runs. Admin that fits no step waits until the driver stops, then lands through a `chore/` PR.

`reserve-id.mjs --commit` refuses on `initiative/*`. When the driver has stopped, run it on a `feat/` branch so the counter commit rides in the coordinator PR.

Nothing commits directly on the initiative branch. Activation, scope edits, and the I-E Delivery archive and retrospective follow `## Coordinator PRs` in the roadmap standards. Raise one only after the driver has stopped, and merge it with `gh pr merge --squash --delete-branch {n}`.

## Repo instructions during a run

If the human asks for a repo instruction while a step runs, add it to a step's scope in `plan/current-initiative/initiative.md`. Pick the current or next pending step. The skill never writes the override from the initiative session, because `gate-write` blocks that write. The step writes the file.

- If the driver holds the lock, queue the instruction in `plan/.initiative-queue/{slug}/instruction.md`. The step that runs has already read its scope, so the instruction goes to the next pending step.
- When the driver is between steps or has exited, add the instruction to that step's scope in `initiative.md`. Land the edit as a coordinator PR.
- Tell the human which step took the instruction.

## I-E Delivery

After the driver exits, follow the I-E Delivery section of the roadmap standards. It reshapes the branch with `reshape-initiative.mjs` in merge order and names each admin fold in the PR body. It also moves the step tags, runs the history check, and sets the merge commit title. Raise the PR from `initiative/{id}-{slug}-reshaped`. After the human merges it, delete the old branch. Then give the final report:

1. The initiative PR URL.
2. Each step with its version and tag.
3. The retrospective record path.
4. The stops that occurred and how each ended.
5. The backlog entries queued and where they now live.

Ask the human to merge the PR with a merge commit. Do not merge it yourself.
