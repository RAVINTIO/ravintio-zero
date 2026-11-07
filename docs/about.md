---
version: "0.55.0"
feature: "0000358-clean-step-stops-and-logs"
updated: "7 Nov 2026"
---
# About

> This file is the canonical version record for this project.
> Do not edit manually. Version changes are confirmed during discovery.

| Field | Value |
|-------|-------|
| Version | `0.55.0` |
| Last feature | `0000354-steps-run-to-the-end` |
| Updated | `6 Nov 2026` |

## What this is

RAVINTIO Zero is a specification-first pipeline for Claude Code and Codex. The
repository holds one component, `ravintio-zero`. It is a component pack of
standards, skills, hooks, templates, schemas, and setup scripts.

The pipeline runs five phases: discovery, plan, implement, validate and
accept, and ship. Twelve skills drive it. Every change is a feature change
and runs the same pipeline. A small change is a small run.

RAVINTIO Zero ships no telemetry and makes no outbound network calls.
Observability belongs to the tool that runs the session.
