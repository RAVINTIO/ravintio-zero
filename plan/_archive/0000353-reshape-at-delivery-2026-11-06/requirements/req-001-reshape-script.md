---
title: "Requirement: REQ-001 - Reshape script writes N + 1 commits"
summary: "reshape-initiative.mjs writes a new branch with one titled commit per step and one chore commit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Reshape script writes N + 1 commits

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I run one script at I-E Delivery and get a new branch with one titled commit per step, then one chore commit.

## Functional Requirements
- The script is `ravintio-zero/scripts/reshape-initiative.mjs`. It takes `--root`, `--branch`, `--base`, `--chart`, `--assign {hash}={step}` (repeatable), `--chore-number`, `--tags`, and `--push`.
- It reads the `Steps` table of the chart by column name: `Feature id`, `Title`, and `Version`.
- It lists the first-parent commits from the merge base of `--base` and the branch to the branch head. It finds each step commit through the tag `v{Version}`.
- It replays each step in chart order onto the merge base. An assigned admin commit folds into its step first, in its old order. It uses `git merge-tree --write-tree` and `git commit-tree`, so it never touches a working tree.
- Each new step commit has the subject `{first 7 digits of Feature id}: {Title} (#{n})`. The number `{n}` comes from the old step subject.
- It adds one chore commit with the subject `{initiative id}: Initiative admin (#{n})` whose tree equals the old head tree. It adds none if the last step tree already equals the old head tree.
- It writes the branch `{branch}-reshaped` and prints each new commit.

## Acceptance Criteria
- [ ] AC-1: shape
  - Given a fixture branch with an activation commit, three tagged step squashes, and one coordinator commit
  - When the script runs
  - Then the new branch holds three titled step commits and one chore commit
  - And the new head tree equals the old head tree
- [ ] AC-2: aligned admin folds in
  - Given a coordinator commit assigned to step 2 with `--assign`
  - When the script runs
  - Then step 2's new commit holds that change and no extra commit appears
- [ ] AC-3: no extra chore commit
  - Given a branch whose last step tree equals the head tree
  - When the script runs
  - Then the new branch holds only the step commits

## Dependencies
- `check-initiative-history.mjs` for the chart parse approach.
