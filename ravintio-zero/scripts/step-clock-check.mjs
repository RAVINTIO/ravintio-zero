#!/usr/bin/env node
// Checks that a step session received the clock (0000534 ADR-0342).
//
// Usage: node step-clock-check.mjs <step-log>
//
// The step log holds one stream-json event per line. The driver starts each step with
// --include-hook-events, so the log holds a hook_response event for each hook that ran.
// The clock hook (clock-context.mjs) answers a PostToolUse event with "Local time: hh:mm".
//   clock output   a system event with subtype hook_response, hook_event PostToolUse, and an
//                  output that holds "Local time: hh:mm"
//   tool call      a tool_use item in an assistant event
// The script exits 1 if the log holds tool calls and no clock output. It exits 0 if the log
// holds clock output, or holds no tool calls. It exits 2 with one stderr line for a missing
// argument or a log it cannot read. It reads one file, writes none, and prints counts only.

import { readFileSync } from 'node:fs';

const CLOCK = /Local time: [0-2][0-9]:[0-5][0-9]/;

const logPath = process.argv[2];
if (!logPath || process.argv.length > 3) {
  process.stderr.write('Usage: node step-clock-check.mjs <step-log>\n');
  process.exit(2);
}

let text;
try {
  text = readFileSync(logPath, 'utf8');
} catch {
  process.stderr.write(`step-clock-check: cannot read ${logPath}\n`);
  process.exit(2);
}

let toolCalls = 0;
let clockOutputs = 0;
for (const line of text.split('\n')) {
  if (line.trim() === '') continue;
  let event;
  try {
    event = JSON.parse(line);
  } catch {
    continue;
  }
  if (!event || typeof event !== 'object') continue;
  if (event.type === 'assistant' && Array.isArray(event.message?.content)) {
    toolCalls += event.message.content.filter((item) => item && item.type === 'tool_use').length;
  } else if (
    event.type === 'system' &&
    event.subtype === 'hook_response' &&
    event.hook_event === 'PostToolUse' &&
    typeof event.output === 'string' &&
    CLOCK.test(event.output)
  ) {
    clockOutputs += 1;
  }
}

if (toolCalls === 0) {
  process.stdout.write(`step-clock-check: ${logPath} holds no tool calls, so there is nothing to check.\n`);
  process.exit(0);
}
if (clockOutputs === 0) {
  process.stdout.write(`Blocked: ${logPath} holds ${toolCalls} tool calls and no clock output.\n`);
  process.exit(1);
}
process.stdout.write(`step-clock-check: ${logPath} holds ${toolCalls} tool calls and ${clockOutputs} clock outputs.\n`);
process.exit(0);
