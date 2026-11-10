# RAVINTIO Testing Standards

Tests are the requirements' executable counterpart. Every acceptance criterion becomes a test, every contract becomes a contract test, every edge case the requirements identify becomes a test case.

---

## 1. Test Pyramid

Every component must have tests at three levels:

| Level | What It Tests | Speed | Scope | Required Coverage |
|-------|--------------|-------|-------|-------------------|
| **Unit** | Pure functions, business logic, transformations | Fast (< 100ms each) | Single function/class | Every exported pure function |
| **Integration** | API endpoints, database queries, service interactions | Medium (< 5s each) | Single component boundary | Every endpoint, every query |
| **Contract** | Cross-component interface agreements | Medium | Component boundary pair | Every consumed interface |

We recommend E2E tests at the component level but do not require them.

---

## 2. Agentic TDD & Requirement Traceability

Agents must employ **Agentic TDD (Test-Driven Development)** to guarantee semantic correctness deterministically, rather than evaluating success probabilistically.

**The Agentic TDD Loop:**
1. Read the functional requirement (`plan/current/requirements/req-*.md`).
2. Write the failing test case *first*.
3. Execute the test to verify it fails (establishing the boundary).
4. Write the implementation logic.
5. Execute the test to verify it passes.

**Requirement Traceability:**
Every functional requirement must be explicitly traceable to a test. You MUST include the requirement ID in the test description or suite name.

```javascript
// Correct: Traceable to req-001-auth
describe("req-001-auth: user login flow", () => {
  test("returns 401 when password is mathematically invalid", () => {
    // ...
  })
})
```

**Rules:**
- Test names describe behaviour, not implementation: "returns 404 when order does not exist" not "test getOrder"
- One assertion concept per test. Multiple `expect` calls are fine if they verify the same logical assertion.
- No shared mutable state between tests, and no test interdependence - each test sets up its own data and all tests must pass in any order.

---

## 3. What to Test

Always test the happy path for every acceptance criterion, error cases, boundary conditions, and state transitions. Never test framework internals, private implementation details, or third-party library behaviour.

---

## 4. Test Data

Use factories or builders, not raw object literals repeated across tests. Test data should be minimal - only fields relevant to the test. Never use production data or hardcode dates. Database tests must clean up after themselves or use transactions that roll back.

---

## 5. Mocking

Contract tests verify the mock matches reality. If a consumer test mocks a service, the provider must have a corresponding contract test that verifies the mock's behaviour.

---

## 6. Flakiness Policy

A flaky test is worse than no test - it erodes trust in the suite. If a test fails intermittently, fix it or delete it. Do not retry-and-ignore. All tests must be deterministic - use dependency injection for time, randomness, and external state.

---

## 7. Coverage

Coverage is a proxy, not a target. The goal is confidence that the code meets the requirements.

| Metric | Minimum | Target |
|--------|---------|--------|
| Line coverage | 80% | 90%+ |
| Branch coverage | 70% | 85%+ |
| Critical path coverage | 100% | 100% |

"Critical path" = the primary user-facing flows identified in the design requirements' acceptance criteria.

---

## 8. Pack text helpers

A test that asserts what a skill, standard, or template says reads the text through a helper in `ravintio-zero/tests/helpers/assert.sh`. Never hard-code the file that holds a rule, and never cut a section out with your own `sed` or `awk` range. Moving a section or rewording a rule then breaks no test.

| Helper | Use it to |
|--------|-----------|
| `orch_section "<heading>"` | Get a section of `SKILL.md`, the orchestrator references, or the roadmap standards. |
| `rule_text <id>` | Get the text of the rule that carries `<!-- rule: <id> -->`. |
| `assert_rule <id> <term>...` | Check that the anchor exists once and its text holds every key term. |
| `with_timeout <seconds> <command>...` | Cap a command. It exits 124 on expiry. |

`with_timeout` lives in `helpers/timeout.sh`, so source that file first. It works on macOS, which has no `timeout` command. It runs external commands only.

To anchor a rule, put `<!-- rule: <id> -->` at the start of its line or item. Use lowercase letters, digits, and hyphens, and keep each id unique across `skills/`, `standards/`, and `templates/`. The rule is the anchor line and the lines after it, up to a blank line, a heading, or the next anchor. Tests assert key terms, not whole sentences. If you delete an anchor, the test that reads it fails and names the id.

## 9. Test scope per phase

A TDD cycle runs the new test and the tests that cover the files the unit changed. The agent starts one full suite run in the background after the last requirement turns green, and fixes any failure before P2 completes. Each cycle appends a `Tests run:` line to the build log.

At P0, the run records the suites that fail on the base commit in `plan/current/baseline-failures.md`, with `scripts/baseline-failures.mjs record`. At P3, `scripts/baseline-failures.mjs check` prints each failed suite as `inherited:` or `new:` and exits 1 on a new one. P3 stops only on a new suite and lists the inherited ones in the build report.

The CI duration target is 420 seconds per run. Ship records each run as a `CI duration:` marker, and the governance report shows the longest one. A run above the target is a breach in the report. It never fails the gate.

P3 runs the suite in a clean clone of `HEAD` with `scripts/clean-clone-test.mjs`. Untracked files, ignored caches, and local state then cannot change the result. The script prints an `OS gap:` line when the local OS is not among the `runs-on` values of the CI workflow. After a fix, P3 reruns the failed suites first and then runs the full suite once before acceptance.
