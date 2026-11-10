#!/usr/bin/env node
/**
 * Stop hook: advisory reply writing check (feature 0000390, REQ-005, ADR-0285).
 *
 * Checks the last reply for two rules of the writing standard: sentence-length
 * and blocklist. A breach prints a short note. The note never blocks a turn.
 *
 * The reply is payload.last_assistant_message when it is a string with text.
 * Otherwise the hook reads the transcript once, with no retries, and takes the
 * last assistant message that follows the last user prompt and has text.
 * The hook checks at most 20000 characters.
 *
 * The hook runs only when <cwd>/.claude/output-styles/ravintio-writing.md
 * exists. The cwd is payload.cwd, else process.cwd().
 *
 * Outputs: JSON { systemMessage } on stdout for a breach. The message quotes
 * the first 40 characters of up to 3 offending sentences with the rule detail.
 * A clean reply prints nothing. The hook writes no log file.
 *
 * Always exits 0, including for bad JSON.
 */

import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

import { readStdin } from "./read-stdin.mjs";
import { checkText } from "./prose-rules.mjs";

const MAX_CHARS = 20000;
const MAX_SHOWN = 3;
const QUOTE_LENGTH = 40;
const RULES = new Set(["sentence-length", "blocklist"]);

function textOf(content) {
  if (typeof content === "string") return content;
  if (Array.isArray(content)) {
    return content
      .filter((b) => b && b.type === "text" && typeof b.text === "string")
      .map((b) => b.text)
      .join("\n");
  }
  return "";
}

function isToolResultOnly(content) {
  return (
    Array.isArray(content) &&
    content.length > 0 &&
    content.every((b) => b && b.type === "tool_result")
  );
}

// Returns the text of the last assistant message that follows the last user
// prompt and has text. Returns null otherwise.
function replyFromTranscript(transcript) {
  const lines = transcript.split("\n");
  for (let i = lines.length - 1; i >= 0; i--) {
    if (!lines[i].trim()) continue;
    let entry;
    try {
      entry = JSON.parse(lines[i]);
    } catch {
      continue;
    }
    const message = entry?.message ?? entry;
    const role = message?.role ?? entry?.type;
    if (role === "user") {
      if (isToolResultOnly(message?.content)) continue;
      return null;
    }
    if (role !== "assistant") continue;
    const text = textOf(message?.content);
    if (text.trim()) return text;
  }
  return null;
}

try {
  const input = JSON.parse(await readStdin());
  const cwd = typeof input?.cwd === "string" && input.cwd ? input.cwd : process.cwd();
  if (!existsSync(join(cwd, ".claude", "output-styles", "ravintio-writing.md"))) process.exit(0);

  const given = input?.last_assistant_message;
  let reply = typeof given === "string" && given.trim() ? given : null;
  const path = input?.transcript_path;
  if (reply === null && typeof path === "string" && existsSync(path)) {
    reply = replyFromTranscript(readFileSync(path, "utf-8"));
  }
  if (reply === null) process.exit(0);

  const breaches = checkText(reply.slice(0, MAX_CHARS), { frontMatter: false }).filter((b) =>
    RULES.has(b.rule),
  );
  if (breaches.length === 0) process.exit(0);

  const notes = breaches.slice(0, MAX_SHOWN).map((b) => {
    // eslint-disable-next-line no-control-regex
    const quote = b.sentence.replace(/[\x00-\x1f\x7f]/g, " ").slice(0, QUOTE_LENGTH);
    return `"${quote}" (${b.rule}: ${b.detail})`;
  });
  const more = breaches.length > MAX_SHOWN ? ` ${breaches.length - MAX_SHOWN} more not shown.` : "";
  const systemMessage =
    `[RAVINTIO] Reply writing check: ${notes.join(" ")}${more} ` +
    "This note is advisory. See standards/writing-standards.md.";
  process.stdout.write(JSON.stringify({ systemMessage }));
  process.exit(0);
} catch {
  // Stop must never block a turn.
  process.exit(0);
}
