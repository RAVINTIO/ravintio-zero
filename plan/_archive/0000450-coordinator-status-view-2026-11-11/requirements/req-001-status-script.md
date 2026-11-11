---
title: "Requirement: REQ-001 - Status script"
summary: "One command prints the queue, ready PRs, running steps, and live stops."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Status script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I run one command that shows the queue, ready PRs, running steps, and live stops. I then report the true state.

## Functional Requirements
- `node ravintio-zero/scripts/initiative-status.mjs [--root dir]` reads `plan/current-initiative/initiative.md`, `plan/.initiative-control/`, `plan/.initiative-runner.lock`, and the step logs. It writes no file.
- The chart `Status` column decides which steps have merged. A merged step never shows as ready or running.
- It prints `I-C Run: status:` lines. One line gives the driver state. One line gives the four step counts. Further lines name each ready step with its PR number and each running step.
- A live stop is an open `Blocked:` or `Question:` line in the build log of a step that still has work to do. A later `Resolved:` line clears it. The line also covers a `queue stopped on step {n}` line in the step log.
- It prints one `stop step {n}` line for each live stop, cut to 200 characters. With none it prints `no live stops`.
- It refuses a symlink at a plan path, treats file text as data, and exits 1 with a `Blocked:` line on a bad argument.

## Acceptance Criteria
- [ ] AC-1: the view lists each step state
  - Given a chart with merged, ready, running, and pending steps
  - When the script runs
  - Then it prints the four counts, each ready PR number, and each running step
- [ ] AC-2: a merged step shows no stop
  - Given a step log with a queue stop for a step that the chart marks merged
  - When the script runs
  - Then it prints `no live stops`
- [ ] AC-3: a live stop shows with its reason
  - Given an open `Blocked:` line in a running step's build log
  - When the script runs
  - Then it prints a `stop step {n}` line with that text

## Dependencies
- `initiative-chart.mjs` parses the chart.
