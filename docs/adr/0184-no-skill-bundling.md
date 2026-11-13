---
title: "ADR 004: skills read one central copy of each pack file"
summary: "Setup stops bundling pack templates, standards, and schemas into each skill, and skills name each pack file by its full path."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000171-faster-setup-ps1-tests"
---
# ADR-0184 - Skills read one central copy of each pack file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Since 0000031, setup copies pack templates, standards, and schemas into each skill's `assets/` and `references/` folders. A skill's `bundle_templates` and `bundle_standards` frontmatter picks the files. A skill with no list, or with an empty list, gets all 60. A fresh install writes 535 files. Only 24 are the skills' own files. The other 511 are copies of 60 pack files.

No installed skill reads its bundled copies. No SKILL.md holds `./assets/` or `./references/` after the path rewrite. Some skills name pack files by full path, such as `ravintio-zero/standards/roadmap-standards.md`. Others use a short path, such as `templates/story-map.template.md`, or a bare name. Neither form matches the bundled copy, so the agent searches and usually lands on the pack copy.

The Windows CI profile for this feature showed the skill copy takes about 720 ms of a 1,480 ms install on Windows PowerShell 5.1. File creation costs most there.

## Decision

Setup installs only each skill's own folder. The pack folder `ravintio-zero/` must exist for setup to run, so it is the one central copy. Every skill names a pack template, standard, or schema by its full `ravintio-zero/...` path. A Bash suite enforces the rule and checks that each full path exists. The bundle frontmatter fields and the SKILL.md path rewrite go. A rerun removes bundled files that an older install left.

The human approved this change on 2026-10-25 for all platforms, so both `setup.sh` and `setup.ps1` change.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add manifests to the skills that lack them | Smaller change | About 130 files still install, and nothing reads them | Keeps dead copies and saves less time |
| Lower the REQ-001 speed target | No install change | Leaves 511 unused files and loose paths | The human chose the central copy |

## Consequences

- An install writes 24 skill files in place of 535, on every platform.
- A skill cannot run without the `ravintio-zero/` folder. Setup already requires it.
- A consumer's own skill that relied on `bundle_templates` no longer gets bundled copies. It must name pack files by full path.

## Affected Components

- `ravintio-zero/setup.sh`, `ravintio-zero/setup.ps1`
- `ravintio-zero/skills/*/SKILL.md` and skill reference files
- Tests that assert bundle frontmatter or the bundled tree
