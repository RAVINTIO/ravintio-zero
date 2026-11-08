# Execution Plan - Writing standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Version:** 0.61.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| none | plan | No capability skills are active |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-writing-standard.md](requirements/req-001-writing-standard.md) | The pack ships `writing-standards.md` with two marked regions |
| [req-002-standards-agree.md](requirements/req-002-standards-agree.md) | `formatting-standards.md` and the em dash guard agree with the standard |
| [req-003-claude-output-style.md](requirements/req-003-claude-output-style.md) | Setup installs an output style and sets `outputStyle` for Claude Code |
| [req-004-codex-section.md](requirements/req-004-codex-section.md) | Setup adds a writing section to `AGENTS.md` for Codex |
| [req-005-opt-out.md](requirements/req-005-opt-out.md) | `--no-writing-style` skips both outputs and refresh keeps it |
| [req-006-briefs-name-standard.md](requirements/req-006-briefs-name-standard.md) | Dispatch prompts and step sessions name the standard |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | Each generated output matches a fresh generation | 0 differences | A test regenerates and compares |
| NFR-002 | Reliability | A second setup run changes nothing | 0 changed files | A test runs setup twice and compares a checksum of the tree |
| NFR-003 | Portability | Bash and PowerShell setup write the same bytes | 0 differences | One test per shell on the same fixture |

## API Summary

No API.

## Data Model Summary

No data model. Setup writes `.claude/output-styles/ravintio-writing.md`, the `outputStyle` key, and an `AGENTS.md` section.

## Component Interactions

```mermaid
flowchart LR
    S[standards/writing-standards.md] -->|regions| G[scripts/writing-style.mjs]
    G -->|stdout| U[setup.sh, setup.ps1]
    U -->|write| O[.claude/output-styles, settings.json, AGENTS.md]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill count | none found. The run adds no skill. | none |
| Skill-text budget | `test-0000245-req-003-004-repo-skills-and-size-cap.sh` and `test-0000020-req-001-010-refresh-setup-skill.sh` read `ravintio-refresh-setup/SKILL.md`. The run edits one line. | U5 |
| Size cap | none found. The run leaves the orchestrator unchanged. | none |
| Backlog entry id 0000300 | `test-0000247-req-002-commit-id-reservations.sh` matches the id | U5 |
| Workflow job or step edit | none found. The run leaves `ravintio.yml` unchanged. | none |
| `DD MMM YYYY` pin | `test-0000005-pack-governance.sh`, `regression/test-0000005-pack-governance.sh` | U1 |
| Driver arguments | `helpers/driver-args.sh`, `test-0000240-req-001-driver-stream-args.sh` | U5 |
| Dispatch template text | `test-0000151-req-007-dispatch-model-tiers.sh`, `test-0000025-req-003-subagent-parallelism-expansion.sh` | U5 |
| Em dash message | `test-0000028-req-006-em-dash-guard.sh` | U1 |
| Setup flag lists | `test-0000020-req-001-010-refresh-setup-skill.sh`, `test-0000196-req-003-refresh-names-retired-flag.sh`, `test-0000032-req-004-refresh-setup-reads-record-first.sh` | U5 |
| Codex setup output | `test-0000207-req-001-003-codex-setup.sh`, `.ps1` | U3, U4 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U1 | none | `standards/writing-standards.md`, `standards/formatting-standards.md`, `hooks/enforcement/em-dash-guard.mjs`, `tests/test-0000389-req-001-002-standard.sh`, the `DD MMM YYYY` and em dash tests | 1 | U2 reads the regions that U1 writes |
| U2 | U1 | `scripts/writing-style.mjs`, `tests/test-0000389-req-003-generator.sh` | 2 | Setup in U3 and U4 calls the generator |
| U3 | U2 | `setup.sh`, `setup/claude-code.sh`, `setup/codex.sh`, `tests/test-0000389-req-003-005-setup-sh.sh` | 3 | none |
| U4 | U2 | `setup.ps1`, `setup/claude-code.ps1`, `setup/codex.ps1`, `tests/test-0000389-req-003-005-setup-ps1.ps1` | 3 | none |
| U5 | U2 | `standards/agent-dispatch-standards.md`, `scripts/initiative-run.mjs`, `skills/ravintio-refresh-setup/SKILL.md`, `tests/helpers/driver-args.sh`, `tests/test-0000389-req-006-briefs.sh`, pinned tests listed in Test impact | 3 | none |
| U6 | U3, U4, U5 | `component.yml`, `docs/`, `getting-started.md`, `standards/hook-enforcement.md` | 4 | The docs describe the finished behaviour |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Claude Code loads `.claude/output-styles/ravintio-writing.md` and reads `outputStyle` by name from project settings | The style installs and the session ignores it. The Claude Code docs confirm both. |
| A-002 | Node exists wherever setup runs for these tools | Setup skips the writing outputs with a warning |

## Open Questions

None.
