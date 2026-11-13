---
title: "ADR 002: Shared module placement and install topology"
summary: "Extracted shared hook modules live inside the existing hooks/enforcement/ and hooks/telemetry/ trees, one directory-scoped module per duplication cluster, with the phase-enum module placed in enforcement/ (always installed) rather than telemetry/ (conditionally installed), and the Tier 1 telemetry glob widened to stop silently dropping new shared modules."
status: "proposed"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000028-telemetry-hardening-and-enforcement-fixes"
---
# ADR-0104 - Shared module placement and install topology

**Skill:** [adr-agent](../skills/adr-agent-SKILL.md)
**Feature:** 0000028-telemetry-hardening-and-enforcement-fixes
**Component:** planifest-framework
**Date:** 2026-08-08

## Context

req-002 extracts six duplicated helpers out of `planifest-framework/hooks/telemetry/*.mjs` and `hooks/enforcement/check-telemetry-*.mjs` into shared modules. `hooks/` is git-tracked source. `.claude/hooks/` is the untracked, gitignored install copy (`.gitignore` line 2 ignores `.claude/` wholesale). `setup.sh` installs hooks as copies, not symlinks. A shared module therefore only exists at runtime if some `setup.sh` code path actually copies it there. Three install paths copy differently:

- `install_enforcement_hooks()` (`setup.sh:527`, glob at `:557`) copies every `*.mjs` from `hooks/enforcement/` unconditionally for non-Tier-1 installs (`setup.sh:1180-1181`). The gate is only `! PLANIFEST_TIER =~ ^1`, not `--structured-telemetry-mcp`. The code comment at `:537` states neither `check-telemetry-*.mjs` hook belongs behind that flag.
- `install_telemetry_hooks()` (`setup.sh:756`, glob at `:778`) copies every `*.mjs` from `hooks/telemetry/`, but only runs when `setup.sh` receives `--structured-telemetry-mcp` (`setup.sh:1220`, `[ "$STRUCTURED_TELEMETRY_MCP" = true ]`).
- `install_tier1_hooks()` (`setup.sh:403`) is used for Cursor, Windsurf, Cline. It copies `hooks/enforcement/*.mjs` with a full glob (`:433`) and copies telemetry with the narrow glob `emit-phase-*.mjs` (`:447`). Tier 1 skips `install_enforcement_hooks()` itself (`setup.sh:1180`, `! PLANIFEST_TIER =~ ^1`) since Tier 1 has its own enforcement copy at `:433` instead. The two paths are mutually exclusive per install, not additive.

Two placement-sensitive consequences follow directly:

1. `install_enforcement_hooks()` and `install_telemetry_hooks()` pick up any new shared module dropped into `hooks/enforcement/` or `hooks/telemetry/` automatically (full glob, no `setup.sh` edit needed). `install_tier1_hooks()` does **not** pick up a module dropped into `hooks/telemetry/`, because its telemetry glob is narrower than its own callers (`emit-phase-start.mjs`, `emit-phase-end.mjs`) require. This is a live bug independent of this feature. This feature must also fix it.
2. `check-telemetry-receipts.mjs` lives in `hooks/enforcement/`, which every install includes (non-Tier-1: unconditional, Tier 1: unconditional via its own `:433` copy). `resolve-phase.mjs` lives in `hooks/telemetry/`, which `setup.sh` installs only when you pass `--structured-telemetry-mcp`. Direct reading of `setup.sh` confirms this, with no assumption involved: `hooks/enforcement/` is the always-present superset, `hooks/telemetry/` is the conditional subset.

Hooks are plain ESM files. An `import` of a module that is not on disk therefore fails at module-load time, before the hook's own top-level `try/catch` runs. A hook that must always exit 0 instead throws unhandled and exits non-zero. That is the opposite of the framework's own "hooks never block the session" invariant. Where something tolerant of a bad exit wraps the caller, this can also present as a silent no-op instead of a visible crash. Either way the same root issue causes the failure: `setup.sh` never installed the module at the caller's location.

## Decision

Extract shared modules in place, inside the existing `hooks/enforcement/` and `hooks/telemetry/` trees, not into a new top-level `shared/` directory. Each duplication cluster from req-002 becomes one small `.mjs` module, imported by relative path from every current caller:

