---
title: "Backlog Entry: 0000262 - find what empties installed skills"
summary: "Something removed every skill folder under .claude/skills during step 7 of initiative 0000238."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000262 - find what empties installed skills

**Source feature:** 0000245-boot-rules-into-skills
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

---

## Problem

At P3 the `Skill` tool no longer found `ravintio-validate-and-accept`. `.claude/skills/` held only `.ravintio-manifest`, last changed at 18:48 on 2026-10-28. Every skill folder was gone, but the manifest was not.

`.ravintio-manifest` lists absolute paths. A setup run removes each listed folder before it reinstalls. A test that copies the repo with its `.claude/` folder and runs setup would delete the real folders through the copied manifest. No one has confirmed this cause. Two subagents ran setup and many suites between 18:43 and 18:48.

## Suggested Action

- Find which suite or command removed the folders. Run the suites one at a time against a copy of the repo while you watch `.claude/skills/`.
- If the manifest causes it, make setup remove only folders under its own skills directory, whatever the manifest lists.

## Wanted outcome

- No suite changes `.claude/skills/` in the real repo. A test checks the folder listing before and after the full run.
- Setup ignores a manifest line that points outside `$PROJECT_ROOT/$TOOL_SKILLS_DIR`.

## Why Deferred

The fix is outside the scope of 0000245. Step 15 of initiative 0000238 reinstalls the skills.
