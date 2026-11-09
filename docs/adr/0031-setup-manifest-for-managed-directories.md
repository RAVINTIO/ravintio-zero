---
title: "ADR-0031 - Setup manifest for managed directory tracking"
status: "accepted"
date: "04 May 2026"
feature: "0000007-agent-optimisation"
component: "ravintio-zero"
---
# ADR-0031 - Setup manifest file tracks installed directories for clean re-runs

## Context

When `setup.sh` / `setup.ps1` is re-run (e.g. after updating framework skills), it needs to remove the previously installed skill directories before reinstalling. Without a record of what it installed, the script must do one of two things. It can delete a hardcoded list of directories, which is brittle and breaks if names change. It can also delete the entire target directory, which is dangerous because it may remove user-added files.

## Decision

After each install run, write a `.planifest-manifest` file listing every directory installed. On re-run, read the manifest and remove only the listed directories. Directories not in the manifest are never touched.

## Alternatives Considered

| Option | Pros | Cons | Rejected because |
|--------|------|------|-----------------|
| Hardcode directory names in the script | Simple | Breaks silently when skill directory names change; must be manually updated | Maintenance burden and silent failures |
| Delete entire target directory | Always clean | Destroys user-added files (e.g. `planifest-overrides/capability-skills/`) | Unacceptable data loss risk |
| No cleanup — always add/overwrite | Simple | Stale directories from renamed skills accumulate; agents may load orphaned skills | Orphaned skills add context cost and could conflict |
| Manifest file (chosen) | Precise; survives renames; protects user files | Requires manifest to be accurate; must be written atomically at end of install | Correct behaviour with minimal complexity |

## Affected Components

- `planifest-framework/setup.sh`
- `planifest-framework/setup.ps1`
- `.planifest-manifest` (written to the tool's skill installation directory)

## Consequences

**Positive:**
- Re-runs are safe: only framework-managed directories are ever removed
- The next run handles skill renames correctly
- User-added files in the same parent directory are never touched

**Negative:**
- If setup stops before it writes the manifest, the next run may not clean up correctly. Writing the manifest as the final step after all copies succeed mitigates this

**Risks:**
- A manifest in the wrong location could cause the cleanup to target the wrong directories. Writing the manifest to the same directory as the installed skills, using a relative path, mitigates this

## Related ADRs

- None
