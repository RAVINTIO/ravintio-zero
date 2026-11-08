---
title: "Story Map - 0000394-github-security-and-ci-lint"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000394-github-security-and-ci-lint

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Report and contribute | Find the security and community files | US-001 | REQ-001 |
| Keep CI safe | Pin every action and add supply-chain workflows | US-002 | REQ-002 |
| Keep CI safe | Lint the workflows in CI | US-003 | REQ-003 |
| Push a change | Run the brand guard before the push | US-004 | REQ-004 |
| Administer the repo | Turn on the admin-only settings and check them | US-005 | REQ-005 |
| Release | Attest release artifacts | none | gap: out of scope |

## Gaps

- Artifact attestations are out of scope because `release-tag` publishes no artifact.
