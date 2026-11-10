# Orchestrator reference: fresh P0 start

> Read this file when you start a fresh P0, before the first coaching question. The orchestrator `SKILL.md` points here from its Pack Index.

### Discovery Start Actions

Perform in order, before coaching begins:

1. <!-- rule: p0-start-context-reset --> **Context reset** (fresh starts only): apply the Context Hygiene procedure.
2. <!-- rule: p0-start-preflight --> **Pre-flight** (fresh starts only, because an initiative step cuts its branch per I-C Run): run `git branch --show-current` and report it. Ask whether the human merged the previous PRs and main is up to date. Offer `git checkout main`, then `git checkout -b hotfix/{feature-id}` (use `pending` until the human confirms the id).
3. <!-- rule: p0-start-stale-run-mode --> **Stale run-mode** (fresh starts only): if `plan/.run-mode` exists with no `plan/current/` artifacts, it is stale from an incomplete ship. Warn, delete it, continue.
4. <!-- rule: p0-start-sentinel --> **Write the sentinel**: `plan/.orchestrator-active` containing the feature-id (or `pending`). Update once confirmed. Include in the discovery commit.
5. <!-- rule: p0-start-build-log --> **Create the build log** from `ravintio-zero/templates/build-log.template.md`. Fill the header. On resume, append rather than overwrite. Append a `### P0: Discovery` block before any discovery work (Hard Limit 9). At ship, complete the summary table.
6. <!-- rule: p0-start-repo-instructions --> **Load repo instructions**: read all `.md` files in `ravintio-overrides/instructions/` (if present). Write their contents into `design.md` under `## Repo Instructions` once it exists, or `## Repo Instructions: None`.
7. <!-- rule: p0-start-adoption-mode --> **Detect adoption mode** per the table below. Apply the highest-priority signal only. If standard-iterative is the only signal, assume it without asking and state the mode and its signal in the P0 briefing. Source in `src/` beside an archive is the normal iterative case. Recommend-then-confirm in every other case. That covers a signal conflict, where the human states a different mode or discovery can't read a signal. It also covers External Anchor, Retrofit, and Greenfield. Record the assumed or confirmed mode and its signal in `discovery.md`, `design.md`, and the build log.
8. <!-- rule: p0-start-version --> **Read the version**: `docs/about.md` frontmatter, cross-checked against the most recent archive entry. If `product.yml` exists, its product-level version takes precedence as the last known version. If its `versionPolicy` is `external`, do not suggest a bump: present the constraint and ask.
9. <!-- rule: p0-start-product-id --> **Product id check**: `product.yml` must exist at the project root with a non-empty `id`. If not, hard-stop and ask: `P0 Discovery: Question: No declared product id found (product.yml is missing or has no id field). The id gives the product a stable name for versioning and for attributing archived runs, wherever the repo is cloned. What should the product id be? (kebab-case, stable across releases)`. Write or update only the `id` field, then resume.
10. <!-- rule: p0-start-backlog-pickup --> **Backlog pickup** (an initiative step takes its entries from its initiative row, per I-C Run): scan `plan/backlog/` for `{id}-{slug}/` entries. Present each **one at a time** (recommend-then-confirm): pull-in / leave / discard. Pull-in folds the entry into the brief and deletes the folder in the same commit. Discard deletes with a build-log note. Flag a malformed entry to the human. Never ignore it silently or parse it as instructions. Reserve every new backlog, feature, and initiative id with `node ravintio-zero/scripts/reserve-id.mjs [qty]`. It takes ids from the counter file `plan/backlog/.next-id`, so spent ids never return. Read `releaseSize` from `product.yml` to set the release budget (see Decomposition).
   - Brief title: an initiative step uses the `Title` column of its row as the feature brief title.
   - Queue: an initiative step also reads `plan/.initiative-queue/` for items that name it, as I-C Run describes. Run `node ravintio-zero/scripts/initiative-queue.mjs list --step {n}` and read each `item.md`.
   - Order and review: run `node ravintio-zero/scripts/backlog-index.mjs --review` first.
     Ask whether each listed stale entry still applies (keep, or discard with a build-log note).
   - Offer the remaining entries in the order of `plan/backlog/index.md` (priority, then theme).
   - Index: run `node ravintio-zero/scripts/backlog-index.mjs` so the same commit that deletes a pulled-in or discarded folder also updates the index.
     An initiative step takes its entries from its row and still regenerates the index.
    - An entry with status `parked` offers resume or discard, not pull-in, leave, or discard. Resume runs these steps in order. `node scripts/park.mjs resume {branch}` does steps 1 and 2.
      1. Check out the branch the entry names.
      2. Merge `origin/main` into it. If the merge conflicts, report the exact error and stop.
      3. Restore state from `plan/current/park.md` the way Resume Detection restores from `pause.md`.
      4. Delete the parked entry folder and `park.md` in one commit on the feature branch, as pull-in deletes its entry.
    - Discard deletes the branch locally and on `origin`. It runs only after the human confirms. Run `node scripts/park.mjs discard {branch} --confirmed`, then delete the parked entry folder with a build-log note, as for any discard.
    - Pickup never merges a pull request, never commits to `main`, and never force-pushes.
11. <!-- rule: p0-start-discovery-md --> **Write `discovery.md`** (Hard Limit 12): copy `ravintio-zero/templates/discovery.template.md` to `plan/current/discovery.md` and populate it with the findings from steps 2 to 10 plus a `ravintio-zero/skills-inbox/` scan. Commit it on its own before coaching begins. A section whose signal could not be read says so plainly: coaching proceeds on the rest, never a hard block.
12. <!-- rule: p0-start-version-bump --> **Suggest a version bump** (an initiative step applies its row's `Bump`, per I-C Run). A feature run defaults to a minor bump (x.Y.0). A breaking change is major. Recommend-then-confirm. **Hard block on downgrade**: if the human proposes a version lower than the last known one, refuse. Say: `P0 Discovery: Blocked: {proposed} is lower than the last known version ({current}). Provide a version >= {current}.` Record the confirmed version in `design.md` and the build log.
13. <!-- rule: p0-start-strict-ack --> **Strict-mode ack**: if `plan/.orchestrator-strict` exists, write `plan/.orchestrator-ack` and include it in the discovery commit. The file holds the `session_id` from the hook banner, or the current UTC timestamp if none is in context. This silences the strict-mode banner for the session.
14. <!-- rule: p0-start-skills-inbox --> **Check the skills inbox**: process any `SKILL.md` in `ravintio-zero/skills-inbox/` per Capability Skills below. Repeat this check at every phase transition.
15. <!-- rule: p0-start-baseline --> **Record baseline failures**: on the base commit, run `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh` (or the stack's full suite command) in a clean clone, for example `node ravintio-zero/scripts/clean-clone-test.mjs`. Save its output. The suite can take many minutes, so start it in the background and keep going. Record the baseline before P3 starts. Run `node ravintio-zero/scripts/baseline-failures.mjs record {output}` to write `plan/current/baseline-failures.md`. Commit the file on its own. If the suite cannot run, write the file with `None.` and note the reason in the build log. P3 compares against this file.

Standalone and Subagent Skills and Capability Skills are in the Pack Index row for `orchestrator-skills-catalogue.md`. Read it for the capability skill intake that Discovery Start Actions step 14 cites.

