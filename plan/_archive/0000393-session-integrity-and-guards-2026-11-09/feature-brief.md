---
title: "Feature Brief - Session integrity and guards"
summary: "Close two guard gaps and two detection gaps found in earlier initiatives."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Session integrity and guards

**Feature ID:** 0000393-session-integrity-and-guards

## Business Goal

Four small defects let a bad write, a forced add, a false pack-version finding, or an unchecked backlog entry reach a session unnoticed. Fix each so the guard or check fails closed and tests prove it. No guard passes a form it blocks today.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Shell writes meet gate-write (0000271) | As a maintainer, I want a Bash write to a gated path checked like a Write call, so that a heredoc cannot skip the design gate. | must-have | 1 |
| Forced-add guard reads option values and brace groups (0000367) | As a maintainer, I want `git --git-dir .git add $F` and `git add {-f,x}` blocked, so that no form forces an ignored file in. | must-have | 1 |
| Pack version has its own record (0000272) | As a consumer, I want resume detection to compare the pack with a `plan/state/` record, so that a product version never raises a pack finding. | must-have | 1 |
| Backlog prose is tested at filing (0000260) | As a maintainer, I want the filing skill to run the wording check, so that a bad entry fails when filed. | should-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Hooks, scripts, skills, standards, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/state/pack-version.md` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js ESM (`.mjs`) and Bash |
| Testing | Bash test files run by `ravintio-zero/tests/run-tests.sh` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A PreToolUse check on Bash for shell writes, applying gate-write rules
- Forced-add guard fixes for option values and brace groups
- A `plan/state/` record of the last confirmed pack version, and the resume-detect change
- A wording check run by the filing skill

### Out of Scope
- Any change that lets a guard pass a form it blocks today
- Windows-specific hook changes beyond parity tests that already exist

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Guard strictness | 0 forms newly passed | Existing guard tests stay green |
| Hook latency | Bash check adds under 100 ms | A timed fixture run |

## Constraints and Assumptions

### Constraints
- A guard never gains an allowed form.
- Bash and PowerShell setups wire the same hooks (parity suite).

### Assumptions
- Claude Code passes `tool_input.command` to Bash PreToolUse hooks.

## Scenario Paths

**Happy path:** A Bash write to a gated path with no design exits 2 and names the rule. A clean write to `plan/backlog/` exits 0.

> A step writes `cat > src/x <<EOF` with no design. The hook blocks it.

**First-run path:** A repo with no `plan/state/pack-version.md` has no baseline.

> Resume detection reports no pack version finding and says the record is missing only when a pack version exists. Ship or the human writes the record.

**Error / sad path:** Malformed stdin or an unparseable command.

> Gate checks exit 0 on malformed input, as gate-write does today. The forced-add guard keeps its fail-closed catch.

**Cross-session continuity:** None of the four changes holds session state beyond one file.

> The `plan/state/` record is tracked, so it survives a session change.

## Acceptance Criteria

- [ ] A Bash `cat >` to a gated `src/` path with no design exits 2.
- [ ] A Bash write to `plan/backlog/` exits 0, and every case gate-write blocks today stays blocked.
- [ ] `git --git-dir .git add $F`, `--work-tree`, `--namespace`, and `git add {-f,x}` exit 2.
- [ ] With pack `0.37.0`, product `0.4.0`, and record `0.37.0`, resume-detect prints no pack version finding. With record `0.36.0` it prints one.
- [ ] The pack update policy and the `about.md` template say `docs/about.md` holds the product version only.
- [ ] A fixture entry with a banned phrase makes the filing check exit non-zero and name file and line. A clean entry passes.
