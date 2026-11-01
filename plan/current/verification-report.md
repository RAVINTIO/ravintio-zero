# Verification report - 0000327-squash-before-main

I ran the check script against six throwaway branches in a temporary repo outside this one. I removed the repo afterwards. I read the two workflow files, the ship skill section, the standards, and the pickup text, and ran their suites.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| req-001 AC-1: commit count | Script run on `chore/*` and `hotfix/*` branches of one and two commits | verified | One commit exits 0. Two commits exit 1 and the message says to squash. |
| req-001 AC-2: other prefixes | Script run on `feat/x` and `initiative/y` (3 commits) | verified | `feat/x` exits 1. `initiative/y` exits 0. |
| req-001 AC-3: usage and git errors | Missing `--head-ref`, unknown head ref, option-like `--base` and `--head` | verified | Each exits 2. |
| req-001: no commit text | Marker strings in subjects and bodies | verified | 0 matches in output |
| req-002 AC-1: both workflows hold the job | Read both files and ran the suite | verified | Condition, full checkout, read-only permission, and script call present in each |
| req-002 AC-2: no inline branch name | Ran the suite | verified | The head ref reaches the script only through `env`. Each file holds one `contents: write`. |
| req-002: CI runs the job on a PR into main | Not run | not-verifiable | Only a PR into `main` triggers it. This step's PR targets an initiative branch. |
| req-003 AC-1 to AC-3: ship skill rules | Read the section and ran the suite | verified | Lease limited to `chore/*`, replacement PR for `hotfix/*`, CI wait named, skill text 1581 lines against 1720 |
| req-004 AC-1 and AC-2: prefixes and job name | Read the standards and the ruleset doc, ran the suite | verified | Both name the three prefixes. The ruleset doc names `squash-before-main`. |
| req-005 AC-1 and AC-2: hotfix cut | Read step 2 and searched the pack | verified | Step 2 offers `hotfix/{feature-id}`. 0 matches for `checkout -b feat/`. |
