---
title: "Backlog Entry: 0000606 - plan scan cause for anchor edits"
summary: "A rule anchor adds bytes and a comment to a file that other suites measure or that setup copies, and the plan scan has no cause for it."
status: "open"
priority: "medium"
theme: "tests"
---
# Backlog Entry: 0000606 - plan scan cause for anchor edits

**Source feature:** 0000579-convert-remaining-suites-to-rule-anchors

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-26

---

## Problem

Step 35 added about 400 rule anchors. Three kinds of consumer broke. Byte cap suites measured `SKILL.md` with the anchors. Setup copied anchors in the boot templates into installed files. A ratchet suite compared the assertion count of a feature suite with its regression copy. The plan scan has no cause that lists these consumers before an anchor edit.

## Wanted outcome

The plan scan has an `Anchor edit` cause. It lists the greps for byte caps on the edited file, the setup copy of the edited file, and assertion counts that a ratchet compares. A test checks that the plan skill names the cause.

## Suggested Action

Add the cause to `skills/ravintio-plan/references/test-impact-causes.md`. Name three greps. The first finds `wc -c` on the edited file. The second finds the files that setup renders into installs. The third finds ratchet suites that count `assert_` lines.

## Why Deferred

The step already ran past P1 when the breaks showed. The cause needs its own plan skill edit and test.
