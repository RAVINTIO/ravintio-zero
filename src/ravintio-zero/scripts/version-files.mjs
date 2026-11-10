#!/usr/bin/env node
/**
 * version-files.mjs: check or set the product version across the files in
 * ravintio-zero/version-files.txt (feature 0000378, REQ-001).
 *
 * Usage:
 *   node version-files.mjs check [--root dir] [--list file]
 *   node version-files.mjs set <version> [--root dir] [--list file]
 *
 * Exit codes:
 *   0  versions agree (check) or were written (set)
 *   1  versions differ, bad semver, unreadable file, or a path outside the root
 *
 * A file holds its version in YAML front matter or in a top-level `version:`
 * line. `set` also updates a table row such as "| Version | `0.57.0` |".
 * No packages and no shell strings.
 */

import { existsSync, readFileSync, realpathSync, writeFileSync } from "node:fs";
import { dirname, isAbsolute, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const SEMVER_RE = /^[0-9]+\.[0-9]+\.[0-9]+$/;
const VERSION_LINE_RE = /^(version:\s*)(["']?)([^"'\s#]*)\2(.*)$/;
const TABLE_ROW_RE = /^(\|\s*Version\s*\|\s*`)([^`]*)(`\s*\|.*)$/;
const DEFAULT_LIST = join(dirname(fileURLToPath(import.meta.url)), "..", "version-files.txt");

/**
 * Return [{ path, optional }] for every list line. A line that starts with "? " names an optional
 * file, which the scripts skip when it does not exist (0000420). The pack repo lists its source copy
 * `src/ravintio-zero/component.yml` this way, because a consumer repo has no `src/`.
 */
export function readEntries(listFile) {
  return readFileSync(listFile, "utf8")
    .split(/\r?\n/)
    .map((l) => l.replace(/#.*$/, "").trim())
    .filter(Boolean)
    .map((l) => (l.startsWith("? ") ? { path: l.slice(2).trim(), optional: true } : { path: l, optional: false }));
}

/** Return every listed path, optional or not. */
export function readList(listFile) {
  return readEntries(listFile).map((e) => e.path);
}

/** Return the listed paths that exist under root. Throws on a path outside the root. */
export function presentPaths(root, listFile) {
  return readEntries(listFile)
    .filter((e) => existsSync(resolveInRoot(root, e.path)))
    .map((e) => e.path);
}

/** The entries to read or write: every required one, and each optional one that exists. */
function liveEntries(root, listFile) {
  return readEntries(listFile)
    .map((e) => ({ ...e, abs: resolveInRoot(root, e.path) }))
    .filter((e) => !e.optional || existsSync(e.abs));
}

function insideRoot(root, p) {
  const rel = relative(root, p);
  return rel !== "" && !rel.startsWith("..") && !isAbsolute(rel);
}

/** Resolve a listed path under root. Throws when it escapes the root. */
export function resolveInRoot(root, rel) {
  const rootReal = realpathSync(resolve(root));
  const abs = resolve(rootReal, rel);
  if (!insideRoot(rootReal, abs)) throw new Error(`path outside the root: ${rel}`);
  if (existsSync(abs) && !insideRoot(rootReal, realpathSync(abs))) {
    throw new Error(`path outside the root: ${rel}`);
  }
  return abs;
}

/** Index range of the front matter body lines, or null. */
function frontMatterEnd(lines) {
  if (lines[0] !== "---") return null;
  for (let i = 1; i < lines.length; i++) if (lines[i] === "---") return i;
  return null;
}

/** Find the line index of the file's own version line, or -1. */
function versionLineIndex(lines) {
  const end = frontMatterEnd(lines);
  if (end !== null) {
    for (let i = 1; i < end; i++) if (VERSION_LINE_RE.test(lines[i])) return i;
  }
  for (let i = end === null ? 0 : end + 1; i < lines.length; i++) {
    if (VERSION_LINE_RE.test(lines[i])) return i;
  }
  return -1;
}

/** Return [{ path, version }] for every listed file. Throws on a bad path or file. */
export function readVersions({ root = process.cwd(), list = DEFAULT_LIST } = {}) {
  return liveEntries(root, list).map(({ path, abs }) => {
    if (!existsSync(abs)) throw new Error(`file not found: ${path}`);
    const lines = readFileSync(abs, "utf8").split(/\r?\n/);
    const i = versionLineIndex(lines);
    if (i < 0) throw new Error(`no version in ${path}`);
    return { path, version: lines[i].match(VERSION_LINE_RE)[3] };
  });
}

/** Write version into every listed file. Validates everything before writing. */
export function setVersions(version, { root = process.cwd(), list = DEFAULT_LIST } = {}) {
  if (!SEMVER_RE.test(version)) throw new Error(`not MAJOR.MINOR.PATCH: ${version}`);
  const edits = liveEntries(root, list).map(({ path, abs }) => {
    if (!existsSync(abs)) throw new Error(`file not found: ${path}`);
    const lines = readFileSync(abs, "utf8").split("\n");
    const i = versionLineIndex(lines);
    if (i < 0) throw new Error(`no version in ${path}`);
    const quoted = /^version:\s*["']/.test(lines[i]);
    const m = lines[i].replace(/\r$/, "").match(VERSION_LINE_RE);
    const cr = lines[i].endsWith("\r") ? "\r" : "";
    const q = quoted ? m[2] : "";
    lines[i] = `${m[1]}${q}${version}${q}${m[4]}${cr}`;
    for (let j = 0; j < lines.length; j++) {
      lines[j] = lines[j].replace(TABLE_ROW_RE, `$1${version}$3`);
    }
    return { abs, path, text: lines.join("\n") };
  });
  for (const e of edits) writeFileSync(e.abs, e.text);
  return edits.map((e) => e.path);
}

function parseArgs(argv) {
  const out = { cmd: argv[0], positional: [], root: process.cwd(), list: DEFAULT_LIST };
  for (let i = 1; i < argv.length; i++) {
    if (argv[i] === "--root") out.root = argv[++i];
    else if (argv[i] === "--list") out.list = argv[++i];
    else out.positional.push(argv[i]);
  }
  return out;
}

function main(argv) {
  const a = parseArgs(argv);
  try {
    if (a.cmd === "check") {
      const rows = readVersions({ root: a.root, list: a.list });
      const first = rows[0]?.version;
      const differ = rows.filter((r) => r.version !== first);
      if (differ.length === 0) { console.log(`ok: ${first}`); return 0; }
      console.error(`version mismatch (${rows[0].path} holds ${first}):`);
      for (const r of differ) console.error(`  ${r.path} holds ${r.version}`);
      return 1;
    }
    if (a.cmd === "set") {
      const paths = setVersions(a.positional[0] ?? "", { root: a.root, list: a.list });
      console.log(`set ${a.positional[0]} in ${paths.length} files`);
      return 0;
    }
    console.error("usage: version-files.mjs check|set <version> [--root dir] [--list file]");
    return 1;
  } catch (e) {
    console.error(`version-files: ${e.message}`);
    return 1;
  }
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  process.exit(main(process.argv.slice(2)));
}
