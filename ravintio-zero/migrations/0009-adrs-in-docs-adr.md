# Migration 0009 - ADRs in docs/adr

**Target standard:** `ravintio-zero/templates/adr.template.md` and `docs/adr/`, the repo-wide home of every ADR
**Scope:** `plan/_archive/*/adr/`, `docs/adr/`, and `docs/decisions-index.md`
**Applies when:** a `plan/_archive/*/adr/ADR-*.md` file exists, or `ravintio-zero/` is the pack source in this repo.
**Detect:** exists plan/_archive
**Safe to skip:** Yes. A skipped run leaves the ADRs in the archive under per-feature numbers. Re-running is safe.

---

## What this migration does

Each feature used to write its ADRs to `plan/_archive/{feature}/adr/` under numbers that restart at `ADR-001`. Feature 0000030 emptied the archive and the ADRs of features 0000001 to 0000029 survive only in git history.

The helper moves every ADR to `docs/adr/{NNNN}-{slug}.md` under a repo-wide four-digit number. It works in two phases.

1. Restore. For features 0000001 to 0000029, it reads each ADR from the commit before the one that removed it. It lists any feature that has none and skips it.
2. Move. It orders the ADRs by feature id, then by ADR order, and numbers them from 0001. It keeps each `status`, adds `component` if absent, and adds a `feature` field. It rewrites `ADR-NNN` references that mean the same feature, and `{feature} ADR-{n}` references, to the new `ADR-{NNNN}`. It records the old-to-new map in `docs/adr/.migration-map.json`.

It then replaces each archived ADR with one `README.md` link file in `plan/_archive/{feature}/adr/`. It rebuilds the rows of `docs/decisions-index.md` from `docs/adr/` and keeps the file header. It sets `docs/adr/.next-id` to one past the highest number.

A rerun reuses the map and skips targets that exist, so it changes no file. At the end, the helper checks every `Supersedes` and `Superseded by` reference and exits 1 with a list of any that name a missing number.

Flags: `--dry-run` writes nothing, `--no-restore` skips the history phase, `--include-current` also takes `plan/current/adr/`, and `--root <dir>` acts on another folder.

---

## Migrator instructions

1. Check that `plan/_archive/` exists or that `ravintio-zero/` is the pack source in this repo. If neither holds, record this migration as `not applicable` and stop.

2. Tell the human that the helper writes `docs/adr/` and `docs/decisions-index.md` and removes archived ADR files. Say that the diff is large and that git history keeps the old files.

3. Show: `Will run the helper from the project root. It restores the ADRs of features 0000001 to 0000029 from git history, moves every archived ADR to docs/adr/ under a four-digit number, and rebuilds the decisions index.`
   Ask: `Proceed? (y/n)`

4. If yes, run the helper that matches the shell. Add `--dry-run` first if the human wants a preview.
   - Bash: `bash ravintio-zero/migrations/migrate-adr-home.sh`
   - PowerShell: `ravintio-zero/migrations/migrate-adr-home.ps1`

5. If the helper exits non-zero, show its output and stop. The cause is one of these:
   - `plan`, `docs`, or `docs/adr` is a symlink. The human replaces the link with a real folder.
   - `node` is missing. The human installs Node.js.
   - A reference names a number with no file. The helper lists each one. The human fixes the reference and runs the helper again.

6. If the helper exits 0, append a `0009` row with the result `done` to the ledger. Ask the human to check `docs/adr/` and the index.
