#!/usr/bin/env node
/**
 * PreToolUse hook: plan compliance write gate.
 *
 * Gates this project only (0000164 ADR-002). A target whose real path lies outside
 * the project's real root passes with exit 0 before any check. Symlinks resolve first,
 * so a link inside the project that points outside counts as outside.
 *
 * Enforces these checks on in-project targets before allowing a Write or Edit (ADR-004):
 *   0. plan/current/** needs the plan/.orchestrator-active sentinel (REQ-007, ADR-003)
 *   1. Always-permitted paths (plan/, docs/, CLAUDE.md, AGENTS.md) → pass.
 *      plan/backlog/ and plan/roadmap/ fall under plan/, so they pass between runs
 *      with no sentinel and no design.md.
 *   2. design.md must exist → block with exit 2 if absent
 *   3. Target path must match a component path prefix in design.md → block if not
 *
 * Bash calls (0000393 ADR-001): the same checks run on each write target found in
 * tool_input.command. A character tokenizer finds redirects (> >> >| &> &>>),
 * `tee` arguments, and `sed -i` file arguments. It tracks quotes, backslashes and
 * heredoc bodies. Limits: a target built from a variable, backtick or $(...) passes
 * because its value is unknown. cp, mv, dd, and writes made by scripts are not read.
 *
 * Receives: JSON on stdin conforming to the RAVINTIO common envelope (ADR-002)
 * or the raw Claude Code PreToolUse hook input.
 *
 * Exit codes: 0 = pass, 2 = block (DD-004, ADR-005)
 * Silent on unexpected errors — always exit 0 on non-enforcement failures (ADR-005).
 */

import { existsSync, readFileSync, realpathSync } from "node:fs";
import { basename, dirname, join, normalize, resolve } from "node:path";

import { readStdin } from "./read-stdin.mjs";

// Always-permitted: planning/doc artefacts and RAVINTIO internal files
// plan/backlog/ and plan/roadmap/ sit under plan/ (0000164 REQ-002)
const ALWAYS_PERMITTED_PREFIXES = ["plan/", "plan\\", "docs/", "docs\\"];
const ALWAYS_PERMITTED_FILES = [
  "claude.md", "agents.md", ".ravintio-session", ".skips", ".feature-id",
  ".gitignore", ".gitattributes", ".claudeignore",
  "pause.md",
];

// Headings that introduce the component paths list in design.md (ADR-004)
const PATHS_SECTION_RE = /^##\s+(Component Paths|Scope)\s*$/im;

function norm(p) {
  return normalize(p).normalize("NFC").replace(/\\/g, "/").toLowerCase();
}

// Real path of p. If p does not exist yet, resolve the nearest existing parent
// and rejoin the remaining segments (0000164 REQ-001, ADR-002).
function realPathOrParent(p) {
  const rest = [];
  let cur = resolve(p);
  for (;;) {
    try {
      return rest.length ? join(realpathSync(cur), ...rest) : realpathSync(cur);
    } catch {
      const parent = dirname(cur);
      if (parent === cur) return resolve(p);
      rest.unshift(basename(cur));
      cur = parent;
    }
  }
}

function isAlwaysPermitted(relPath) {
  const n = norm(relPath);
  const base = n.split("/").pop() ?? "";
  if (ALWAYS_PERMITTED_FILES.includes(base)) return true;
  return ALWAYS_PERMITTED_PREFIXES.some((prefix) => n.startsWith(norm(prefix)));
}

