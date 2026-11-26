---
title: "Backlog Entry: 0000605 - Optional local web console for Zero"
summary: "An opt-in localhost web page to monitor initiative and pipeline progress and to send the driver the controls it already accepts."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000605 - Optional local web console for Zero

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-26

---

## Problem

The human follows an initiative through the coordinator's chat replies. To see a step's phase, a queue stop, or a ready PR, the human asks the coordinator. The coordinator then runs `initiative-status.mjs` and reads the step logs. Progress is invisible between replies. Each control, such as a pause or a driver restart, also needs a coordinator turn.

## Suggested Action

Add an optional web console that runs as a localhost website. Setup never installs or starts it. The human starts it with a command such as `node ravintio-zero/scripts/console.mjs`.

### Monitoring

The console reads the files the driver and the steps already write. It adds no new state of its own.

- **Driver:** lock holder and pid from `plan/.initiative-runner.lock`, and whether the pid is alive.
- **Steps:** the chart from the initiative branch ref, and each step's state from `plan/.initiative-control/step-{n}/`. States include pending, running, ready with a PR number, stopped, and merged.
- **Running step detail:** phase, units done out of planned in P2, and criteria verified in P3. The console reads these from the step's build log in its worktree.
- **Live log:** a tail of `plan/.initiative-logs/step-{n}.log`, parsed from stream-json into readable lines, with tool calls and hook blocks marked.
- **Events:** the same lines `initiative-watch.mjs` emits, such as ready, queue stop, and driver exit.
- **Merge queue:** pending items in `plan/.initiative-queue/`, and each step PR with its CI state through `gh`.
- **Health:** disk space, and the size of each worktree and its temp folder.

The page updates through server-sent events. The server watches the files and polls `gh` at most once a minute.

### Control

Each control calls the same script that the coordinator runs. The console adds no new path into a step, so every guard still applies.

- Request and cancel a pause with `initiative-pause.mjs`.
- Start the driver when no lock exists. Stop the driver through its own stop signal, never by killing step processes.
- Queue an instruction or a backlog entry for a step in `plan/.initiative-queue/`.
- Drain a merged step's queue items with `initiative-queue.mjs drain`.

The console never offers:

- a merge into `main`
- a direct merge of a step PR, which stays with the merge queue
- an edit of the working tree while the driver holds the lock
- a resume or a prompt into a running step session

### Security

- The server binds to `127.0.0.1` only, never `0.0.0.0`.
- Each start prints a URL with a random token. Every request needs that token.
- Every control is a POST that checks the `Origin` header, which blocks cross-site requests from other pages.
- The page shows no credentials. It strips tokens and keys from the log tail.
- A read-only mode turns off every control.

### Shape

- Use Node with no new runtime dependencies, to match the other pack scripts.
- Serve one static page with no build step.
- Each control area lives in its own module, so a later skill can reuse the readers.
- The same console can show a single gated run outside an initiative, from `plan/current/`.

## Tests

- A test starts the console on a fixture repo and checks that the status JSON matches `initiative-status.mjs`.
- A test checks that a request without the token, or with a foreign `Origin`, gets a 403.
- A test checks that the server listens only on the loopback address.
- A test checks that a pause control writes the same file as `initiative-pause.mjs request`.
- A test checks that no control exists for a merge, a resume, or a working-tree edit.

## Why Deferred

The human asked for the entry on 2026-11-26 during initiative 0000544. It is a new feature, so it waits for a future initiative.
