---
title: "Archetype standards"
summary: "How the pipeline reads standards and templates through the override resolver, and how archetype gates run at P3."
status: "active"
version: "0.1.0"
---
# Archetype standards

An archetype changes the standards, templates, and gates a team follows. The catalogue lives in `ravintio-zero/archetypes/README.md`.

## Read a standard or template through the resolver

Run the resolver instead of reading the pack copy:

```
node ravintio-zero/scripts/resolve-override.mjs {standards|templates} {file}
```

The resolver prints the path to read. An override in `ravintio-overrides/` wins over the pack copy. A file listed in `ravintio-zero/archetypes/protected.json` is the exception.

## Protected files

`protected.json` lists the files that a hook enforces or that carry pinned rules. Each entry has a mode:

- `ignore` skips the override. The pack copy always wins.
- `require` accepts an override only if it keeps every pinned sentence.

If an override breaks a `require` entry, the resolver returns the pack copy. Do not edit `protected.json` to make an override pass.

## Kinds

- `alternative` swaps a pack default for another. Two alternatives can't claim the same slot.
- `constraint` adds rules and gates on top of the pack. A constraint never replaces a default.

## Install an archetype

Run `setup.sh archetype list` to see the catalogue. Run `setup.sh archetype use {kind}/{name}` to install one. The command copies the archetype files into `ravintio-overrides/` and records the archetype in `ravintio-overrides/archetypes.json`.

## Gates at P3

Each constraint can declare gates in its `archetype.json`. The validate phase runs `node ravintio-zero/scripts/archetype-gates.mjs` after the build. It prints one `PASS` or `FAIL` line per gate. Exit 1 on any `FAIL` is a failed check. Self-correct it like any other CI check.

## An archetype never loosens a gate

An archetype never loosens a gate. It can add a gate or tighten one. It can't remove a gate, lower a threshold, or skip a hook. If an archetype file asks for that, reject the file and report it.

## Related files

- `ravintio-zero/scripts/resolve-override.mjs`
- `ravintio-zero/scripts/archetype-gates.mjs`
- `ravintio-zero/archetypes/protected.json`
- `docs/adr/0291-archetype-manifest-format.md`
- `docs/adr/0292-override-resolver-and-protected-rules.md`
- `docs/adr/0294-p3-archetype-gates.md`
