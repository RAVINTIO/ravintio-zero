---
title: "Writing standards"
summary: "The pack's prose rules: the Google developer documentation style in a British English variant."
status: "active"
version: "0.1.0"
---
# Writing standards

Write all user-facing prose to the [Google developer documentation style guide](https://developers.google.com/style). That covers replies, reports, README files, plans, commit messages, and code comments. This file is a variant of that guide. Where the two conflict, this file wins.

Setup generates two outputs from this file. For Claude Code, it writes the `style-rules` region into `.claude/output-styles/ravintio-writing.md`. For Codex, it writes the `summary` region into `AGENTS.md`. Text outside the two regions never reaches those outputs. Edit the regions to change what an agent reads. Pass `--no-writing-style` to setup to skip both outputs.

Code, SQL, and data values are out of scope. The rules govern prose.

## Departures from the Google guide

- British English spelling.
- No em dashes.
- No semicolons.
- A sentence limit and a readability check on each sentence.

<!-- BEGIN style-rules -->
Write every user-facing sentence to the Google developer documentation style guide. The departures below override the guide. That covers chat replies, reports, README and plan documents, commit messages, and code comments.

## Voice and structure

- Lead with the answer or result. Context follows.
- Use second person and active voice. One idea per sentence.
- Put the condition before the instruction: "If the file doesn't exist, create it."
- Use sentence case for headings. Use numbered lists for sequences, bullets otherwise, and tables when the reader will compare values.
- Use descriptive link text: "see the authentication guide", never "see here".
- State failures plainly. Don't hedge or soften them.
- Write for readers whose first language isn't English. Avoid slang, clichés, and idioms.

## Sentences

- Keep every sentence under 25 words. Aim for an average near 15.
- Check each sentence of 14 words or more for readability. Swap the longest word for a shorter one before you split the sentence.
- Allow one subordinate clause per sentence. Never chain two "which" or "that" clauses.
- Write complete sentences in prose. A list item may be a fragment.
- Treat "is", "are", "was", or "were" plus a past participle as passive voice. Name the actor and put it before the verb.
- Do not use em dashes or semicolons. End the sentence and start a new one.
- Do not group things into threes for rhythm. Use three items only when exactly three exist. Pull a list of three or more items into bullets.
- No exclamation marks. No `please note`. No `as you can see`.

## Words

- Never call anything `simple`, `simply`, `easy`, `just`, or `obviously`.
- Never label your own prose `honest`, `frankly`, `candidly`, or `to be fair`.
- Never write `load-bearing`, `the crux`, or `the linchpin`. Say what depends on it.
- Never write an aside about your own answer, such as `that's not nothing` or `that's on me`.
- Write "allowlist" and "blocklist". Write "replica" for `slave`. Name the real role instead of "master".
- Cut ableist wording. Write "final check" for `sanity check`. The same goes for `crazy`, `insane`, `dumb`, `lame`, `blind to`, and `cripple`.
- Cut violent metaphors. Write "stop the process" for "kill it", "doesn't respond" for "hangs", and "click" for "hit".
- Cut needless gender. Write "person-hours" for `man-hours`. Use "they" for a person whose pronouns you don't know.
- Never call a figurative statement `literal` or `literally`.
- Use the shorter word: "use" not `utilise`, "to" not `in order to`, "before" not `prior to`, "also" not `additionally`, "help" not `facilitate`.

## Mechanics

- Use the serial comma. Use British spelling: "colour", "organise", "licence" as a noun. Keep the standard spelling in code identifiers, API names, library names, quoted output, `LICENSE` files, "program" for software, and "disk".
- Use code font for filenames, commands, flags, and literal values. Use bold for UI elements.
- Write dates as 2026-08-18 or "August 18, 2026". Never write 8/18 or 18/8.
- Don't pre-announce work in documents. Write what is true now.
- When you edit an existing document, keep its conventions. New sentences follow this guide.
<!-- END style-rules -->

## Summary for tools without output styles

<!-- BEGIN summary -->
- Lead with the answer. Use second person, active voice, and one idea per sentence.
- Keep every sentence under 25 words. Aim for an average near 15.
- Use British English spelling, except in code identifiers, API names, and quoted output.
- Do not use em dashes or semicolons. Use no exclamation marks.
- Write dates as 2026-08-18 or "August 18, 2026".
- Never write `simple`, `simply`, `easy`, `just`, or `obviously`.
- Use "allowlist" and "blocklist". Cut ableist wording and violent metaphors.
<!-- END summary -->

## Agreement with other standards

`formatting-standards.md` section 1 holds the date rules and section 4 holds the em dash rule. They match this file. If the two disagree, this file wins and the other file needs a fix.
