---
name: gutd
description: Git up to date. Run when the human types GUTD or /gutd. Checks out main, pulls the latest from origin, and lists untracked files.
---
# GUTD

GUTD is shorthand for "git up to date". When the human sends `GUTD` in any letter case, or runs `/gutd`, check out `main`, pull the latest, and check for untracked files.

## Steps

1. Run `git status` first. Stash or flag anything uncommitted before you switch branches.
2. Run `git checkout main`.
3. Pull the latest from `origin/main`. If local `main` has diverged, do not force-reconcile. Investigate the local-only commits first. Prefer a reversible step, such as a backup branch, over discarding them.
4. Report any untracked files (`git status --porcelain` `??` entries). List them for the human. Never ignore or clean them silently.

## Why

The human runs this sync check often. A past "checkout main and pull latest" request surfaced local `main` commits that had diverged from `origin/main`. Report untracked and stray state every time.
