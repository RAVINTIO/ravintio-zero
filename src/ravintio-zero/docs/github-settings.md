---
title: "GitHub settings checklist"
summary: "The admin-only repo settings that a human turns on, and the script that checks them."
status: "active"
version: "0.1.0"
---
# GitHub settings checklist

Six repo settings need admin rights, so a step session cannot set them. A human turns them on. The script `ravintio-zero/scripts/github-settings.mjs` lists and checks them.

## Commands

- `node ravintio-zero/scripts/github-settings.mjs list` prints the checklist.
- `node ravintio-zero/scripts/github-settings.mjs check` reads each setting through `gh api`. It prints `on`, `off`, or `unknown` per item and exits 1 unless every item is on.

## Items

| Item | Where to set it |
|------|-----------------|
| `secret-scanning` | **Settings** > **Advanced Security** > **Secret scanning** |
| `push-protection` | **Settings** > **Advanced Security** > **Push protection** |
| `dependabot-security-updates` | **Settings** > **Advanced Security** > **Dependabot security updates** |
| `private-vulnerability-reporting` | **Settings** > **Advanced Security** > **Private vulnerability reporting** |
| `topics` | Repo home > **About** > **Topics** |
| `workflow-lint-required` | **Settings** > **Rules** > `Protect Main Branch` > add the `workflow-lint` required check |

## Notes

- A token without admin rights cannot read `security_and_analysis`. The script prints `unknown` for those items.
- CodeQL default setup stays off because `.github/workflows/codeql.yml` runs the analysis.
- Artifact attestations wait until `release-tag` publishes an artifact.
