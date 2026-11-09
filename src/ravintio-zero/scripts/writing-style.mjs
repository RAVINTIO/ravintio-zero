#!/usr/bin/env node
// writing-style.mjs - prints a tool's writing-standard output from
// standards/writing-standards.md (0000389 ADR-001).
//
// Usage: node writing-style.mjs <claude-code|codex> [standard-path] [--root dir]
//   Without standard-path, the standard resolves through resolve-override.mjs
//   (an override in ravintio-overrides/ wins). --root sets the consumer root.
//   claude-code  an output style file: frontmatter, then the style-rules region
//   codex        an AGENTS.md section: the summary region between markers
//
// Exit codes: 0 = printed, 1 = bad tool or a missing region.
import { readFileSync, realpathSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { resolveOverride } from "./resolve-override.mjs";

export const START = "<!-- ravintio-writing:start -->";
export const END = "<!-- ravintio-writing:end -->";
export const STYLE_NAME = "ravintio-writing";

export function region(text, name) {
  const norm = text.replace(/\r\n/g, "\n");
  const open = `<!-- BEGIN ${name} -->`;
  const close = `<!-- END ${name} -->`;
  const a = norm.indexOf(open);
  const b = norm.indexOf(close);
  if (a === -1 || b === -1 || b < a) throw new Error(`region ${name} not found`);
  const body = norm.slice(a + open.length, b).trim();
  if (!body) throw new Error(`region ${name} is empty`);
  return body;
}

export const PACK_POINTER = "ravintio-zero/standards/writing-standards.md";

export function generate(tool, standardText, pointer = PACK_POINTER) {
  if (tool === "claude-code") {
    return [
      "---",
      `name: ${STYLE_NAME}`,
      "description: Writes to the RAVINTIO writing standard, a British English variant of the Google developer documentation style",
      "keep-coding-instructions: true",
      "---",
      region(standardText, "style-rules"),
      "",
    ].join("\n");
  }
  if (tool === "codex") {
    return [
      START,
      "## Writing standard",
      "",
      region(standardText, "summary"),
      "",
      `Read \`${pointer}\` for the full rules.`,
      END,
      "",
    ].join("\n");
  }
  throw new Error(`unknown tool: ${tool}`);
}

// Compare real paths: a symlinked project path (macOS /var) differs from import.meta.url.
const isMain = (() => { try { return realpathSync(process.argv[1]) === realpathSync(fileURLToPath(import.meta.url)); } catch { return false; } })();
if (process.argv[1] && isMain) {
  const args = process.argv.slice(2);
  const pos = [];
  let root = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..");
  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--root") root = resolve(args[++i] ?? "");
    else pos.push(args[i]);
  }
  const tool = pos[0];
  let std = pos[1];
  let pointer = PACK_POINTER;
  if (!std) {
    const r = resolveOverride("standards", "writing-standards.md", { root });
    std = r.path;
    if (r.source === "override") pointer = "ravintio-overrides/standards/writing-standards.md";
  }
  try {
    process.stdout.write(generate(tool, readFileSync(std, "utf8"), pointer));
  } catch (err) {
    process.stderr.write(`writing-style: ${err.message}\n`);
    process.exit(1);
  }
}
