---
title: "Feature Brief - Refuse a symlink at the writing style output paths"
summary: "Setup refuses to write the writing style files through a symlink."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Refuse a symlink at the writing style output paths

**Feature ID:** 0000551-refuse-symlink-style-outputs

## Business Goal

Setup writes the writing style output and the `AGENTS.md` writing block with no symlink check. A symlink at either path redirects the write to another file. Setup must refuse the write and say so.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Refuse a linked style path | As a repo owner, I run setup on a repo with a symlink at a style output path, so that setup writes nothing through the link and exits 0 with a fixed line. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | `setup.sh` and `setup.ps1` install the writing style |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `.claude/output-styles/ravintio-writing.md`, the `AGENTS.md` writing block | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | bash, PowerShell |
| Testing | shell tests under `ravintio-zero/tests/` |
| Build target | local |

## Scope Boundaries

### In Scope
- A link check on the style file path and its folder in both setup scripts.
- A link check on `AGENTS.md` before the writing block write.
- A fixed refusal line per path. Exit 0.
- One test per shell.

### Out of Scope
- The `AGENTS.md` boot file write by `write_boot_file`.

### Deferred
- Refuse a link at the boot file write. It blocks nothing here.

## Non-Functional Requirements

None.

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Assumptions
- A broken link counts as a link.

## Scenario Paths

**Happy path:** A plain file or no file at each path. Setup installs as before.

> Unchanged.

**First-run path:** No path exists. Setup creates them.

> Unchanged.

**Error / sad path:** A link at a path. Setup prints the fixed line, skips the write, and exits 0.

> Fixed line, skip, exit 0.

**Cross-session continuity:** None. Setup holds no state across runs.

> None.

## Acceptance Criteria

- [ ] Setup on a repo with a link at `.claude/output-styles/ravintio-writing.md` writes nothing through it, prints the fixed line, and exits 0.
- [ ] Setup on a repo with a link at `AGENTS.md` writes no writing block through it, prints the fixed line, and exits 0.
- [ ] Each shell has a test for both cases.
