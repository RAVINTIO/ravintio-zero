---
id: ADR-0013
title: Anthropic-first skill trust model
status: accepted
date: 2026-04-20
deciders: [human-on-the-loop]
component: "ravintio-zero"
feature: "0000003-hook-based-enforcement"
---
# ADR-0013 - Anthropic-first skill trust model

## Context

REQ-024 introduces the ability to fetch external skills from remote sources. Skills are SKILL.md files with embedded agent instructions, so they directly influence agent behaviour. The pipeline needs a trust model that defines which sources it allows without human approval.

## Decision

The official Anthropic skills repository (`https://github.com/anthropics/skills`) is the **single trusted source**. The pipeline installs skills from this source without additional confirmation.

All other sources require **explicit interactive Human on the Loop approval** at install time. The human must confirm the full source URL and skill name before the install proceeds. There is no allowlist mechanism for non-Anthropic sources. Approval is per-install, not per-source.

## Rationale

1. **Blast radius.** A malicious SKILL.md could instruct the agent to exfiltrate data, bypass guardrails, or produce harmful output. The trust boundary must be clear and conservative.
2. **Anthropic as authority.** Anthropic's own skills repo is the canonical, reviewed source. These skills need no additional vetting.
3. **Simplicity over flexibility.** An allowlist configuration would add complexity and could be misconfigured. Per-install approval for unknown sources keeps the human in the loop for every novel source.
4. **No silent installs.** Even for authorised non-Anthropic skills, the human sees exactly what URL and skill name is being installed before it happens.

## Alternatives considered

- **Allowlist of trusted domains:** Rejected. Adds configuration surface. A compromised domain would bypass approval silently.
- **All sources require approval (including Anthropic):** Rejected. Adds unnecessary friction for the primary use case.
- **GPG-signed skills only:** Rejected. Overly complex. No signing infrastructure exists today.

## Consequences

- Non-Anthropic skills remain usable, and they need only one interactive confirmation.
- If an attacker compromises the Anthropic repo, the pipeline would install its skills without confirmation. This is an accepted risk given the operational context.
- The manifest stores the source URL, which provides an audit trail.
