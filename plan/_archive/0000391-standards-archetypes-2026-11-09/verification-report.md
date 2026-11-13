# Verification report - 0000391-standards-archetypes

A scratch consumer repo at `/tmp/s15v` linked the worktree pack. `setup.sh` ran each command. The script is `/tmp/s15-verify.sh`, outside the repo.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| Resolver returns an override template before the pack copy | CLI | verified | `resolve-override.mjs templates scope.template.md` printed the `ravintio-overrides/` path |
| Resolver ignores an override that relaxes a protected rule | CLI | verified | A weaker `commit-standards.md` and a `writing-standards.md` without a pinned line both returned the pack path |
| `archetype use` copies, prints what it replaced, and a rerun changes nothing | CLI | verified | First run exit 0 with `replaces:` line. Rerun printed `nothing changed` |
| Two archetypes with different stack lists report a clash and copy nothing | Test | verified by test | The suite plants two temporary archetypes that share a slot. The catalogue ships one stack archetype, so no live pair exists |
| No archetype lowers another's threshold | Test | verified by test | `test-0000391-req-003-004-command.sh` plants a lower value and expects exit 1 |
| Strict testing fails P3 when a component API has no Pact contract | CLI | verified | `archetype-gates.mjs` exit 1 with `FAIL pact-contracts` for `src/api` |
| Output style and `AGENTS.md` section follow the writing pick | CLI | verified | `writing-style.mjs codex` pointer line named the override file |
| `setup.ps1` prints the same list as `setup.sh` | CLI | verified | The dispatch suite compares both outputs under `pwsh` |
