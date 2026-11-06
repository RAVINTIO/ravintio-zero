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
 * are removed. A segment that names `git` and `add` or `stage` as words and
 * holds `$` is blocked, because the guard can't read the value of a variable.
 * Otherwise a segment is blocked when it carries one of:
 *   - `--force`, or any abbreviation git accepts (`--f`, `--fo`, `--forc`)
 *   - a short flag group that contains `f`, such as `-f` or `-fA`
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

function expandsVariable(segment) {
  return addsFiles(segment) && segment.includes("$");
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
  for (const segment of command.split(/&&|\|\||[;&|\n(){}`]/)) {
    if (expandsVariable(segment)) {
      block("A git add or git stage with a variable is blocked, because the guard can't read the flags. Write literal paths. ");
    }
    if (forcesAdd(segment)) block();
  }
} catch {
  // Unreachable for string input. A failure here must not allow a forced add.
  block();
}
process.exit(0);
