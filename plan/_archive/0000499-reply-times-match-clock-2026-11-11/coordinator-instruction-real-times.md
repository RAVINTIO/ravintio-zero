# Instruction for step 51: read the clock for every time

Your build log has a note that the GREEN times are approximate. The agent wrote them after the runs. The human ruled on 2026-11-11 that every agent timestamp comes from a real clock read. The read happens at the moment of the write. An estimate is never acceptable. This step exists to enforce that rule.

1. From now on, run `date -u +%Y-%m-%dT%H:%M:%SZ` immediately before each build log time, and `date +%H:%M` before each reply prefix.
2. Keep the approximate times already written, and keep the note. Rewriting them would make a second guess. Add a `Rework:` line that records the departure and this instruction.
3. If a unit records a time after the event, record the time of the write and say so in the line.
