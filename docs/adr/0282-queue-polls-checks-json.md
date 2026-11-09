---
title: "ADR 282: Queue polls checks as JSON"
summary: "The merge queue polls gh pr checks as JSON until every check passes, and names a failed check."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000392-ship-postmortems"
---
# ADR-0282 - Queue polls checks as JSON

**Status:** accepted
**Component:** ravintio-zero

## Context

The queue pushed a version commit and merged at once. CI restarted on the new head and GitHub refused the merge. `gh pr checks --watch` can return before GitHub registers the new run.

## Decision

After a push, the queue polls `gh pr checks {pr} --json name,bucket`. An empty list counts as pending. All `pass` or `skipping` buckets let it merge. A `fail` or `cancel` bucket stops it with the check name. The first CI wait uses the same function, so a red check also names itself.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `gh pr checks --watch` again | One line | Returns early on an empty list, and names no check | Caused the failure |
| `gh run watch` | Waits on one run | Needs the run id of the new head | More calls, same race |

## Consequences

**Positive:**
- The queue never merges before CI finishes on the head it pushed.

**Negative:**
- A poll adds up to 10 seconds of delay per check cycle.

**Risks:**
- A repo with no required checks waits until the 30 minute timeout. The queue stops with a message that says so.
