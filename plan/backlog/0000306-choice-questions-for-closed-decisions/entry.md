---
title: "Backlog Entry: 0000306 - ask closed questions as choices and open questions as text"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000306 - ask closed questions as choices and open questions as text

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

The orchestrator coaches "one question at a time" and "recommend, then confirm", with a text form such as `Confirm? ([X] / [alternative])`. The pack never says when to use the host's choice tool, such as `AskUserQuestion` in Claude Code. Two failures result:

- An open question becomes a menu of invented options. The human skips the menu and types an explanation afterwards.
- A closed decision over a list becomes free text. On 2026-10-31, the agent asked the human to type "Yes, I agree to all six" when a menu would have done the job.

## Suggested Action

- Add a question rule to `references/orchestrator-discovery-coaching.md` and to the writing standard from entry 0000300.
- For a closed decision, use the choice tool. Examples are approve or reject, pick from known options, or accept items from a list.
  - Put the recommended option first and label it.
  - For a list of items, offer "Agree to all N", "Agree to some" with the items to pick, and "Change wording". The tool always adds "Other".
- For an open question, use plain text. Examples are a value such as a p95 target, a reason, or design input. Never invent options for these.
- Count a picked option as explicit agreement when its label says so, as in "Yes, I agree to all six".
- Ask one decision per question, to match the coaching rule.
- If the host has no choice tool, use the text form. At pickup, confirm what Codex offers.

## Wanted outcome

Closed decisions take one click, and open questions never arrive as a menu. Tests check these conditions:

- The coaching reference states both rules, with an example of each.
- The rule for a list approval names the all, some, and change options.
- The rule names the text fallback for a host with no choice tool.

## Why Deferred

The human asked for it on 2026-10-31, from friction with questions in this session. No run is active.
