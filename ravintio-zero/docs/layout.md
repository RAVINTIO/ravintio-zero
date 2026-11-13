---
title: "Pack layout"
summary: "The pack source in src/ravintio-zero/, the installed copy in ravintio-zero/, and how to refresh the copy."
status: "active"
version: "0.75.0"
---
# Pack layout

This repo holds the pack twice. `src/ravintio-zero/` is the source. `ravintio-zero/` is a plain installed copy.

## The two folders

| Folder | Role | Who edits it |
|--------|------|--------------|
| `src/ravintio-zero/` | The pack source | You and the agents edit it |
| `ravintio-zero/` | The installed copy that hooks, the driver, and skills run | The sync script writes it. Nobody edits it by hand |

A source edit changes nothing that runs until you refresh the copy. A hook or skill change takes effect after the refresh commit.

## Refresh route

1. Edit the files under `src/ravintio-zero/`.
2. Run `node src/ravintio-zero/scripts/sync-installed.mjs`. It replaces `ravintio-zero/` with a plain copy of the source.
3. Commit the refresh as its own commit.
4. Run `node src/ravintio-zero/scripts/sync-installed.mjs --check`. It compares the folders byte for byte and exits 1 on a difference.

## Why no symlink

A symlink from `ravintio-zero/` to the source gives one copy. A source edit would then change the running pack at once. The two-folder layout keeps the running pack stable until you choose to refresh it. ADR 0295 records the decision.

## Consumer installs

A consumer repo installs the pack at `ravintio-zero/` and keeps that path. Skills, hooks, and docs for consumers name `ravintio-zero/`. Only this repo holds the source under `src/ravintio-zero/`.

## Guards

Every guard that covers `ravintio-zero/` also covers `src/ravintio-zero/`. The move adds no exception to any guard.
