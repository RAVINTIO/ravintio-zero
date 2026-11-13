---
title: "Story Map - 0000509-clear-merged-ready-files"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000509-clear-merged-ready-files

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Start the driver | Find each chart step with status `merged` that still has a `ready` file | US-001 | REQ-001 |
| Start the driver | Remove the file and print a `Cleared:` line | US-001 | REQ-001 |
| Start the driver | Keep the file while a `running` file names a live pid | US-002 | REQ-002 |
| Start the driver | Keep the file when the removal fails or the path is a symlink | US-002 | REQ-002 |
| Read the docs | Find the rule in the driver comment and the standards | US-001, US-002 | REQ-003 |
| Run the driver | Clear a file after each merge | none | gap: out of scope |

## Gaps

- Clear after each merge: the queue already deletes the control folder of the step it merges. The scope lists a later pass as out of scope.
