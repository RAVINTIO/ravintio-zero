# Contributing

Thank you for helping with RAVINTIO Zero. This guide covers the rules every change follows.

## Branch names

Name your branch with one of these prefixes:

- `feat/` for new features.
- `chore/` for maintenance.
- `hotfix/` for urgent fixes.

## Pipeline rules

- Code needs documentation. Every component has a `component.yml` manifest and `docs/` artifacts.
- Code needs tests. Write the failing test first, then the code.
- Update the affected plan and docs files when your change departs from the design.

## Run the tests

Run the full suite before you push:

```bash
bash ravintio-zero/tests/run-tests.sh
```

## Pull requests

- Open the pull request from your branch.
- An agent squashes its own feature pull request into an `initiative/*` branch after CI passes.
- A human reviews and merges every pull request into `main`.
- Do not commit directly to `main`.

## Commit messages and pull request bodies

Do not add AI attribution lines. That includes `Co-Authored-By` trailers and generated-with notices. The `commit-msg` hook rejects them.
