# Verification report - 0000319-initiative-history-checks

I ran both scripts in a throwaway repository under a temporary folder, then removed it.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| req-001 AC: titled squashes pass | CLI run on a branch with one titled commit | verified | Exit 0, "1 commit(s) checked, all titled" |
| req-001: no commits passes with a note | CLI run with no commits since base | verified | Exit 0, "no commits between" note |
| req-001: untitled commit fails and is named | CLI run after adding `wip stuff` | verified | Exit 1, short hash and subject printed |
| req-001: missing base ref fails clearly | CLI run with `--base nope` | verified | Exit 1, "ref not found: nope" |
| req-004: squash on main fails | `check-main-merge.mjs` on a one-parent titled commit | verified | Exit 1, "Use a merge commit" |
| req-004: ordinary commit passes | `check-main-merge.mjs` on an untitled commit | verified | Exit 0 |
| req-002: CI jobs and push trigger | Read the workflow diff and ran the pinning tests | verified | Jobs, trigger and `release-tag` guard present |
| req-003: delivery step | Read the roadmap standards and `initiative` skill text | unverified (docs only) | Documentation claim, no run observes it |
| req-005: ruleset doc | Read `ravintio-zero/docs/main-ruleset.md` | unverified (docs only) | The doc names the merge-only setting |

The GitHub jobs run only on a real PR and push, so this session did not run them. CI on the PR runs them.
