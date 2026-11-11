#!/usr/bin/env node
/**
 * PostToolUse hook: clock context (feature 0000499, REQ-001, ADR-0319).
 *
 * Returns the local time as hh:mm in additionalContext after every tool call.
 * An agent then holds a fresh time and never needs to estimate one.
 *
 * RAVINTIO_REPLY_CLOCK (hh:mm) replaces the clock, as in check-reply-prefix.
 * A value that does not parse leaves the clock.
 *
 * Reads no input, no file, and no network. Always exits 0. The hook adds
 * context and blocks nothing (0000200 ADR-002).
 */

const given = /^([0-2][0-9]):([0-5][0-9])$/.exec(process.env.RAVINTIO_REPLY_CLOCK ?? "");
const pad = (n) => String(n).padStart(2, "0");
const now = new Date();
const time = given ? `${given[1]}:${given[2]}` : `${pad(now.getHours())}:${pad(now.getMinutes())}`;

process.stdout.write(
  JSON.stringify({
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: `Local time: ${time}`,
    },
  }) + "\n",
);
process.exit(0);
