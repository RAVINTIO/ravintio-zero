# Migration 0007 - backlog priority and theme

**Target standard:** `ravintio-zero/templates/backlog-entry.template.md`, the backlog entry template
**Scope:** `plan/backlog/`
**Applies when:** a `plan/backlog/*/entry.md` file has no `priority` or no `theme` key in its frontmatter.
**Detect:** exists plan/backlog
**Safe to skip:** Yes. A skipped run leaves entries without the two keys. The backlog index reads a missing key as `medium` and `unsorted`. Re-running is safe.

---

## What this migration does

The backlog entry template now carries a `priority` key and a `theme` key in its frontmatter. Entries filed earlier lack both.

The helper adds `priority: "medium"` and `theme: "unsorted"` to each `plan/backlog/*/entry.md` that lacks them. It writes each key as a new line just before the closing `---` of the first frontmatter block. It adds a key only if that key is absent, so an existing value stays. It changes nothing else, skips an entry with no frontmatter, and skips a symlink.

When `ravintio-zero/scripts/backlog-index.mjs` exists, the helper then regenerates the index with `node ravintio-zero/scripts/backlog-index.mjs`.

---

## Migrator instructions

1. Check that `plan/backlog/` exists in the project root. If it doesn't, record this migration as `not applicable` and stop.

2. Tell the human that the helper only edits the frontmatter of `plan/backlog/*/entry.md` files and the backlog index. It changes nothing inside `ravintio-zero/`.

3. Show: `Will run the helper from the project root. It adds priority: "medium" and theme: "unsorted" to each backlog entry that lacks them, then regenerates the backlog index.`
   Ask: `Proceed? (y/n)`

4. If yes, run the helper that matches the shell:
   - Bash: `bash ravintio-zero/migrations/migrate-backlog-priority-and-theme.sh`
   - PowerShell: `ravintio-zero/migrations/migrate-backlog-priority-and-theme.ps1`

5. If the helper exits non-zero, show its output and stop. The cause is one of these:
   - `plan` or `plan/backlog` is a symlink. The human replaces the link with a real folder.
   - `node ravintio-zero/scripts/backlog-index.mjs` failed. The entries are already updated. The human fixes the cause and runs the script again.

6. If the helper exits 0, append a `0007` row with the result `done` to the ledger. Ask the human to check the changed entries.
