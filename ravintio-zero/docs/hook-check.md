---
title: "Hook check"
summary: "The script that runs every hook in .claude/settings.json with a fixed sample, and how the driver uses it."
status: "active"
version: "0.1.0"
---
# Hook check

`ravintio-zero/scripts/hook-check.mjs` runs every hook in `.claude/settings.json` and reports one verdict per hook. The initiative driver runs it after the approved setup command.

## Commands

- `node ravintio-zero/scripts/hook-check.mjs` checks the project in `CLAUDE_PROJECT_DIR`, or the working directory if the variable is unset.
- `node ravintio-zero/scripts/hook-check.mjs --root {dir}` checks the project in `{dir}`.

## What the script does

1. It reads every hook command in `.claude/settings.json`. It exits 2 with one stderr line if the file is missing or is not valid JSON.
2. It runs each command with `sh -c`, with `CLAUDE_PROJECT_DIR` set to the root and a fresh temporary working directory.
3. It sends one fixed JSON sample on stdin. The sample depends on the hook event and the matcher.
4. It prints one `pass:` or `fail:` line per hook and a count line. It exits 0 if every hook passes and 1 if any hook fails.

## Verdicts

| Result | Verdict |
|--------|---------|
| Exit 0 | pass |
| Exit 2 | pass, because a guard blocks on purpose, unless the launcher line below appears |
| A `[RAVINTIO] guard-run:` line on stderr, with any exit code | fail, because the launcher could not run the hook |
| Any other exit code, a spawn error, or a time-out after 15 seconds | fail |
| An event and matcher with no sample | fail |

## Samples

| Event | Matchers with a sample |
|-------|------------------------|
| `PreToolUse` | `Write`, `Edit`, `Bash` |
| `PostToolUse` | `.*` |
| `UserPromptSubmit` | `.*` |
| `Stop` | `.*` |

A matcher with alternatives, such as `Write|Edit`, runs once for each alternative. A new event or matcher needs a sample in `sampleFor`, or the check fails.

## Driver wiring

After the driver runs the approved setup command with a clean exit, it runs the check from the installed pack. A failure prints `I-D Advance: Blocked: hook check failed after setup:` and up to three `fail:` lines. The driver then keeps the Setup stop and exits 1. A pack with no `hook-check.mjs` skips the check and the driver says so.

ADR-0339 records the decision.
