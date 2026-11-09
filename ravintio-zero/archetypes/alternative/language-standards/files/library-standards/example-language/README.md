---
title: "Example language standards"
summary: "A template that names the linters and formatters that CI runs for one language."
status: "active"
version: "0.1.0"
---
# Example language standards

Rename this folder to your language, such as `python`. The pipeline reads it in place of the pack copy.

## Linters

- Linter: `ruff check`. CI fails on any finding.
- Type checker: `mypy --strict`.

## Formatters

- Formatter: `ruff format`. CI fails when a file needs reformatting.

## Prefer and avoid

| Concern | Prefer | Avoid | Reason |
|---------|--------|-------|--------|
| Validation | `pydantic` | Hand-written checks | One schema per input |

Replace the sample tools with the ones your CI runs.
