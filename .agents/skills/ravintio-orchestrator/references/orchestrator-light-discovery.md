---
title: "Orchestrator reference: Light discovery"
summary: "The light P0 track for fixes and small changes."
status: "active"
version: "1.0.0"
---
# Orchestrator reference: Light discovery

> Read this file when the brief describes a fix or a small change. The Pack Index in `SKILL.md` lists the trigger.

### Offer the light track

<!-- rule: light-offer -->
If the brief describes a fix or a small change, offer the light track and ask the human to confirm it. Never start it without a confirmation. In an initiative step, the chart accepts the track, so you need no further confirmation.

### Light questions

<!-- rule: light-questions -->
Ask three questions, one at a time. Ask for the expected behaviour, the acceptance check, and the version bump.

### Skipped items

<!-- rule: light-skips -->
The light track skips the Scope Lock Challenge and the full Discovery Gate Checklist. Every other P0 rule still applies.

### Records

<!-- rule: light-records -->
A light run still writes `discovery.md`, `design.md`, and the build log. The design needs a human confirmation, as in the full track.

`design.md` holds every heading in `ravintio-zero/templates/design.template.md`. The `check-design` script and the `gate-write` hook read them:

- `## Feature`
- `## Product Layer`
- `## Architecture Layer`
- `## Engineering Layer`
- `## Component Paths`
- `## Scope`
- `## Assumptions`
- `## Risks`
- `## Dependencies`
- `## Active Skills`
- `## Skill Map`
- `## Repo Instructions`
- `## Confirmation`

Keep each section short. Write "none" when a section has nothing to say.

### Track marker

<!-- rule: light-marker -->
Record `Track: light` or `Track: full` in the Header table of `discovery.md`. A missing marker reads as full.

### Switch to the full track

<!-- rule: light-switch -->
If the change grows, switch to the full track. Growth means a new component, a schema change, or a second feature. Change the marker to `Track: full`, then add this line to the build log: `Track switched: light to full ({reason})`. Run the Scope Lock Challenge and the full Discovery Gate Checklist before the design gate.
