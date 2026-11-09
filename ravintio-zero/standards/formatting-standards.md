# Formatting Standards

---

## 1. Date Format

Body text and filenames use different formats. The prose rules are in [writing standards](writing-standards.md).

### Body text: ISO or long form

Human-readable dates in document body text, changelogs, ADRs, plans, comments, and templates use **2026-08-18** or **"August 18, 2026"**. Pick one form for a document and keep it.

| Correct | Incorrect |
|---------|-----------|
| 2026-05-02 | 02 May 2026 |
| January 14, 2025 | 01/14/2025 |
| 2024-12-07 | 07/12/2024 |

Existing artifacts and templates that hold `DD MMM YYYY` stay as they are until a rewrite reaches them. New sentences follow this section.

### Filename prefixes: YYYY-MM-DD

File and directory names where chronological sort order must match filesystem sort order use **YYYY-MM-DD** as a prefix.

Examples: `2026-05-02-changelog.md`, `2025-01-14-security-report.md`

### Machine-readable fields: YYYY-MM-DD

Frontmatter `date:` fields and JSON date values use **YYYY-MM-DD**.

### Forbidden in body text

`MM/DD/YYYY`, `DD/MM/YYYY`, `YYYY/MM/DD`, and any other format not listed above are forbidden in document body text.

---

## 2. Locale: British English

All RAVINTIO prose, labels, comments, template text, and documentation use **British English** spellings.

> **Exceptions:** `artifact`, `initialize`, `serialize`, `disk`, and `program` use American spelling in all contexts. See `ravintio-zero/standards/language-quirks-en-gb.md` for the full exception list.

### Code identifier exception

Code identifiers follow the conventions of the language or framework in use. American English in identifiers is acceptable, and sometimes required, where it is the ecosystem norm.

---

## 3. Response Verbosity

RAVINTIO agents default to the **shortest response that fully communicates the outcome**.

### Rules

1. **Brevity is the default.** Partial sentences and single-line confirmations are correct when the reader needs no explanation.
2. **Explain when the why is non-obvious.** A constraint being applied, a decision that could surprise the human, or a requirement conflict all warrant explanation.
3. **Do not narrate.** Do not describe what you are about to do before doing it, or summarise what you did after doing it.
4. **No affirmatory padding.** Do not open responses with "Certainly!", "Great question!", "Of course!", "As requested,", or similar.
5. **The human can always ask for more.** If they want detail, they will ask. Default to less.

### Examples

**Verbose (incorrect):**
> I have reviewed the feature brief and updated the business goal section to include the new gap you described. The change adds gap 6 to the numbered list and updates the closing summary paragraph to reflect all six gaps. The acceptance criteria have also been updated accordingly.

**Brief (correct):**
> Done. Gap 6 added: business goal, closing paragraph, and acceptance criteria updated.

### When explanation is appropriate

- Applying a constraint that the human did not explicitly request (cite the constraint)
- Deviating from the spec (cite the requirement and explain why)
- Blocking due to a hard limit (state what the limit blocks and why)
- Answering a direct question (answer it)

---

## 4. Em Dash Prohibition

RAVINTIO artifacts must not contain the em dash character (U+2014). Use a comma, colon, full stop and new sentence, or parentheses instead, depending on the sentence. The writing standard bans semicolons.

### Enforcement (req-006, ADR-003, feature 0000028)

`em-dash-guard.mjs` (`ravintio-zero/hooks/enforcement/em-dash-guard.mjs`), a `PreToolUse(Write, Edit)` hook sibling to `gate-write.mjs` and `ratchet-check.mjs`, blocks a write containing U+2014 within `plan/current/`, `docs/`, `ravintio-zero/skills/`, `ravintio-zero/templates/`, and `ravintio-zero/standards/`. The hook does not scan paths outside that set, including `plan/_archive/` and `plan/changelog/` (historical record).

### Bypass

A single-line sentinel comment, `<!-- ravintio-em-dash-allow -->`, present anywhere in the content being written, allows that write through regardless of em dash matches. The sentinel is reusable, not single-use, and either a human or an agent may write it. An em dash carries no weakening semantics, so it does not need the human-only, single-use marker that `plan/current/.ratchet-approve` uses for ratchet approvals.
