---
title: "Postmortem: {{date}} - {{short-title}}"
summary: "A blameless record of why a failure got through earlier phases, and the actions that close the gap."
status: "open"  # open | closed
---
# Postmortem: {{date}} - {{short-title}}

> Path: `plan/postmortems/{date}-{slug}.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** {{failed CI run | Blocked stop | P2 self-correction | escaped defect | human request}}
**Feature:** {{feature-id or none}}
**Date:** {{date}}

## Summary

{{One or two sentences: what failed and what the impact was.}}

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| {{timestamp}} | {{event}} | {{build-log line, commit, CI log line, or file path}} |

First missed chance to catch it: {{event and the check or phase that could have caught it}}

## 5 whys

1. {{Why 1: the failure}}
2. {{Why 2}}
3. {{Why 3}}
4. {{Why 4}}
5. {{Why 5: a gap in a process, check, standard, or tool}}

**Gap:** {{the process, check, standard, or tool gap the chain ends at}}

## Actions

> One row for each type. A type with no action reads `none, because {reason}` in the Action cell.
> A `done` row records corrective work made during the run. Its Ref cell holds the commit or PR.
> A `filed` row's Ref cell holds the backlog entry id or the repo instruction path.
> `node ravintio-zero/scripts/postmortem-check.mjs {record}` checks this table.

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | {{action, or "none, because {reason}"}} | {{done | filed | none}} | {{owner}} | {{path}} | {{test, check, or review}} | {{commit, PR, backlog id, or instruction path}} |
| preventive | {{action, or "none, because {reason}"}} | {{done | filed | none}} | {{owner}} | {{path}} | {{test, check, or review}} | {{commit, PR, backlog id, or instruction path}} |
| detective | {{action, or "none, because {reason}"}} | {{done | filed | none}} | {{owner}} | {{path}} | {{test, check, or review}} | {{commit, PR, backlog id, or instruction path}} |
