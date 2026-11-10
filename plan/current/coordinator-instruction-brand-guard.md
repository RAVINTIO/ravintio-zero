# Instruction for step 18: narrow the brand guard self-entry

The human did not approve this allowlist row in `ravintio-zero/tests/brand-guard-allowlist.txt`:

```
^ravintio-zero/tests/brand-guard-allowlist\.txt$	.
```

The row lets every line of the allowlist file pass the brand guard. That widens a fail-closed guard, and no `## Decisions` row approves a widening for step 18.

Before P4 raises the PR:

1. Remove that row from `brand-guard-allowlist.txt`.
2. Make `scripts/brand-guard.sh` skip the one allowlist file it reads, by exact path. Do not use a pattern or an allowlist row.
3. Add a test that the banned word in any other file still fails the guard. Include a file whose name only resembles the allowlist file, such as `brand-guard-allowlist.txt.bak` or a copy in another folder.
4. Keep the CI check and the pre-push hook on the same rule.
5. Log `Decision applied (initiative coordinator): narrow the brand guard self-entry` in the build log.

If any of this cannot be done, stop with `Blocked:` and name what fails.

## Update for step 34 (2026-11-10)

This item now belongs to step 34, entry 0000432. Step 20 moved the pack source to `src/ravintio-zero/`, and `ravintio-zero/` is now the synced copy.

- The human chose that the exact-path skip covers both files: `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt`.
- Remove the self-entry row from the source allowlist, then run `node src/ravintio-zero/scripts/sync-installed.mjs` so both copies match.
- Edit `brand-guard.sh` in `src/ravintio-zero/`, and sync it the same way.
- Read "step 18" above as "step 34".
