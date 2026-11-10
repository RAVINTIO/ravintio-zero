---
title: "Domain Glossary - 0000399-smoother-activation"
summary: "Definitions of domain terms used within this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - 0000399-smoother-activation

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Version:** 0.1.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Coordinator | The human's non-step session that charts, activates, and delivers an initiative. | coordinator session | ravintio-zero |
| Coordinator PR | A pull request the coordinator opens into `initiative/*`, such as the activation PR. | activation PR | ravintio-zero |
| Charted | The status of a draft initiative whose chart is complete and not yet active. | none | ravintio-zero |
| Draft folder | The folder `plan/roadmap/{id}-{slug}/` that holds a charted initiative before activation. | draft | ravintio-zero |
| Chart table | One of the tables in `initiative.md`: Schema changes, Dependencies, Decisions, Baselines, Criteria, P1 skips, and Steps. | none | ravintio-zero |
| Plan-only | A coordinator PR whose changed files all sit under `plan/`. | none | ravintio-zero |
| Detect line | The `**Detect:**` line in a migration file that says when the migration applies. | none | ravintio-zero |
| Driver | The process `initiative-run.mjs` that runs the steps. | none | ravintio-zero |
| Watcher | The process `initiative-watch.mjs` that reports progress. | watch monitor | ravintio-zero |
