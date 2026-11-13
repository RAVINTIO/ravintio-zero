---
title: "ADR 002: Valid JSON that is not a settings object exits 1"
summary: "Both setup scripts print one shared fixed line and exit 1 when settings.json is valid JSON but not a plain-object settings file, and they leave the file unchanged."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000040-setup-json-checks-and-park"
---
# ADR-0138 - Valid JSON that is not a settings object exits 1

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Component:** planifest-zero
**Date:** 2026-10-21

## Context

ADR-0134 made both scripts exit 1 with a fixed line on invalid JSON. Two gaps remain. In `setup.sh`, valid JSON such as `[]` or `5` passes the parse. The inline node step then fails to wire hooks, yet setup reports them installed (backlog 0000121). In `setup.ps1`, a file that `ConvertFrom-Json` cannot read as an object gets the invalid-JSON message, though the JSON is valid (backlog 0000120).

Setup cannot wire enforcement hooks into a file it cannot read as a settings object. Setup must also never print file content (0000033 req-004).

## Decision

Both scripts run a shape check before any write. The check fails when the top level is not a plain object. It also fails when `hooks` is present and not a plain object. A `hooks` value of `null` counts as absent, as today.

On failure, both scripts print one shared fixed line to stderr and exit 1:

`! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.`

The file stays unchanged. The line never includes file content or a parser message. This extends ADR-0134 and does not replace it. Invalid JSON keeps its own message.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Reuse the invalid-JSON message | No new line to test | It calls valid JSON invalid, which is the 0000120 bug | Names the wrong fault |
| Coerce a non-object to an empty object | Setup always finishes | Overwrites the user's data | Loses user data |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` gain the shape check. Both suites gain cases that assert the exact line |

## Consequences

**Positive:**
- Setup never reports hooks as installed when it left the file unchanged.
- The message names the real fault, and both scripts give the same line.
- No byte of `settings.json` reaches the output.

**Negative:**
- Setup stops before later steps run, so the user reruns the whole script after the fix.
- The line gives no hint about which part of the file has the wrong shape.

**Risks:**
- The two messages drift apart. Parity tests assert the exact line in both scripts.

## Related ADRs

- ADR-0134 - extends (invalid JSON keeps its message)
- 0000033 req-004 - depends-on (setup never logs `settings.json` contents)
- ADR-0129 - related-to (non-array hook events keep their warning)
- ADR-0139 - related-to (case-duplicate keys use the same line)
- ADR-0140 - related-to (the depth cap uses the same line)

## Supersedes

- None

## Superseded By

- None