- `hooks/enforcement/read-stdin.mjs` for `readStdin()`. Used by both directories, placed in `enforcement/` and imported cross-directory by the `telemetry/` callers.

  **Corrected during implementation (req-002).** This ADR originally placed `read-stdin.mjs` in `hooks/telemetry/`. It reasoned that "`readStdin` has no caller that is ever active while `telemetry/` is absent". That reasoning was wrong. It fails for the reason this ADR's own phase-enum decision identifies two bullets down. `readStdin`'s callers include `check-telemetry-receipts.mjs` and `check-telemetry-failures.mjs`. Both live in `hooks/enforcement/`, and `setup.sh` installs them unconditionally. `setup.sh`'s own code comment at `install_enforcement_hooks()` states neither belongs behind `--structured-telemetry-mcp`. With telemetry off, `hooks/telemetry/` does not exist at all. Both hooks would then import an absent module and fail at ESM module-load time on the majority install. Placement follows this ADR's standing rule instead: `enforcement/` is the always-present superset, `telemetry/` is the gated subset. A helper with any enforcement caller therefore lives in `enforcement/`.

  Verification, not assumption, backs this. A `setup.sh claude-code` install with no telemetry flag produces `.claude/hooks/enforcement/` with no sibling `telemetry/` directory. `check-telemetry-receipts.mjs`, run against that install, resolves both shared imports and completes its check.

  The count is also larger than this ADR first recorded. `readStdin` had 12 identical-by-behaviour copies across `hooks/enforcement/` (7) and `hooks/telemetry/` (5), not 7. req-006's `em-dash-guard.mjs` added a 13th while this feature was in flight. All 13 now import the shared module.
- `hooks/telemetry/read-product-id.mjs` for `readProductId()`. All 3 callers are in `telemetry/`.
- `hooks/telemetry/record-telemetry-failure.mjs` for `recordTelemetryFailure()`. All 4 callers are in `telemetry/`.
- `hooks/telemetry/emit-event.mjs` for the fetch/AbortController/retry block. All 3 callers are in `telemetry/`.
- `hooks/telemetry/get-flag-path.mjs` for `getFlagPath()`. Both callers are in `telemetry/`.
- `hooks/enforcement/phase-enum.mjs` for the canonical phase enum, imported by `check-telemetry-receipts.mjs` (same directory), `resolve-phase.mjs` and `emit-event-receipt.mjs` (`hooks/telemetry/`, cross-directory import up to `../enforcement/phase-enum.mjs`).

  Implementation found a third independent encoding of the same enum: `emit-event-receipt.mjs`'s `KNOWN_PHASES`, the closed set guarding path construction against traversal (CWE-22). It now derives from the shared enum alongside `PHASE_NUMBER_TO_ENUM` and `PHASE_SKILLS`, so the security guard cannot fall out of step with the two lookup tables.

req-002 excludes `getSessionId()` from consolidation. It has three genuinely different behaviour profiles, and unifying it is a behaviour change, not a refactor.

The phase-enum module lives in `hooks/enforcement/`, not `hooks/telemetry/`. The reason is that `check-telemetry-receipts.mjs` (enforcement, always installed) needs it. Also, `resolve-phase.mjs` (telemetry, conditionally installed) does not gate its own presence on anything the phase-enum module depends on. Placing it in the always-present superset means the conditional consumer (`resolve-phase.mjs`) only ever exists on disk when telemetry is on. Telemetry being on never removes `hooks/enforcement/` from the install. The reverse placement would leave `check-telemetry-receipts.mjs` importing a module that is absent whenever telemetry is off. That is a hard crash on every non-telemetry install, which is the majority case (no `--structured-telemetry-mcp` flag).

`setup.sh:447`'s Tier 1 telemetry glob widens from `emit-phase-*.mjs` to `*.mjs`, matching the pattern already used by `install_enforcement_hooks()` and `install_telemetry_hooks()`. `setup.ps1`'s `Install-Tier1Hooks` carries the identical narrow filter (`Get-ChildItem -Filter 'emit-phase-*.mjs'`) and widens with it, since a test holds the two scripts at parity. The fix applies regardless of exactly which shared modules end up under `hooks/telemetry/`. The narrow glob is a latent bug the moment any file other than `emit-phase-start.mjs` / `emit-phase-end.mjs` joins that directory, extraction or not. Widening to `*.mjs` also makes `context-pressure.mjs`, `emit-event-receipt.mjs`, and `resolve-phase.mjs` installable under Tier 1 for free. The Tier 1 adapter's own registration does not currently wire any of them, and that wiring is out of scope here.

