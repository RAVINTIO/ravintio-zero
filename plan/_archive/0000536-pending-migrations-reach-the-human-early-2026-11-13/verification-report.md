# Verification report - 0000536-pending-migrations-reach-the-human-early

The change is Markdown rules and one Bash suite. No service starts. The agent ran the suite and read the changed text.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | CLI: ran `bash ravintio-zero/tests/test-0000536-req-001-003-pending-migrations.sh` | verified | exit 0, 14 passed. The suite finds the `Chart-time migrations` section and the `Migration:` row rule at `roadmap-standards.md`. |
| REQ-001 AC-2 | Same suite, plus reading `ravintio-zero/skills/ravintio-initiative/SKILL.md:36` | verified | The skill's **Migrations** bullet names the listing and the section. |
| REQ-002 AC-1 | Same suite, plus reading `roadmap-standards.md:318` and check 1 of the resume reference | verified | Both name `ravintio-migrator` with the row's answer as the reply. |
| REQ-002 AC-2 | Same suite | verified | Both files name `Migration pending: {id}`. |
| REQ-003 AC-1 | Same suite, plus reading `ravintio-zero/skills/ravintio-initiative/SKILL.md:71` | verified | `Decisions for the human` includes each `Migration pending:` line with `all` and `none`. |

A live run of a step against a pending migration needs a charted initiative and a driver. The suite checks the rule text only. No criterion rests on documentation alone.
