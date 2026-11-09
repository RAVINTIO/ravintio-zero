/**
 * Prose rules shared by scripts/prose-check.mjs and check-reply-writing.mjs
 * (feature 0000390, ADR-0285).
 *
 * The module has no dependencies and no side effects. It reads text and
 * returns breaches of the writing standard (standards/writing-standards.md).
 *
 * Rule ids: sentence-length, blocklist, semicolon, em-dash, passive.
 *
 * The extractor skips front matter, fenced code, inline code, tables, HTML
 * comments, and link targets. A heading, a list item, and a paragraph each
 * start a new block, and a block splits into sentences.
 */

export const MAX_WORDS = 25;
export const RULES = ["sentence-length", "blocklist", "semicolon", "em-dash", "passive"];

const BLOCKLIST = [
  "simple", "simply", "easy", "just", "obviously",
  "honest", "frankly", "candidly", "to be fair",
  "load-bearing", "the crux", "the linchpin",
  "that's not nothing", "that's on me",
  "whitelist", "blacklist", "slave",
  "sanity check", "crazy", "insane", "dumb", "lame", "blind to", "cripple", "crippled",
  "man-hours", "mankind", "literally", "please note", "as you can see",
  "utilise", "utilize", "leverage", "facilitate", "in order to", "prior to", "additionally",
];

const BLOCKLIST_RE = new RegExp(
  `(?<![\\w-])(${BLOCKLIST.map((w) => w.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&").replace(/ /g, "\\s+")).join("|")})(?![\\w-])`,
  "gi",
);

const IRREGULAR = new Set([
  "done", "made", "written", "given", "shown", "taken", "kept", "built", "set", "put", "cut",
  "read", "left", "held", "sent", "found", "seen", "known", "chosen", "broken", "run", "begun",
  "spoken", "driven", "hidden", "paid", "told", "sold", "lost", "meant", "thrown", "drawn",
  "grown", "worn", "torn", "caught", "led", "laid", "spent", "shut",
]);
const NOT_PARTICIPLES = new Set([
  "indeed", "need", "feed", "seed", "speed", "proceed", "exceed", "succeed", "embed",
  "bleed", "breed", "hundred", "naked", "sacred", "wicked", "kindred",
]);
const PASSIVE_RE = /(?<![\w-])(?:is|are|was|were)\s+(?:not\s+)?(?:[a-z]+ly\s+)?([a-z]+)(?![\w-])/gi;

const ABBREVIATIONS = new Set(["e.g", "i.e", "etc", "vs", "cf", "approx", "fig", "eg", "ie"]);

