# Verification report - 0000452-ci-wait-before-archive

Started: nothing. The change is skill and standards text, so each check reads the text with a test and runs the guard hook.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 archive follows CI | `bash src/ravintio-zero/tests/test-0000452-req-001-archive-after-ci.sh` | verified | 12 passed, exit 0. `gh pr create` precedes the CI wait, which precedes Step 4. |
| REQ-001 AC-2 failing check is fixable | Hook run: code edits under `src/ravintio-zero/` succeeded in P2 while `plan/current/design.md` existed. Text test for the `Step CI fixes` rule | verified | `gate-write` allowed each edit and blocked one path missing from Component Paths (exit 2). |
| REQ-001 AC-3 normal run unchanged | Same test, AC-3 block | verified | Ten `### Step` headings. Step 4, 8, 9 order unchanged. |
| REQ-002 AC-1 no ready on pending or failed | `bash src/ravintio-zero/tests/test-0000452-req-002-ready-needs-green.sh` | verified | 7 passed, exit 0. |
| REQ-002 AC-2 second wait after closing push | Same test, AC-2 block | verified | Closing push, second watch, then `ready` in order. |
| REQ-002 AC-3 ship skill states the rule | Same test, AC-3 block | verified | `only after every check` in the initiative section. |
| Live ship run with a failing check | none | not-verifiable | A real failing check needs a CI run. This step's own ship is the first live use. |
