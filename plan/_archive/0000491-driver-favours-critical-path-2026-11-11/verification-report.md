---
title: "Verification Report - 0000491-driver-favours-critical-path"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000491-driver-favours-critical-path

Method: ran `parseChart` and `readySteps` from the installed `ravintio-zero/scripts/initiative-chart.mjs` on the real chart of initiative 0000360, with steps 1 to 46 marked merged. The new suite runs the other cases on small charts. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 longest chain first | Suite case: three startable steps, step 3 has two dependants | verified | `readySteps` listed `[3,1,2]` |
| AC-2 ties keep chart order | Suite cases: equal chains, and chains of two each | verified | `[1,2,3]` and `[1,2]` |
| AC-3 lane order counts | Suite case: a lane of three steps and a lone step | verified | The lane came first: `[2,1]`. A merged step added nothing: `[2,3]` |
| AC-4 no After or Lane data | Suite case, and the existing chart suites | verified | Chart order kept. `test-0000379-req-001`, `-002-003-005`, `test-0000399-req-002`, and `test-0000438-req-001` pass |
| AC-5 standards state the order | Suite text checks | verified | Item 2 of `## Concurrent steps` names the longest chain first order and the tie rule |
| Error path: a cycle | Suite case: steps 1 and 2 wait on each other | verified | The function returned `[3]` and did not loop |
| NFR-001 speed | Suite case: 60 steps | verified | Ranked in under 100 ms. The real chart ranked in 0 ms |

On the real chart the three startable steps were 47, 51, and 58. Step 47 heads the driver lane, which has eight more steps behind it. The function listed it first, and all three start with three slots.