Sequencing constraint: req-002 already states it, and this ADR restates it as the binding reason for the alternatives rejected below. Every shared module must exist, fully populated, in a commit before any commit rewires a caller's import to use it. No commit may contain a caller importing a module absent from that same commit.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Single flat `hooks/shared/` directory for all six modules | One place to look; no cross-directory imports | A fourth top-level hooks directory needs its own install-glob entry in all three `setup.sh` functions, including a fresh Tier 1 decision, and Tier 1 has no existing precedent for a third hooks subdirectory. Also breaks the "always/conditional" distinction that makes the phase-enum placement decision legible: everything in `shared/` would need the always-present treatment or none of it would. | Adds a new install code path for no gain over placing each module in whichever existing tree already installs on the right condition. The always/conditional split enforcement/ vs telemetry/ already provides is exactly the distinction this feature needs; a flat directory erases it. |
| Per-tier duplication accepted as-is (status quo; backlog `0000054`'s stated convention) | Zero install-topology risk; no cross-directory imports; matches existing precedent elsewhere in this repo | Directly contradicts req-002's purpose (US-002: fix once, not five times) and leaves the phase-enum's two independently-maintained maps able to drift, which is the exact defect backlog `0000057` was filed against | req-002 exists because duplication already caused drift risk. Accepting the status quo here is declining the requirement, not an implementation choice. |
| Symlinks from `.claude/hooks/` to `planifest-framework/hooks/` instead of copies | A shared module is present everywhere its source is, with zero glob logic | `.claude/` (and each tool's install dir) is gitignored and reconstructed by `setup.sh` on every run. Introducing symlinks changes the install mechanism for every existing hook, not just the new shared modules, and this repo's own architecture already treats the copy model as an accepted constraint (0000028 design.md Risks: "`.claude/` being gitignored means the live hook install cannot be restored with `git checkout`, only by re-running setup"). | Out of proportion to req-002's scope. Changing copy-vs-symlink for all hooks is a separate decision with its own blast radius (Windows/Cursor/Windsurf symlink support, git worktree behaviour) that this requirement does not need to make to satisfy its acceptance criteria. |
| Bundle all hooks (or all telemetry hooks) into one file, eliminating cross-file imports entirely | No install-glob or placement problem at all: one file, one copy | Defeats the "no `package.json`, dependency-free Node ESM" constraint's spirit by forcing a build/concat step where none exists today. Makes each hook's diff noisy (unrelated hooks' code in the same file) and contradicts req-002's acceptance criteria, which name each helper as extracted "into a shared module" (singular helper modules), not a monolith. | No build step exists in this repo today and introducing one to solve a glob bug is disproportionate. The three install functions already glob-copy individual files correctly (`enforcement/`, `telemetry/` full globs); only Tier 1's telemetry glob needs a one-line fix. |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework | Six new shared `.mjs` modules under `hooks/enforcement/` and `hooks/telemetry/`; all current callers rewired to import by relative path; `setup.sh:447` glob widened from `emit-phase-*.mjs` to `*.mjs`. |
| setup-hook-integration | Tier 1 (Cursor, Windsurf, Cline) installs gain the widened telemetry glob; no other install path changes shape, only file count. |

## Consequences

**Positive:**
- A fix to `readStdin`, `readProductId`, `recordTelemetryFailure`, the emit/retry block, `getFlagPath`, or the phase enum is now made once, not up to seven times.
- The phase enum can no longer drift between `PHASE_NUMBER_TO_ENUM` and `PHASE_SKILLS`, since both derive from one source.
- The Tier 1 glob fix is a general-purpose correction. Tier 1 installs any future file added to `hooks/telemetry/` for Cursor, Windsurf, and Cline without a further `setup.sh` change.

**Negative:**
- `resolve-phase.mjs` now imports across a directory boundary (`../enforcement/phase-enum.mjs`), a cross-tree dependency that didn't exist before. Someone must re-check the always/conditional install reasoning by hand if either directory's install condition ever changes.
- Six new files to track and keep in sync with their callers' relative import paths if either directory is ever renamed.

**Risks:**
- A missing shared module makes an importing hook throw at ESM module-load time, before the hook's own top-level try/catch runs. Every hook must exit 0 on every path, so this failure mode is worse than a normal bug. Depending on how the caller invokes the hook, it presents as a hard non-zero exit (violating the "never block the session" invariant directly). Where the caller tolerates a bad exit, it degrades to a silent no-op with no marker and no stderr line. This ADR's Decision therefore treats both the sequencing rule and the Tier 1 glob fix as mandatory, not optional cleanup. The sequencing rule commits a shared module before any caller import. Mitigation: req-002's acceptance criteria require every rewired hook to run live against the refreshed `.claude/hooks/` install, with representative stdin. Each must exit 0 with unchanged observable output before the requirement counts as done.
- If someone adds a future shared module to only one of `hooks/enforcement/` and `hooks/telemetry/` without re-checking the install conditions, the same crash-on-missing-import failure can recur. It can hit a different module. Mitigation: this ADR's always/conditional reasoning is the standing rule for placing any future shared module between these two directories. Enforcement is the superset and telemetry is the gated subset. The rule is not a one-off judgement for the phase enum alone.

## Related ADRs

- ADR-0103 - depends-on (this ADR's emit-event.mjs module must incorporate ADR-0103's retry loop rather than re-duplicating it, per req-002's stated sequencing with req-001).

## Supersedes

- None.

## Superseded By

- None.
