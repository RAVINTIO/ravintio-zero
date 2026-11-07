---
title: "Backlog Entry: 0000398 - smoother initiative activation with clearer suggestions"
summary: "Activation takes one human confirmation, and each question leads with a recommended plan written in the human's own terms."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000398 - smoother initiative activation with clearer suggestions

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-B Activate
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

The human found the I-B Activate of initiative 0000360 painful. The human asked for "way smoother and easier" activation, with clearer suggestions so decisions are quicker. Here is what slowed it down:

- **Off-target questions.** The human asked to move the pack with `git mv` and keep a copy at the root. The coordinator asked three questions before it read the request as one plan. One question offered options that did not match what the human had said.
- **Questions with no default.** Questions listed options without a clear recommended plan, so the human had to design the answer.
- **Manual chart edits.** Adding one step mid-activation took an id reservation, a backlog entry, an index rebuild, and edits to 10 chart tables by hand.
- **Slow suite reruns.** The full local suite takes over 10 minutes. It ran twice, because a chart edit landed after the first run.
- **Noisy findings.** `resume-detect.mjs` reports migrations 0004 and 0005 as pending in every session, although their `Detect:` lines do not match this repo.
- **Start-up hook mismatch.** The start-up hook tells the coordinator session to load the orchestrator. The initiative skill already owns that session.

## Suggested Action

1. Add one activate command that does the whole activation in order:
   - runs the checks
   - cuts and pushes the branch
   - moves the chart and sets its status
   - opens the coordinator PR, waits for CI, and merges it
   - starts the driver and the watcher
2. Add an `add-step` helper. It reserves the ids, files the entry, and writes the step's row in every chart table.
3. Change the question rule in the initiative skill. Restate the human's words as one concrete plan, name the default, and ask "Go?". Offer other options only when the request leaves a real fork open.
4. Ask at most one question per reply. Never ask about something the human has already stated.
5. Let a coordinator PR skip the full suite rerun when later commits touch only `plan/` files. Run the plan format checks instead.
6. Make `resume-detect.mjs` print nothing for a migration whose `Detect:` line does not match.
7. Make the start-up hook load the initiative skill when the session is a coordinator.

## Wanted outcome

- Activating a charted initiative takes one human confirmation and no manual table edits.
- A test adds a step with `add-step`, and the chart format checks pass on the result.
- `resume-detect.mjs` prints no line for a migration that does not apply. A test checks this.
- The initiative skill's question rule names the restate, default, and confirm form, and a skill test pins it.

## Why Deferred

The human asked for this during I-B Activate of initiative 0000360.
