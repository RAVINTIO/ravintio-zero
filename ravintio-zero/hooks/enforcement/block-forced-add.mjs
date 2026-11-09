#!/usr/bin/env node
/**
 * PreToolUse hook (matcher: Bash): forced-add guard (feature 0000317, ADR-001).
 *
 * Blocks a `git add` or `git stage` that forces an ignored file into the
 * index. A forced add committed driver logs and the human ack in initiative
 * 0000238. Feature 0000357 widened the guard.
 *
 * The check runs on each segment of a compound command (split on && || ; & |
 * newlines, parentheses, braces, and backticks, so a subshell or a command
 * substitution becomes its own segment), after quote and backslash characters
 * are removed. A segment that holds `$` is blocked when its git subcommand is
 * `add`, `stage`, or a variable, because the guard can't read the value. A
 * variable glued to `git`, as in `git${IFS}add`, is blocked too.
 * Otherwise a segment is blocked when it carries one of:
 *   - `--force`, or any abbreviation git accepts (`--f`, `--fo`, `--forc`)
 *   - a short flag group that contains `f`, such as `-f` or `-fA`
 * Two bypasses are closed (feature 0000393). The global options --git-dir,
 * --work-tree, --namespace, --config-env, --super-prefix, and --attr-source
 * take a separate value, so the subcommand lookup skips that value as it does
 * for -C and -c. A git add or git stage whose command holds a brace expansion,
 * as in `git add {-f,x}`, is blocked, because the split on braces would put the
 * flag in a segment without git. A `{ git add x; }` group is not an expansion.
 * Flags after a bare `--` are paths and are ignored. This covers the
 * `git -C {dir} add -f` form, because the check does not assume `add` is the
 * first word after `git`.
 *
 * The hook never runs the command text. A form it misses is caught by the CI
 * check on `git ls-files -ci --exclude-standard`.
 *
 * Exit codes: 0 = pass, 2 = block (message on stdout and stderr).
 * Malformed stdin and non-Bash tools exit 0, because no command text exists.
 */

import { readStdin } from "./read-stdin.mjs";

const FORCE_LONG = /^--f(o(r(c(e)?)?)?)?(=.*)?$/;
const SHORT_GROUP = /^-[A-Za-z]*f[A-Za-z]*$/;

function block(reason = "A forced git add is blocked. ") {
  const message =
    "[RAVINTIO] block-forced-add: " + reason +
    "A step never runs git add -f or git add --force. " +
    "If a file is ignored on purpose, leave it out. " +
    "If it must be tracked, add a negation rule to .gitignore. " +
    "To write text that names the command, use the Write tool. " +
    "See ravintio-zero/standards/hook-enforcement.md.\n";
  process.stderr.write(message);
  process.stdout.write(message);
  process.exit(2);
}

function wordsOf(segment) {
  return segment.replace(/["'`\\]/g, "").split(/\s+/).filter(Boolean);
}

function addsFiles(segment) {
  const tokens = wordsOf(segment);
  return tokens.includes("git") && (tokens.includes("add") || tokens.includes("stage"));
}

// Global git options that take the next word as a value. The attached form,
// as in `--git-dir=.git`, has no separate value and needs no skip.
const OPTIONS_WITH_VALUE = new Set([
  "-C", "-c", "--git-dir", "--work-tree", "--namespace",
  "--config-env", "--super-prefix", "--attr-source",
]);

// The git subcommand: the first word after `git` that is not an option. An
// option that takes a value has that value skipped too.
function subcommandOf(tokens) {
  let i = tokens.indexOf("git") + 1;
  while (i > 0 && i < tokens.length) {
    if (OPTIONS_WITH_VALUE.has(tokens[i])) i += 2;
    else if (tokens[i].startsWith("-")) i += 1;
    else return tokens[i];
  }
  return "";
}

// A variable the guard can't read blocks only when git's subcommand is add or
// stage, or is itself a variable. A commit message that says "add $VERSION"
// passes.
function expandsVariable(segment) {
  if (!segment.includes("$")) return false;
  const tokens = wordsOf(segment);
  if (!tokens.includes("git")) return false;
  const sub = subcommandOf(tokens);
  return sub === "add" || sub === "stage" || sub.startsWith("$");
}

function forcesAdd(segment) {
  const tokens = wordsOf(segment);
  if (!addsFiles(segment)) return false;
  for (const t of tokens) {
    if (t === "--") break;
    if (FORCE_LONG.test(t) || SHORT_GROUP.test(t)) return true;
  }
  return false;
}

let command = "";
try {
  const input = JSON.parse(await readStdin());
  const tool = input?.tool_name;
  if (tool && tool !== "Bash") process.exit(0);
  command = String(input?.tool_input?.command ?? "");
} catch {
  process.exit(0);
}

try {
  for (const outer of command.split(/&&|\|\||[;&|\n]/)) {
    // A variable glued to git, as in git${IFS}add, hides the subcommand.
    if (/\bgit\$/.test(outer.replace(/["'\\]/g, ""))) {
      block("A git command built from a variable is blocked, because the guard can't read it. Write the command out. ");
    }
    // A brace expansion, as in git add {-f,x}, hides a flag from the segment
    // split below. A shell group such as `{ git add x; }` has a space after the
    // brace and is not an expansion. A `${` variable is handled elsewhere.
    if (/(^|[^$])\{[^\s}]/.test(outer)) {
      const tokens = wordsOf(outer);
      if (tokens.includes("git")) {
        const sub = subcommandOf(tokens);
        if (sub === "add" || sub === "stage") {
          block("A git add or git stage with a brace group is blocked, because the braces can hide a flag. Write each path out. ");
        }
      }
    }
    for (const segment of outer.split(/[(){}`]/)) {
      if (expandsVariable(segment)) {
        block("A git add or git stage with a variable is blocked, because the guard can't read the flags. Write literal paths. ");
      }
      if (forcesAdd(segment)) block();
    }
  }
} catch {
  // Unreachable for string input. A failure here must not allow a forced add.
  block();
}
process.exit(0);
