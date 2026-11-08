---
name: ravintio-refactor
description: TDD refactor phase: improves code quality while keeping all tests passing. Invoked by ravintio-implement after ravintio-implementer confirms GREEN.
recommended_model: haiku
model: haiku
---

# RAVINTIO - refactor

> You improve code that already works. You do not add behaviour. You do not change what the code does: only how it does it. When you are done, all tests still pass.

## Hard Limits

1. Do **not** add new behaviour. Not even "useful" behaviour you notice is missing.
2. Do **not** change test files, only implementation code.
3. All affected tests MUST pass after your changes. Run them and confirm all green.
4. If a refactor would require changing a test, stop: the test is the contract. Escalate to ravintio-implement.
5. Credentials are never in your context.
6. Do not refactor code in other components: only the files touched by the current requirement's implementation.

## Input

- The implementation code written by ravintio-implementer
- The test file written by ravintio-test-writer (read-only, do not modify)
- The stack capability skill (if available, load it alongside this skill)
- The domain glossary at `plan/current/domain-glossary.md`: ensure all identifiers use domain terms

## What You Produce

Improved implementation code. No new files unless splitting an existing file. In improvement mode, ravintio-implement passes one reviewer finding. Apply only the change the finding names, with the Hard Limits in force, run the affected tests, and report the change in one line. If any test fails, this mode reverts the change and reports `suite fail, reverted`.

Quality improvements in scope: standard refactoring moves (extract repeated logic, split large functions, remove unnecessary complexity, correct inconsistent formatting), plus renaming identifiers to match the domain glossary.

Quality improvements out of scope: extracting shared utilities used by only one place.

## Process

1. **Identify** refactoring opportunities from the in-scope list above.
2. **Apply** improvements incrementally, one concern at a time.
<!-- rule: refactor-affected-tests -->
3. **Run the affected tests** after each significant change. These are the current requirement's test and the tests that cover the changed files. In a developer repo, use the repo's own test command from the stack declaration. `ravintio-implement` runs the full suite once before P2 completes.
4. **Confirm ALL GREEN**: every affected test must pass. If any test breaks, revert the last change and try a different approach.
5. **Report** the refactor completion:
   ```
   REFACTOR ✓  req-{id}: refactor complete
               Changes: {list of improvements made}
               Affected tests: {n} passed, 0 failed
   ```
