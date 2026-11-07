# Security report - 0000377-driver-stops-and-headroom

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The driver prints build log text in the stop line | `ravintio-zero/scripts/initiative-run.mjs` (`blockIn`) | Low | Cut to 500 characters by `MAX_LINE`. It prints only a line that starts `Question:` or `Blocked:`. Mitigated. |
| The watcher prints the same text | `ravintio-zero/scripts/initiative-watch.mjs` (`eventLine`) | Low | Cut to 500 characters. Mitigated. |

No credential handling, path input, or dependency change. The change adds no dependency.
Overall risk: Low. No critical or high findings. Risk register entries both mitigated.
