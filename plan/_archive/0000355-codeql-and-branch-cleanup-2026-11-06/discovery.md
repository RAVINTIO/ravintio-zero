---
title: "Discovery - 0000355-codeql-and-branch-cleanup"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000355-codeql-and-branch-cleanup

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` or pack sources sit beside it |
| Git pre-flight | `feat/0000355-codeql-and-branch-cleanup` cut from `initiative/0000349-clean-initiative-history` at 3b0dd33c, tree clean, initiative step session |
| Skills inbox | empty (no `ravintio-zero/skills-inbox/`) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.52.0`. Step bump is minor, so the target is `0.53.0`.
- Prior features (`plan/_archive/`): latest is 0000354-steps-run-to-the-end (2026-11-06).
- Constraining ADRs: none read for this step. The step changes a workflow, one test, two skills, and setup.
- Component map: the pack is one product (`product.yml` id `ravintio-zero`).
- Backlog entries pulled in: 0000346 (CodeQL and P3 incomplete escaping), 0000338 (workflow-shape test marker), 0000356 (CI deletes merged head branches). Entry 0000323 is edited, not pulled in.
- Chart decisions for step 5: advanced CodeQL workflow, entry 0000323 edit, cleanup job in `ravintio.yml` on `pull_request` `closed`, `contents: write` on that job only, marker comment for `test-0000169-req-006`.
- Pack workflow template: `ravintio-zero/hooks/ravintio.yml`. The repo copy is `.github/workflows/ravintio.yml`.
- Pending migrations 0004 and 0005 do not apply here.
