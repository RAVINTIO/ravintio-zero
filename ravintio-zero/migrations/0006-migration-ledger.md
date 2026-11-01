# Migration 0006 - migration ledger

**Target standard:** `plan/state/migrations.md`, the migration ledger
**Scope:** `ravintio-zero/migrations/_done/` and `plan/state/`
**Applies when:** a `ravintio-zero/migrations/_done/` folder holds a migration file whose ledger row is missing from `plan/state/migrations.md`.
**Detect:** exists ravintio-zero/migrations/_done
**Safe to skip:** Yes. A skipped run leaves older migrations without a ledger row, so a pack update can report them as pending again. Re-running is safe.

---

## What this migration does

The migrator used to record a finished migration by moving its file into `ravintio-zero/migrations/_done/`. A pack update replaces that folder, so finished migrations came back as pending. The migrator now records state in `plan/state/migrations.md`, outside the pack.

The helper copies each file in `_done/` into the ledger as a `done` row at the current pack version. A numbered file uses its four-digit id. Any other file uses its file name without `.md`. The helper creates the ledger and `plan/state/` if they are missing. It skips an id that already has a row. It deletes nothing, including the `_done/` files.

---

## Migrator instructions

1. Check that `ravintio-zero/migrations/_done/` exists in the project root. If it doesn't, record this migration as `not applicable` and stop.

2. Tell the human that the helper only appends rows to `plan/state/migrations.md`. It changes nothing inside `ravintio-zero/`.

3. Show: `Will run the helper from the project root. It adds one done row to plan/state/migrations.md for each file in ravintio-zero/migrations/_done/.`
   Ask: `Proceed? (y/n)`

4. If yes, run the helper that matches the shell:
   - Bash: `bash ravintio-zero/migrations/migrate-migration-ledger.sh`
   - PowerShell: `ravintio-zero/migrations/migrate-migration-ledger.ps1`

5. If the helper exits non-zero, show its output and stop. The cause is one of these:
   - `ravintio-zero/component.yml` has no readable `version:` line.
   - `plan`, `plan/state`, or `plan/state/migrations.md` is a symlink. The human replaces the link with a real file or folder.

6. If the helper exits 0, append a `0006` row with the result `done` to the ledger if the helper did not add one. Ask the human to check the new rows.
