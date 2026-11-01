# Security report - 0000321-backlog-triage

**Feature:** 0000321-backlog-triage
**Version:** 0.47.0

## Summary

**Overall risk assessment:** medium
**Components reviewed:** `ravintio-zero/scripts/backlog-index.mjs`, `ravintio-zero/migrations` (0007 and both helpers), `.github/workflows/ravintio.yml`, `ravintio-zero/hooks/ravintio.yml`, `ravintio-zero/skills/ravintio-orchestrator` (Start Actions step 10)
**Review scope:** code review and hostile-input runs

I ran the script and the Bash helper against hostile entries in a temporary folder outside this repo. I ran the PowerShell regex under `pwsh` on macOS. The report is advisory. No code was changed.

One finding is medium: S-001, a regex with exponential backtracking in the PowerShell helper at `ravintio-zero/migrations/migrate-backlog-priority-and-theme.ps1:67`. It affects availability only. Nothing is critical or high.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | medium | availability (ReDoS) | `migrate-backlog-priority-and-theme.ps1:67` | The pattern `(?:.*?\r?\n)*?` can match a CRLF line in two ways, because `.` also matches `\r`. An entry with an opening `---` and no closing `---` forces the engine to try every split. In .NET under `pwsh`, 20 lines took 179 ms and 22 lines took 644 ms. The time roughly doubles per line, so a 40-line unclosed entry would not finish. Only CRLF files trigger it. A closed block matches fast. The Bash helper skips the same entry cleanly. | Use `[^\r\n]*` in place of `.*?`, or parse line by line. Add a `[regex]::new(..., matchTimeout)` guard. Add a test with an unclosed CRLF entry. | open |
| S-002 | low | file write, symlink | `backlog-index.mjs:221-223` | The write path never checks `plan/backlog/index.md`. I linked it to a file outside the tree, ran the script, and it overwrote the target (exit 0). The same holds if `plan` or `plan/backlog` is a link. Entry files and entry folders are checked with `lstat`, so only the output path is open. The content is the index, which includes entry titles. A cloned repo that commits such a link can make the person who runs the generator overwrite a file they own. The Bash and PowerShell helpers refuse these links, so the script is inconsistent with them. | Run `lstat` on `plan`, `plan/backlog`, and `index.md` before writing. Refuse a link and exit 1. Write to a temporary file and rename it. | open |
| S-003 | low | injection, output of untrusted text | `backlog-index.mjs:128`, `157-158` | The title is free text. The script collapses whitespace, so a title cannot add a row or a line. It does not remove Markdown, HTML, or control characters. I confirmed that links, `<script>` text, backticks, ESC (`\x1b[31m`), BEL, NUL, and a right-to-left override reach `index.md` unchanged. A title ending in `\` before a `|` becomes `\\|`, which splits the table row. GitHub sanitises HTML on render, and CI plus review show the committed text. The risk is a misleading link or terminal escape in a reviewed file. | Strip C0 control characters, DEL, and bidi marks from titles. Escape `\` before `|`. Consider escaping `<`, `[`, and backticks. | open |
| S-004 | low | injection, output of untrusted text | `backlog-index.mjs:97`, `180`, `194-201` | The slug comes from the folder name and matches `.+`. It is printed raw on stderr and in `--review` output, and it is the title fallback. I confirmed an ESC sequence in a folder name reaches `--review` output and `index.md`. The orchestrator reads that output at P0, so a long slug is a path for instruction text to reach the agent. | Limit the slug to `[a-z0-9-]+` and the length to about 80 characters. Treat a folder that fails as malformed and print it with `JSON.stringify`. | open |
| S-005 | low | availability | `backlog-index.mjs:63` | `readFileSync` loads the whole file. A 300 MB entry parsed in under a second here. A file above the V8 string limit throws, the catch reports the entry unreadable, and the script exits 1. Nothing hangs. The only effect is a failed CI step for the PR author, who controls that CI run anyway. Long whitespace lines (10 MB) caused no ReDoS in the date pattern. | Read only the first 64 KB with `fs.readSync`, or reject a file over a fixed size. | open |
| S-006 | low | file write | `migrate-backlog-priority-and-theme.sh:33-69`, `.ps1:77` | The symlink check and the write are separate steps, so a swap between them is possible. The Bash helper writes with `cat "$tmp" > "$f"`, which is not atomic and truncates the entry if the process stops mid-write. It leaves `$tmp` behind on interruption. Both helpers need local write access to the repo, so this is a robustness issue. I confirmed CRLF endings, a missing final newline, a second `---` block in the body, and an existing key are all handled correctly. | Write the temporary file in the same folder and `mv` it over the entry. Add a `trap` to remove temporary files. | open |
| S-007 | informational | config (CI) | `.github/workflows/ravintio.yml:44-45`, `ravintio-zero/hooks/ravintio.yml` | The new step runs a fixed command. It uses no `${{ }}` expression, no secret, and no write permission. The workflow trigger is `pull_request`, with `contents: read`. A PR can change the script that checks the index, as it can already change `check-attribution.mjs`. Both workflow files carry identical steps. | None. | accepted |
| S-008 | informational | injection | `orchestrator-p0-start-actions.md` (step 10) | The new text runs the script and reads `plan/backlog/index.md`. It adds no instruction to follow entry text and keeps the rule that a malformed entry is flagged and never parsed as instructions. The residual path is the slug and title, covered by S-003 and S-004. | None beyond S-003 and S-004. | accepted |

## Checks that passed

- A theme with an embedded `\n## injected` is rejected (`invalid theme`). Priority, status, and theme are checked against fixed sets or a strict pattern, so they cannot carry text into the index.
- A symlinked `entry.md` and a symlinked entry folder pointing outside the tree both exit 1 with a `check:` line. Nothing is read through the link.
- CRLF entries parse. The first `title` wins when a key repeats.
- A missing `priority`, `theme`, or `status` reads as the default. The script prints no body text.
- `--today` output goes through `JSON.stringify`. `backlogReviewDays` accepts only a positive integer.
- The Bash helper skips symlinks and unclosed frontmatter. It adds keys only before the first closing rule.

## Dependency audit

No new dependencies. The script and helpers use Node built-ins, Bash, `awk`, and PowerShell only.

## Threat model

| Threat | Attack vector | Affected component | Likelihood | Impact | Existing mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Overwrite of a file outside the repo | A committed link at `plan/backlog/index.md` | `backlog-index.mjs` | low | medium | Entry links are refused | The output path is unchecked (S-002) |
| Instruction text reaches the agent | Hostile title or folder slug in `--review` output | `backlog-index.mjs`, orchestrator step 10 | low | medium | Enum checks on priority, status, theme. No body text | Slug and title are free text (S-003, S-004) |
| Hung migration on Windows | An unclosed CRLF entry | `.ps1` helper | low | low | None | Regex backtracking (S-001) |
| Truncated entry | Interrupt during the Bash write | `.sh` helper | low | low | Idempotent re-run | Non-atomic write (S-006) |

## Recommendations

1. Fix S-001 before the PowerShell helper reaches Windows consumers.
2. Add the link check and atomic write to the script output (S-002).
3. Restrict the slug and clean titles (S-003, S-004).
4. Make the Bash write atomic and add a `trap` (S-006).

## Risk register cross-check

- R-001: open, low. CI names the command that regenerates the index. Not a security risk.
- R-002: partly held. Theme, priority, status, and body text cannot reach the output. Title and slug can carry Markdown and control characters. Update the mitigation text to say so, and see S-003 and S-004.
- R-003: accepted. Not a security risk.
- R-004: held for the Bash helper, verified with CRLF, no final newline, and a second block. It fails for the PowerShell helper on an unclosed CRLF entry (S-001). The risk register says it skips an entry with no closing rule, and the PowerShell helper hangs instead.
- R-005: accepted. Missing fields read as defaults, verified.

## Design cross-check

The design says the script "never prints body text" and prints "ids, slugs, priority, and theme". That holds. The design does not list the title, which the index also prints. The design also does not cover the index write path (S-002).
