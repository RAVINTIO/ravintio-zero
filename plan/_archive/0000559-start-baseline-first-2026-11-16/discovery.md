---
title: "Discovery - 0000559-start-baseline-first"
summary: "Raw discovery-pass findings for initiative step 15."
---
# Discovery - 0000559-start-baseline-first

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000559-start-baseline-first`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.140.0`
- Prior features (`plan/_archive/`): 0000557 added the safe wait for the baseline suite. 0000577 is the latest.
- Constraining ADRs: none that affect the start actions.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000478. Outcome: the baseline run is the first P0 action in `orchestrator-p0-start-actions.md`, and a test reads the step order.
- The run takes about 13 minutes in a clean clone. It currently starts as step 15, after the design.
- The clean-clone run reads committed files only. Writing P0 artifacts first changes nothing for it, so only the start time moves.
- Step 16 (`decision-rows`) says a row may change how the baseline runs. The rows must therefore be read before the baseline starts. The baseline step cannot be step 1 or 2 for a fresh run, because the pre-flight can switch the branch.
- Cross-references to the numbered steps: `roadmap-standards.md` (steps 2 and 8), `SKILL.md` (step 7), and the skills inbox sentence in the start actions file.
- Tests pin rules by anchor (`rule: p0-start-baseline`), not by number. `test-0000557-req-001-safe-suite-wait.sh` reads four lines after the anchor.
- Queue: no item names step 15.
