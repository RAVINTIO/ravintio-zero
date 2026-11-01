#!/usr/bin/env node
/**
 * Stop hook: reply prefix check (feature 0000200, REQ-003, ADR-002).
 *
 * Checks that the final reply in an active run starts with a valid phase or
 * stage prefix. A miss warns the human and adds one line to the miss log, so
 * the human can measure how often the rule fails.
 *
 * The final reply is payload.last_assistant_message when it is a string with
 * text. Otherwise the hook reads the transcript and takes the last assistant
 * message when it follows the last user prompt and has no tool_use block. If
 * it finds none, it rereads up to 4 times, waiting RAVINTIO_PREFIX_REREAD_MS
 * (default 250) between reads. If it still finds none, it exits silently.
 *
 * Valid prefixes: P0 Discovery:, P1 Plan:, P2 Implement:, P3 Validate:,
 * P4 Ship:, I-A Chart:, I-B Activate:, I-C Run:, I-D Advance:, I-E Delivery:,
 * and Supervise:. The phase name "Validate and Accept" is not valid.
 *
 * Receives: JSON on stdin (Claude Code Stop payload) with last_assistant_message
 * and transcript_path (a JSONL file). Transcript content may be a string or an
 * array of { type: "text", text } blocks. The hook checks the first non-empty
 * line of the reply.
 *
 * Outputs: JSON { systemMessage: "<string>" } on stdout for a miss, or
 * nothing otherwise. A miss also appends "<ISO timestamp> <first 80
 * characters of the reply>" to plan/.prefix-misses.log under payload.cwd
 * (else process.cwd()).
 *
 * Skips silently when plan/.orchestrator-active is absent.
 *
 * Always exits 0. The hook warns and never blocks a turn (ADR-002).
 */

import { appendFileSync, existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

import { readStdin } from "./read-stdin.mjs";

const VALID_PREFIXES = [
  "P0 Discovery:",
  "P1 Plan:",
  "P2 Implement:",
  "P3 Validate:",
  "P4 Ship:",
  "I-A Chart:",
  "I-B Activate:",
  "I-C Run:",
  "I-D Advance:",
  "I-E Delivery:",
  "Supervise:",
];

const LOG_SNIPPET_LENGTH = 80;

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

function parseLine(line) {
  if (!line.trim()) return null;
  try {
    return JSON.parse(line);
  } catch {
    return null;
  }
}

function isToolResultOnly(content) {
  return (
    Array.isArray(content) &&
    content.length > 0 &&
    content.every((b) => b && b.type === "tool_result")
  );
}

// Returns the text of the last assistant message when it follows the last
// user prompt and holds no tool_use block. Returns null otherwise.
function finalReplyText(transcript) {
  const lines = transcript.split("\n");
  for (let i = lines.length - 1; i >= 0; i--) {
    const entry = parseLine(lines[i]);
    if (!entry) continue;
    const message = entry.message ?? entry;
    const role = message?.role ?? entry.type;
    if (role === "user") {
      if (isToolResultOnly(message?.content)) continue;
      return null;
    }
    if (role !== "assistant") continue;
    const content = message?.content;
    if (Array.isArray(content) && content.some((b) => b && b.type === "tool_use")) return null;
    const text = textOf(content);
    return text.trim() ? text : null;
  }
  return null;
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function findFinalReply(transcriptPath) {
  const parsed = Number.parseInt(process.env.RAVINTIO_PREFIX_REREAD_MS ?? "", 10);
  const interval = Number.isFinite(parsed) && parsed >= 0 ? parsed : 250;
  for (let attempt = 0; attempt <= 4; attempt++) {
    if (attempt > 0) await sleep(interval);
    if (typeof transcriptPath !== "string" || !existsSync(transcriptPath)) continue;
    const reply = finalReplyText(readFileSync(transcriptPath, "utf-8"));
    if (reply !== null) return reply;
  }
  return null;
}

try {
  const raw = await readStdin();
  const input = JSON.parse(raw);
  const cwd = input?.cwd ?? process.cwd();

  if (!existsSync(join(cwd, "plan", ".orchestrator-active"))) process.exit(0);

  const given = input?.last_assistant_message;
  const reply =
    typeof given === "string" && given.trim() ? given : await findFinalReply(input?.transcript_path);
  if (reply === null) process.exit(0);

  const firstLine = reply.split("\n").find((l) => l.trim() !== "") ?? "";
  if (VALID_PREFIXES.some((p) => firstLine.trimStart().startsWith(p))) process.exit(0);

  const snippet = reply.trim().replace(/\s+/g, " ").slice(0, LOG_SNIPPET_LENGTH);
  try {
    // Keep the log out of git. Add it to .git/info/exclude once.
    const excludePath = join(cwd, ".git", "info", "exclude");
    if (existsSync(join(cwd, ".git", "info"))) {
      const held = existsSync(excludePath) ? readFileSync(excludePath, "utf-8") : "";
      if (!held.split("\n").includes("plan/.prefix-misses.log")) {
        appendFileSync(excludePath, (held === "" || held.endsWith("\n") ? "" : "\n") + "plan/.prefix-misses.log\n");
      }
    }
    appendFileSync(
      join(cwd, "plan", ".prefix-misses.log"),
      `${new Date().toISOString()} ${snippet}\n`,
    );
  } catch {
    // A log failure must not stop the warning.
  }

  const systemMessage =
    "[RAVINTIO] Reply is missing a valid prefix. Start every reply in an active run with " +
    "one of: " + VALID_PREFIXES.join(" ") + " The miss is logged to plan/.prefix-misses.log.";
  process.stdout.write(JSON.stringify({ systemMessage }));
  process.exit(0);
} catch {
  // Stop must never block a turn. Silent fallback (ADR-002).
  process.exit(0);
}
