# Verification report - 0000321-backlog-triage

I ran the index script and the migration helper in throwaway projects under temporary folders. I removed the folders afterwards. I ran `--check` on this repo and read the CI steps and the pickup text.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| req-001 AC-1: template names both fields | Read `backlog-entry.template.md` and ran its suite | verified | Frontmatter holds `priority` and `theme` with the allowed values |
| req-001 AC-2: filing skill sets both fields | Read the skill and ran its suite | verified | Step 6 names `priority`, `theme`, and `backlog-index.mjs` |
| req-002 AC-1: index lists every open entry | Script run on three entries in two themes | verified | Rows grouped by theme, ordered high then medium, with the right priorities |
| req-002 AC-2: check fails on a stale index | Added an entry, ran `--check`, regenerated, ran again | verified | Exit 1 with the stale message, then exit 0 after regeneration |
| req-002 AC-3: malformed entry stops the run | Entry with priority `urgent` | verified | Exit 1, entry named, index unchanged |
| req-002: no body text | Body marker string in each entry | verified | 0 matches in the index and in the review output |
| req-003 AC-1: both workflows run the check | Read both files and ran the suite | verified | The step `Check the backlog index` appears once in each |
| req-004 AC-1: review lists a stale entry | `--review --today 2026-11-01` | verified | Lists the 12-day entry and not the 1-day and 2-day entries |
| req-004 AC-2: age comes from `product.yml` | Set `backlogReviewDays: 20` | verified | The review lists nothing |
| req-004 AC-3: step 10 uses the index order | Read the reference and ran the suite | verified | Names `--review`, the index order, and index regeneration |
| req-005 AC-1: helper adds missing fields | Helper run on an entry with neither field | verified | Adds `priority: "medium"` and `theme: "unsorted"` before the closing `---` and changes no other line |
| req-005 AC-2: helper is idempotent | Second run | verified | 0 entries updated, file byte-identical |
| req-005 AC-3: this repo is migrated | Ran `test-0000321-req-005-applied.sh` | verified | 58 entries hold both fields, the ledger holds one `0007 done` row, `--check` exits 0 |

In this repo, `--review --today 2026-11-01` lists entry 0000174, filed 2026-10-25. Every entry reads `medium` and `unsorted` until the human sorts them.
