# Migration 0008 - retired commands

**Target standard:** `.claude/commands/`, the folder of pack commands
**Scope:** consumer repo root
**Applies when:** `.claude/commands/` holds `fast-path.md`, `change-pipeline.md`, or `retrofit.md`. In any other repo, the migration stays pending and nothing runs.
**Detect:** exists .claude/commands/fast-path.md | exists .claude/commands/change-pipeline.md | exists .claude/commands/retrofit.md
**Detect note:** `resume-detect.mjs` reads the `Detect:` line. Keep it on one line, with items joined by ` | `.
**Safe to skip:** Yes. Setup removes the same files on its next run. Until then the retired commands stay installed. Re-running is safe.

---

## What this migration does

The pipeline has one route, so this migration retires the commands for the old routes. An earlier release installed `fast-path.md`, `change-pipeline.md`, and `retrofit.md` in `.claude/commands/`. The `fast-path` command says it bypasses the full pipeline, which contradicts the confirmed-design rule.

The helper removes each of the three files if its front matter holds the matching `name:` line. It skips a file with no such line, because that file is the developer's own. It skips a symlink. It changes nothing else.

---

## Migrator instructions

1. Check that `.claude/commands/` exists in the project root. If it doesn't, record this migration as `not applicable` and stop.

2. Tell the human that the helper only removes the three retired command files from `.claude/commands/`. It keeps every other file.

3. Show: `Will run the helper from the project root. It removes fast-path.md, change-pipeline.md, and retrofit.md from .claude/commands/ when each holds the pack name line.`
   Ask: `Proceed? (y/n)`

4. If yes, run the helper that matches the shell:
   - Bash: `bash ravintio-zero/migrations/migrate-retired-commands.sh`
   - PowerShell: `ravintio-zero/migrations/migrate-retired-commands.ps1`

5. If the helper exits non-zero, show its output and stop. The cause is a symlink at `.claude` or `.claude/commands`. The human replaces the link with a real folder.

6. If the helper exits 0, append a `0008` row with the result `done` to the ledger. Tell the human which files the helper removed.
