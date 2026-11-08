---
title: "ADR 002: Telemetry cleanup skips an unreadable settings.json"
summary: "The legacy telemetry cleanup in both setup scripts skips in silence when settings.json fails the parse or the 0000040 shape rule. The hook install step reports the fault once. A read or write error still warns and continues."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000041-setup-cleanup-and-park-hardening"
---
# ADR-0143 - Telemetry cleanup skips an unreadable settings.json

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Component:** planifest-zero
**Date:** 2026-10-22

## Context

ADR-0116 made both setup scripts clean legacy telemetry entries out of `settings.json` on every run. A failure warns and setup continues. The cleanup runs before the hook install step, and ADR-0138 gave the install step the shape check line.

The cleanup treats a file it cannot read as a failed cleanup. A `settings.json` holding `null` or `{bad` prints "could not remove telemetry hook entries" first. The install step then prints the correct line. The first line names the wrong fault (backlog 0000127).

In `setup.ps1` the problem is worse. The cleanup rewrites a file the install step rejects. A one-item top-level array becomes an object, and the user's data changes (backlog 0000128).

During P2 the human chose to widen the skip from shape failures to parse failures. A parse failure produces the same wrong first line as a shape failure.

## Decision

Both cleanups skip in silence when `settings.json` fails the parse or the 0000040 shape rule. A skip prints nothing to stdout or stderr and writes nothing. The cleanup counts it as "nothing to clean".

The shape rule has two parts:

- The top level is a plain object.
- `hooks` is absent, `null`, or a plain object.

The hook install step that runs next is the one reporter of every parse or shape fault. Each fault then yields one correct line and exit 1.

A real failure still warns and continues. A real failure is a read or write error. This extends ADR-0116 with a reading of "failure" and does not supersede it. The cleanup still runs on every setup run, and the install step stays the last writer of `settings.json`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep today's warning on parse failures | No change to the cleanup's parse path | One fault prints two lines, and the first line is wrong | The first line names a fault the user does not have |
| Move the cleanup after the hook install step | The install step reports first, so the cleanup never sees a bad file | The install step exits 1 on a bad file, so the cleanup never runs. ADR-0116 also says the install must be the last writer of `settings.json` | It breaks ADR-0116 |
| Have the cleanup print the shape line itself | The cleanup reports its own skip | Each script holds the message in two places, and the copies can drift | It duplicates the message |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` gain the shape and parse skip in their cleanups. Both suites gain cases that assert one line per fault and a byte-identical file |

## Consequences

**Positive:**
- Each parse or shape fault prints one correct line.
- `setup.ps1` no longer rewrites a file the install step rejects.
- The install step stays the only place that reports a parse or shape fault.

**Negative:**
- A parse failure no longer says the telemetry cleanup did not run. A stale telemetry entry survives until the user fixes the file and reruns setup.
- The cleanup now depends on the install step to report a fault. A change to the install step can leave a fault with no line.

**Risks:**
- The cleanup's shape test drifts from the install step's test. Both scripts assert the exact output for the same inputs, so a drift fails a test.
- The PowerShell reading of 0000128 is untested locally. CI runs the PowerShell suite before acceptance.

## Related ADRs

- ADR-0116 - extends (a read or write error still warns and continues)
- ADR-0138 - depends-on (the shape rule and the shape check line)
- ADR-0134 - related-to (invalid JSON keeps its own line)

## Supersedes

- None

## Superseded By

- None