function extractComponentPaths(content) {
  const match = PATHS_SECTION_RE.exec(content);
  if (!match) return null;

  const afterHeading = content.slice(match.index + match[0].length);
  const lines = afterHeading.split("\n");
  const paths = [];

  for (const line of lines) {
    if (/^##\s/.test(line)) break; // stop at next h2
    // Match: "- path", "* path", "- `path`", "| path |" table rows
    const m = line.match(/^[\s*\-|]+`?([^\s`|,{}]+)`?/);
    if (m?.[1] && !m[1].startsWith("{") && m[1].includes("/")) {
      paths.push(m[1].replace(/\/$/, "")); // strip trailing slash for normalised comparison
    }
  }

  return paths.length ? paths : null;
}

function matchesComponentPath(relPath, componentPaths) {
  const normTarget = norm(relPath);
  return componentPaths.some((cp) => {
    const normCp = norm(cp);
    // prefix match: target starts with component path (with separator)
    return normTarget === normCp || normTarget.startsWith(normCp + "/");
  });
}

// Claude Code shows the agent only stderr on exit 2. Stdout keeps the tests' view.
function block(message) {
  message = message.replace(/\n$/, "") + " See ravintio-zero/standards/hook-enforcement.md.\n";
  process.stderr.write(message);
  process.stdout.write(message);
  process.exit(2);
}


const OPERATOR_CHARS = new Set([";", "|", "&", "\n", "(", ")"]);

// A word with an expansion has an unknown value, so it is never a target.
function isDigits(t) {
  return t.length > 0 && /^[0-9]+$/.test(t);
}

// Split a shell command into simple commands. Each holds words and redirect targets.
// Words are {text, unknown}. This is a tokenizer, not a full shell parser (0000393 ADR-001).
function parseShell(src) {
  const commands = [];
  let words = [];
  let targets = [];
  let cur = null; // {text, unknown, quoted}
  let pending = null; // "out" | "dup" | "in" while the next word is a redirect operand
  const heredocs = []; // delimiters waiting for the next newline

  const endWord = () => {
    if (!cur) return;
    const w = cur;
    cur = null;
    if (pending === "out") {
      targets.push(w);
    } else if (pending === "dup" && (isDigits(w.text) || w.text === "-")) {
      // fd duplication such as >&2 or >&- writes no file
    } else if (pending === "dup") {
      targets.push(w);
    } else if (pending === "in") {
      // input redirect operand, not a write target
    } else {
      words.push(w);
    }
    pending = null;
  };
  const endCommand = () => {
    endWord();
    pending = null;
    if (words.length || targets.length) commands.push({ words, targets });
    words = [];
    targets = [];
  };
  const start = () => (cur ??= { text: "", unknown: false, quoted: false });

  const n = src.length;
  let i = 0;
  while (i < n) {
    const c = src[i];
    if (c === "\\") {
      if (src[i + 1] === "\n") { i += 2; continue; }
      start().text += src[i + 1] ?? "";
      i += 2;
      continue;
    }
    if (c === "'") {
      const end = src.indexOf("'", i + 1);
      const w = start();
      w.quoted = true;
      if (end === -1) { w.text += src.slice(i + 1); i = n; break; }
      w.text += src.slice(i + 1, end);
      i = end + 1;
      continue;
    }
    if (c === '"') {
      const w = start();
      w.quoted = true;
      i++;
      while (i < n && src[i] !== '"') {
        const d = src[i];
        if (d === "\\" && i + 1 < n) {
          if ('$`"\\'.includes(src[i + 1])) { w.text += src[i + 1]; i += 2; continue; }
          if (src[i + 1] === "\n") { i += 2; continue; }
        }
        if (d === "$" || d === "`") w.unknown = true;
        w.text += d;
        i++;
      }
      i++; // closing quote
      continue;
    }
    if (c === "$" || c === "`") {
      start().unknown = true;
      cur.text += c;
      i++;
      continue;
    }
    if (c === "#" && !cur) {
      while (i < n && src[i] !== "\n") i++;
      continue;
    }
    if (c === " " || c === "\t" || c === "\r") {
      endWord();
      i++;
      continue;
    }
    if (c === ">" || (c === "&" && src[i + 1] === ">")) {
      // Drop a digit-only fd prefix such as the 2 in 2>file.
      if (cur && !cur.quoted && !cur.unknown && isDigits(cur.text)) cur = null;
      else endWord();
      if (c === "&") i++;
      i++; // the >
      if (src[i] === ">" || (src[i] === "|" && c === ">")) i++;
      if (c === ">" && src[i] === "&") { i++; pending = "dup"; }
      else pending = "out";
      continue;
    }
    if (c === "<") {
      endWord();
      if (src.startsWith("<<<", i)) { i += 3; pending = "in"; continue; }
      if (src.startsWith("<<", i)) {
        i += 2;
        let strip = false;
        if (src[i] === "-") { strip = true; i++; }
        while (src[i] === " " || src[i] === "\t") i++;
        let delim = "";
        while (i < n && !/[\s;|&<>()]/.test(src[i])) {
          if (src[i] === "'" || src[i] === '"' || src[i] === "\\") { i++; continue; }
          delim += src[i++];
        }
        heredocs.push({ delim, strip });
        continue;
      }
      i++;
      pending = "in";
      continue;
    }
    if (OPERATOR_CHARS.has(c)) {
      endCommand();
      if ((c === "&" || c === "|") && src[i + 1] === c) i++;
      else if (c === "|" && src[i + 1] === "&") i++;
      i++;
      if (c === "\n" && heredocs.length) {
        // Skip each heredoc body up to its delimiter line (0000393 ADR-001).
        for (const h of heredocs) {
          for (;;) {
            if (i >= n) break;
            let e = src.indexOf("\n", i);
            if (e === -1) e = n;
            let line = src.slice(i, e).replace(/\r$/, "");
            if (h.strip) line = line.replace(/^\t+/, "");
            i = e + 1;
            if (line === h.delim) break;
          }
        }
        heredocs.length = 0;
      }
      continue;
    }
    start().text += c;
    i++;
  }
  endCommand();
  return commands;
}