// Turns one Markdown line into plain words. Inline code becomes CODE.
function cleanInline(line) {
  return line
    .replace(/<!--.*?-->/g, " ")
    .replace(/(`{1,3})(?:(?!\1).)+?\1/g, "CODE")
    .replace(/!\[[^\]]*\]\([^)]*\)/g, " ")
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/\[([^\]]*)\]\[[^\]]*\]/g, "$1")
    .replace(/<https?:[^>]*>/g, "URL")
    .replace(/https?:\/\/\S+/g, "URL")
    .replace(/&#?\w+;/g, " ")
    .replace(/\*+|__/g, "");
}

const FENCE_RE = /^\s*(`{3,}|~{3,})/;
const LIST_RE = /^\s*(?:[-*+]|\d+[.)])\s+(?:\[[ xX]\]\s+)?/;

/**
 * Splits Markdown into blocks of cleaned text. Each block holds the text and
 * a list of { offset, line } marks so a sentence maps back to a line.
 */
export function blocksOf(markdown, { frontMatter = true } = {}) {
  const lines = markdown.replace(/\r\n/g, "\n").split("\n");
  const blocks = [];
  let current = null;
  let fence = null;
  let comment = false;
  let start = 0;

  const flush = () => {
    if (current && current.text.trim()) blocks.push(current);
    current = null;
  };
  const add = (text, lineNo) => {
    if (!current) current = { text: "", marks: [] };
    if (current.text) current.text += " ";
    current.marks.push({ offset: current.text.length, line: lineNo });
    current.text += text;
  };

  if (frontMatter && lines[0] === "---") {
    const end = lines.indexOf("---", 1);
    if (end > 0) start = end + 1;
  }

  for (let i = start; i < lines.length; i++) {
    const raw = lines[i];
    const lineNo = i + 1;

    if (fence) {
      const m = raw.match(FENCE_RE);
      if (m && m[1][0] === fence[0] && m[1].length >= fence.length) fence = null;
      continue;
    }
    const f = raw.match(FENCE_RE);
    if (f) {
      flush();
      fence = f[1];
      continue;
    }
    if (comment) {
      if (raw.includes("-->")) comment = false;
      continue;
    }
    if (/^\s*<!--/.test(raw) && !raw.includes("-->")) {
      flush();
      comment = true;
      continue;
    }

    if (!raw.trim()) { flush(); continue; }
    if (/^\s*\|/.test(raw)) { flush(); continue; }
    if (/^\s*(?:-{3,}|\*{3,}|_{3,})\s*$/.test(raw)) { flush(); continue; }
    if (/^\s*\[[^\]]+\]:\s/.test(raw)) { flush(); continue; }
    if (/^\s*<[^>]+>\s*$/.test(raw)) { flush(); continue; }

    let body = raw;
    if (/^\s*#{1,6}\s/.test(body)) {
      flush();
      body = body.replace(/^\s*#{1,6}\s+/, "");
      add(cleanInline(body).trim(), lineNo);
      flush();
      continue;
    }
    const quote = body.match(/^\s*(?:>\s?)+/);
    if (quote) body = body.slice(quote[0].length);
    if (LIST_RE.test(body)) {
      flush();
      body = body.replace(LIST_RE, "");
    }
    const text = cleanInline(body).trim();
    if (text) add(text, lineNo);
  }
  flush();
  return blocks;
}

function lineAt(block, offset) {
  let line = block.marks[0].line;
  for (const mark of block.marks) {
    if (mark.offset <= offset) line = mark.line;
    else break;
  }
  return line;
}

/** Splits a block into sentences. Returns { text, offset } pairs. */
export function sentencesOf(block) {
  const text = block.text;
  const out = [];
  let from = 0;
  const re = /[.!?]+(?=\s|$)/g;
  let m;
  while ((m = re.exec(text)) !== null) {
    const end = m.index + m[0].length;
    const rest = text.slice(end).trimStart();
    if (rest && /^[a-z]/.test(rest)) continue;
    const token = text.slice(from, m.index).split(/\s+/).pop().toLowerCase();
    if (ABBREVIATIONS.has(token)) continue;
    out.push({ text: text.slice(from, end).trim(), offset: from + (text.slice(from, end).length - text.slice(from, end).trimStart().length) });
    from = end;
  }
  const tail = text.slice(from);
  if (tail.trim()) out.push({ text: tail.trim(), offset: from + (tail.length - tail.trimStart().length) });
  return out;
}

export function wordCount(sentence) {
  return sentence.split(/\s+/).filter((w) => /[\p{L}\p{N}]/u.test(w)).length;
}

function isParticiple(word) {
  const w = word.toLowerCase();
  if (NOT_PARTICIPLES.has(w)) return false;
  return IRREGULAR.has(w) || /^[a-z]{3,}ed$/.test(w);
}

/** Finds breaches in one sentence. Returns { rule, detail } pairs. */
export function sentenceBreaches(sentence) {
  const found = [];
  const words = wordCount(sentence);
  if (words > MAX_WORDS) found.push({ rule: "sentence-length", detail: `${words} words` });
  if (sentence.includes("\u2014")) found.push({ rule: "em-dash", detail: "em dash" });
  if (sentence.includes(";")) found.push({ rule: "semicolon", detail: "semicolon" });
  for (const m of sentence.matchAll(BLOCKLIST_RE)) {
    found.push({ rule: "blocklist", detail: `"${m[1].toLowerCase().replace(/\s+/g, " ")}"` });
  }
  for (const m of sentence.matchAll(PASSIVE_RE)) {
    if (isParticiple(m[1])) found.push({ rule: "passive", detail: `"${m[0].replace(/\s+/g, " ")}"` });
  }
  return found;
}

/**
 * Checks Markdown text. Returns breaches as { line, rule, detail, sentence }.
 * An em dash or semicolon outside a sentence cannot occur, because every
 * block splits into sentences.
 */
export function checkText(markdown, options = {}) {
  const breaches = [];
  for (const block of blocksOf(markdown, options)) {
    for (const s of sentencesOf(block)) {
      const line = lineAt(block, s.offset);
      for (const b of sentenceBreaches(s.text)) {
        breaches.push({ line, rule: b.rule, detail: b.detail, sentence: s.text });
      }
    }
  }
  return breaches;
}

const TRAILER_RE =
  /^(?:Signed-off-by|Co-authored-by|Reviewed-by|Acked-by|Tested-by|Reported-by|Cc|Fixes|Closes|Refs|Resolves|Release-Note|BREAKING CHANGE):/i;

/**
 * Checks a commit message. Comment lines (starting with #) and trailer lines
 * are skipped. The subject is one block. The body reads as Markdown.
 */
export function checkMessage(message) {
  const lines = message.replace(/\r\n/g, "\n").split("\n").filter((l) => !l.startsWith("#"));
  const subject = lines[0] ?? "";
  const breaches = [];
  const subjectBlock = { text: cleanInline(subject).trim(), marks: [{ offset: 0, line: 1 }] };
  if (subjectBlock.text) {
    for (const b of sentenceBreaches(subjectBlock.text)) {
      breaches.push({ line: 1, rule: b.rule, detail: b.detail, sentence: subjectBlock.text });
    }
  }
  const body = lines.slice(1).filter((l) => !TRAILER_RE.test(l.trim())).join("\n");
  for (const b of checkText(body, { frontMatter: false })) {
    breaches.push({ ...b, line: b.line + 1 });
  }
  return breaches;
}
