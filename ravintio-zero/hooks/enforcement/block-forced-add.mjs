#!/usr/bin/env node
/**
 * PreToolUse hook (matcher: Bash): forced-add guard (feature 0000317, ADR-001).
 *
 * Blocks a `git add` that forces an ignored file into the index. A forced add
 * committed driver logs and the human ack in initiative 0000238.
 *
 * The check runs on each segment of a compound command (split on && || ; & |
 * and newlines), after quote and backslash characters are removed. A segment
 * is blocked when it names both `git` and `add` as words and carries one of:
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

function block() {
  const message =
    "[RAVINTIO] block-forced-add: A forced git add is blocked. " +
    "A step never runs git add -f or git add --force. " +
    "If a file is ignored on purpose, leave it out. " +
    "If it must be tracked, add a negation rule to .gitignore. " +
    "To write text that names the command, use the Write tool. " +
    "See ravintio-zero/standards/hook-enforcement.md.\n";
  process.stderr.write(message);
  process.stdout.write(message);
  process.exit(2);
}

function forcesAdd(segment) {
  const tokens = segment.replace(/["'`\\]/g, "").split(/\s+/).filter(Boolean);
  if (!tokens.includes("git") || !tokens.includes("add")) return false;
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
  for (const segment of command.split(/&&|\|\||[;&|\n]/)) {
    if (forcesAdd(segment)) block();
  }
} catch {
  // Unreachable for string input. A failure here must not allow a forced add.
  block();
}
process.exit(0);
