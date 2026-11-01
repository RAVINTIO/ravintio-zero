---
title: "Backlog Entry: 0000259 - ask for explicit agreement and one permission at a time"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000259 - ask for explicit agreement and one permission at a time

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-28

---

## Problem

The agent treats short or unclear replies as agreement. During initiative 0000238, the human answered questions with replies such as these:

- "Ok"
- "Both"
- "2."
- "As wri6", a typo for "as written"
- "Yes. Do that", to a question that offered more than one option

The agent took each one as approval. A reply like "Ok" can mean "I've read this" as well as "I agree". If the agent guesses wrong, it acts without consent.

Some questions also ask for more than one permission at once. One reply then grants all of them, and nobody can tell which permissions the human meant to grant.

## Suggested Action

- Treat "Ok", "fine", "sure", and similar replies as ambiguous when the agent asked for agreement. Ask the human to reply "Yes, I agree".
- If more than one question or option is outstanding, also ask the human to name the option they agree to, as in "Yes, I agree to option 2".
- Ask for one permission per question.
- If one question must ask for more than one permission, number each one. Ask the human to name the numbers they grant.
- If a reply doesn't name a numbered permission, ask again. Don't assume the reply grants all of them.
- Count "Yes, I agree", "approve", and an exact option label as agreement, with no extra question.
- Add the rule to the recommend-then-confirm pattern in `ravintio-orchestrator` and `ravintio-initiative`, and to any phase skill that asks for approval.

## Wanted outcome

The agent acts on a permission only when the human has clearly granted that permission. Tests check these conditions:

- The recommend-then-confirm rule names "Ok" as ambiguous and asks for "Yes, I agree".
- When more than one question or option is outstanding, the rule asks the human to name the option with their "Yes, I agree".
- The rule asks for one permission per question.
- The rule makes a multi-permission question number each permission and asks the human to name the ones they grant.
- The rule tells the agent to ask again when a reply doesn't name the permission it grants.

## Why Deferred

The human asked for it on 2026-10-28, while initiative 0000238 step 4 was in P2. The charted steps don't cover it.