// Collect the sed file arguments when the command edits in place, else [].
function sedFiles(args) {
  let inPlace = false;
  let hasScript = false;
  const operands = [];
  let afterDashes = false;
  for (let k = 0; k < args.length; k++) {
    const a = args[k];
    if (afterDashes || !a.text.startsWith("-") || a.text === "-") { operands.push(a); continue; }
    if (a.text === "--") { afterDashes = true; continue; }
    if (a.text.startsWith("--")) {
      if (a.text === "--in-place" || a.text.startsWith("--in-place=")) inPlace = true;
      else if (a.text === "--expression" || a.text === "--file") { hasScript = true; k++; }
      else if (a.text.startsWith("--expression=") || a.text.startsWith("--file=")) hasScript = true;
      continue;
    }
    for (let m = 1; m < a.text.length; m++) {
      const ch = a.text[m];
      if (ch === "i") {
        inPlace = true;
        if (a.text === "-i" && args[k + 1] && args[k + 1].text === "" && !args[k + 1].unknown) k++;
        break;
      }
      if (ch === "e" || ch === "f") {
        hasScript = true;
        if (m === a.text.length - 1) k++;
        break;
      }
    }
  }
  if (!inPlace) return [];
  return hasScript ? operands : operands.slice(1);
}

// Write targets of one Bash command string (0000393 ADR-001).
function shellTargets(command) {
  const out = [];
  for (const cmd of parseShell(command)) {
    for (const t of cmd.targets) out.push(t);
    let idx = 0;
    while (idx < cmd.words.length && /^[A-Za-z_][A-Za-z0-9_]*=/.test(cmd.words[idx].text)) idx++;
    const word = cmd.words[idx];
    if (!word) continue;
    const name = basename(word.text);
    const args = cmd.words.slice(idx + 1);
    if (name === "tee") {
      for (const a of args) if (!a.text.startsWith("-") || a.text === "-") out.push(a);
    } else if (name === "sed") {
      for (const a of sedFiles(args)) out.push(a);
    }
  }
  return out.filter((t) => !t.unknown && t.text !== "" && t.text !== "-");
}


