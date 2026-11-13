---
title: "ADR-0033: Plugin as canonical source for context-mode routing rules"
summary: "Planifest stops maintaining its own routing rules template and delegates that responsibility to the context-mode plugin's system prompt, which injects rules automatically at session start."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000008-context-mode-plugin-routing-rules"
---
# ADR-0033 - Plugin as canonical source for context-mode routing rules

**Skill:** planifest-adr-agent
**Tool:** Claude Code
**Model:** claude-sonnet-4-6
**Feature:** 0000008-context-mode-plugin-routing-rules
**Component:** planifest-framework
**Status:** accepted
**Date:** 08 May 2026

---

## Context

Planifest previously maintained a `context-mode-agents.md` template containing instructions for agents to prefer `ctx_*` MCP tools over native tools (Grep, Bash, WebFetch). `setup.sh` / `setup.ps1` copied this file to `AGENTS.md` in the project root when the human passed `--context-mode-mcp`. The intent was to give agents routing rules they would follow cooperatively: advisory guidance layered beneath the hard enforcement hooks.

With the release of context-mode as a marketplace plugin (v1.0.111+), the plugin injects its own routing rules directly into the agent's system prompt. It does this via the plugin's `<system-reminder>` mechanism at session start. This means any project with the plugin installed receives routing rules automatically, without setup copying any file.

Two sources of routing rules now exist simultaneously: the framework-managed `AGENTS.md` and the plugin system prompt. These can diverge as the plugin evolves independently. The framework has no mechanism to track the plugin's version or sync its template to the plugin's current rules.

The question: should Planifest continue to own and maintain a routing rules template, or should it delegate that concern entirely to the plugin?

---

## Decision

Planifest delegates routing rules entirely to the context-mode plugin's system prompt. This change deletes the `context-mode-agents.md` template. It also removes the `AGENTS.md` routing rules copy step from setup scripts. All documentation now describes the plugin as the canonical source.

Planifest retains ownership of enforcement hooks (`block-grep.sh`, `block-bash.sh`, `block-webfetch.sh`). These are a Claude Code platform-specific feature that the plugin cannot provide. `--context-mode-mcp` still installs them.

**Rationale:**
- The plugin is the authoritative source for what `ctx_*` tools exist and how they should be used. As the plugin evolves (new tools, changed semantics), its system prompt tracks those changes immediately. A framework-maintained copy cannot.
- Dual sources of routing rules create a maintenance liability: any divergence silently gives agents conflicting or stale instructions.
- The plugin injects its system prompt at a higher trust level than a copied file. The prompt is always present and cannot be accidentally deleted. It does not depend on the human remembering to re-run setup after plugin updates.
- Enforcement hooks provide hard guarantees independent of routing rules. Even if routing rules are absent, the hooks block disallowed tool calls. The advisory layer is therefore a usability enhancement, not a safety mechanism.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Maintain both (template + plugin) | No disruption to existing setups; belt-and-suspenders routing guidance | Inevitable drift between template and plugin; double maintenance burden; agents may receive conflicting instructions | Two sources of truth for the same concern is worse than one |
| Keep framework template, ignore plugin system prompt | Full control over routing rule content; no external dependency | Template immediately starts drifting from plugin; framework must track every plugin update manually; contradicts the plugin being installed as the authoritative MCP server | Contradicts the purpose of installing a marketplace plugin |
| Per-tool fallback files (one routing rules file per tool that cannot receive plugin system prompt) | No tool left behind for routing rules | Significant ongoing maintenance; unclear which tools support plugin injection; partial solution creates inconsistent user experience across tools | Complexity disproportionate to benefit; deferred as a separate concern (see ADR-0034) |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework/templates | `context-mode-agents.md` deleted; `standard-boot.md` context-mode directive updated to remove AGENTS.md reference |
| planifest-framework/setup.sh | Routing rules copy step removed; help text updated |
| planifest-framework/setup.ps1 | Routing rules copy step removed; help text updated |
| .claude/skills/*/assets/templates/standard-boot.md | Context-mode directive updated (4 skill copies) |
| CLAUDE.md | Context-mode directive updated |
| docs/context-mode.md | Install description updated; Supported tools table updated |
| planifest-framework/tool-setup-reference.md | Routing Rules subsection removed; Creates section and flag description updated |
| planifest-framework/getting-started.md | Option: Context-Mode description updated |

---

## Consequences

**Positive:**
- Routing rules are always current: they track the plugin version, not the framework version
- Eliminates drift risk between framework template and plugin behaviour
- Reduces framework maintenance surface by one concern
- Agents receive routing rules at a higher trust level (system prompt vs. file in context)
- Setup is simpler: `--context-mode-mcp` installs one thing (enforcement hooks), not two

**Negative:**
- Tools that cannot receive the plugin's system prompt (Cursor, Windsurf, Copilot, Cline, Codex) no longer receive routing rules from any source after setup. They previously received advisory routing rules via the copied `AGENTS.md`
- Framework loses the ability to customise or extend routing rules without forking the plugin

**Risks:**
- If the plugin's system prompt is ever absent (plugin disabled, tool incompatibility, plugin version regression), agents have no routing rules and use native tools. Enforcement hooks remain as the last line of defence
- Nobody has confirmed compatibility between non-Claude Code tools and the plugin system prompt. These tools may silently receive no routing rules (tracked in risk register R-001)

---

## Related ADRs

- ADR-0034 - depends-on (the no-fallback decision is a direct consequence of this one)

---

## Supersedes

- None (first ADR for this feature)

## Superseded By

- None

---

*Generated by adr-agent.*
