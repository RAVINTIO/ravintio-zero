---
title: "Domain Glossary - Replies and questions"
summary: "Definitions of domain terms used within this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - Replies and questions

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000388-replies-and-questions
**Version:** 0.1.0

> The ubiquitous language for this feature. If the glossary says "Order", the code says `Order` - not "Purchase" or "Transaction". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Reply prefix | The label that starts a reply, in the form `{prefix} {Status}: {one-liner}`, such as `P2 Implement:`. | prefix | ravintio-zero |
| Time prefix | The local time as `hh:mm` and one space, placed before the reply prefix. | time | ravintio-zero |
| Reply prefix check | The Stop hook check that tests the first non-empty line of a reply for a valid prefix. It names the warning. | prefix check | ravintio-zero |
| Prefix miss | A reply that fails the reply prefix check. The hook logs it to `plan/.prefix-misses.log`. | miss | ravintio-zero |
| Coordinator session | The human's session that runs the initiative skill. It doesn't set `RAVINTIO_INITIATIVE_STEP=1`. | coordinator | ravintio-zero |
| Step session | A session the driver starts to run one step. It sets `RAVINTIO_INITIATIVE_STEP=1`. | step | ravintio-zero |
| Driver lock | The file `plan/.initiative-runner.lock`, held while the driver runs. | runner lock | ravintio-zero |
| Recommend-then-confirm | The rule that the agent states a recommendation and waits for explicit agreement. | none | ravintio-zero |
| Explicit agreement | The reply "Yes, I agree", or a reply that names the option. "Ok" doesn't count. | none | ravintio-zero |
| Permission | One action the human allows in answer to a question. A question holds one permission, or numbered permissions. | none | ravintio-zero |
| Closed question | A question with a fixed set of answers. The agent asks it through the choice tool. | closed decision | ravintio-zero |
| Open question | A question with no fixed answers. The agent asks it in plain text. | none | ravintio-zero |
| Rule anchor | The marker `<!-- rule: id -->` that lets a test read one rule. | anchor | ravintio-zero |