// Evaluate one raw target: block with exit 2, or return to let it pass.
function checkTarget(cwd, rawTarget) {
  // Resolve to a path relative to cwd for prefix matching.
  // Normalise both paths to forward-slash form before comparison to avoid
  // mixed-separator failures on Windows (ADR-005, REQ-012).
  // Both sides resolve through realpath so symlinks and /tmp aliases compare true
  // (0000164 REQ-001, REQ-006, ADR-002).
  const absTarget = realPathOrParent(resolve(cwd, rawTarget));
  const normCwd = norm(realPathOrParent(cwd));
  const normAbs = norm(absTarget);
  const cwdPrefix = normCwd.endsWith("/") ? normCwd : normCwd + "/";

  // Outside the project's real root → not this hook's business (ADR-002).
  if (normAbs !== normCwd && !normAbs.startsWith(cwdPrefix)) return;

  const relTarget = normAbs === normCwd ? "" : normAbs.slice(cwdPrefix.length);

  // Check 0 — sentinel enforcement for plan/current/** (REQ-007, ADR-003)
  // feature-brief.md and ALWAYS_PERMITTED_FILES (e.g. pause.md) bypass sentinel so
  // P0 can begin and pause/resume works at any pipeline phase.
  const normRel = norm(relTarget);
  const isPlanCurrent = normRel.startsWith("plan/current/") || normRel === "plan/current";
  const isFeatureBrief = normRel.endsWith("feature-brief.md");
  const isAlwaysPermittedBasename = ALWAYS_PERMITTED_FILES.includes(basename(relTarget));
  if (isPlanCurrent && !isFeatureBrief && !isAlwaysPermittedBasename) {
    const sentinelPath = join(cwd, "plan", ".orchestrator-active");
    if (!existsSync(sentinelPath)) {
      block(
        "[RAVINTIO] No orchestrator sentinel at plan/.orchestrator-active. " +
        "Load the ravintio-orchestrator skill and complete P0 Discovery before " +
        "writing plan artefacts.\n"
      );
    }
  }

  // Check 1 — always-permitted paths (ADR-004)
  if (isAlwaysPermitted(relTarget)) return;

  // Check 2 — design.md must exist
  const designPath = join(cwd, "plan", "current", "design.md");
  if (!existsSync(designPath)) {
    block(
      "[RAVINTIO] No confirmed design at plan/current/design.md. " +
      "Complete P0 Discovery first.\n"
    );
  }

  // Check 3 — path must be in component paths list
  let designContent;
  try {
    designContent = readFileSync(designPath, "utf-8");
  } catch {
    return; // Can't read design → pass through (ADR-005)
  }

  const componentPaths = extractComponentPaths(designContent);
  if (!componentPaths) {
    // Section missing or unparseable → warn but pass through (ADR-005, R-006)
    process.stderr.write(
      "[RAVINTIO] Warning: Could not parse component paths from " +
      "plan/current/design.md. Ensure a '## Component Paths' section exists. " +
      "Write allowed.\n"
    );
    return;
  }

  if (!matchesComponentPath(relTarget, componentPaths)) {
    block(
      `[RAVINTIO] Path '${relTarget}' is not covered by the confirmed design. ` +
      "Add it to the '## Component Paths' section of plan/current/design.md first.\n"
    );
  }
}

try {
  const raw = await readStdin();
  const input = JSON.parse(raw);

  // Support both common envelope (ADR-002) and raw Claude Code hook input
  const cwd = input?.cwd ?? process.cwd();
  const toolInput = input?.tool_input ?? input;
  const rawTarget = toolInput?.path ?? toolInput?.file_path ?? "";

  if (rawTarget) {
    checkTarget(cwd, rawTarget);
  } else if (
    (input?.tool_name === "Bash" || typeof toolInput?.command === "string") &&
    typeof toolInput?.command === "string"
  ) {
    for (const t of shellTargets(toolInput.command)) checkTarget(cwd, t.text);
  }
  // No target path = pass (not a file-writing tool call)
  process.exit(0);
} catch {
  // Never block the session on unexpected errors (ADR-005).
  process.exit(0);
}
