---
title: "ADR 005: Roadmap driver child contract"
summary: "The driver passes --model and --max-turns, writes per-step logs excluded through .git/info/exclude, and appends percent-encoded labels to OTEL_RESOURCE_ATTRIBUTES."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0160 - Roadmap driver child contract

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

ADR-0152 gave each roadmap step a fresh `claude -p` session. That session has no model choice, no turn limit, no log, and no cost label. One step can spend a large share of an allowance, and a blocked step leaves no record of what the child did.

The driver also runs in user projects. Edits to a user's `.gitignore` would show up in their diffs.

## Decision

The driver defines four parts of the contract with each child.

- **Model.** `--model` comes from `PLANIFEST_ROADMAP_MODEL` and defaults to `sonnet`. The driver validates the value and passes it as one argument, never through a shell.
- **Turn cap.** `--max-turns` comes from `PLANIFEST_ROADMAP_MAX_TURNS`. If unset, no cap applies and no default ships. A non-zero exit with a cap set stops with `R-C Run: Blocked:` and names the cap.
- **Logs.** Each step writes stdout and stderr to `plan/.roadmap-logs/step-{position}.log`. The driver excludes the folder through `.git/info/exclude`, not `.gitignore`, so the user's `.gitignore` stays untouched. Every stop after a step starts names the log.
- **Labels.** The driver appends `work.kind=roadmap`, `planifest.roadmap={id}-{slug}`, and `planifest.step={position}` to `OTEL_RESOURCE_ATTRIBUTES` in the child environment only. A named function percent-encodes each value and keeps the old value byte for byte.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Default turn cap | Protects every run | A fixed cap ends valid long steps | The human picks a cap per run |
| Add the log folder to `.gitignore` | Standard git practice | Changes the user's tracked file | `.git/info/exclude` is local and leaves the diff clean |
| Replace `OTEL_RESOURCE_ATTRIBUTES` | Simpler code | Drops attributes the user set | Appending keeps the user's labels |
| Default to the parent session model | No new variable | Opus-sized cost for headless steps | A Sonnet default cuts cost and the variable allows a change |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `roadmap-run.mjs` changes `runStep` and the stop lines. `roadmap-labels.mjs` is new. `roadmap-standards.md` documents the variables, logs, and labels |

## Consequences

**Positive:**
- Headless steps cost less by default.
- A maintainer can read why a step blocked.
- Telemetry attributes cost to a roadmap and step.

**Negative:**
- The driver now pipes child output, so it must forward stderr itself.
- Logs may hold file content the session read. The folder stays out of git and nothing uploads it.
- A user who wants Opus must set a variable.

**Risks:**
- If `claude -p` rejects `--model` or `--max-turns`, every step fails. A check against `claude --help` and one real call covers this, because tests use a stub.
- If Claude Code ignores `OTEL_RESOURCE_ATTRIBUTES`, the labels reach no record and the tests still pass.

## Related ADRs

- ADR-0152 - extends (adds model, cap, log, and labels to the child contract)
- ADR-0156 - related-to (the encoder is a new Node module)

## Supersedes

- None

## Superseded By

- None
