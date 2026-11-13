// Reads the approved setup command from an initiative chart (0000448 REQ-001, ADR-0310).
//
// Exports findSetupCommand(text). It reads the "## Decisions" table, takes each row whose Fork
// starts with "Confirmation: setup", and takes the first code span of the answer cell as the
// command. It returns { file, args } only if every such row names the same command and the
// command is the pack setup.sh path followed by plain words and --flag words. Otherwise it
// returns null. It runs nothing and invokes no shell. No packages.

const FILE = /^(?:src\/)?ravintio-zero\/setup\.sh$/;
const WORD = /^(?:--[a-z][a-z0-9-]*|[a-z][a-z0-9-]*)$/;
const FORK = /^Confirmation: setup\b/;

// Returns the cells of a table row, or null if the line is not a row.
function cells(line) {
  const t = line.trim();
  if (!t.startsWith('|') || !t.endsWith('|')) return null;
  return t.slice(1, -1).split('|').map((c) => c.trim());
}

// Returns the section body under "## Decisions", up to the next level-2 heading.
function decisions(text) {
  const lines = String(text).split(/\r?\n/);
  const start = lines.findIndex((l) => /^## Decisions\s*$/.test(l));
  if (start < 0) return [];
  const body = [];
  for (const l of lines.slice(start + 1)) {
    if (/^## /.test(l)) break;
    body.push(l);
  }
  return body;
}

// Splits one command string into { file, args }, or returns null if it has any other form.
function parse(command) {
  const parts = command.split(' ');
  if (parts.some((p) => p === '')) return null;
  const [file, ...args] = parts;
  if (!FILE.test(file) || !args.every((a) => WORD.test(a))) return null;
  return { file, args };
}

export function findSetupCommand(text) {
  const found = [];
  for (const line of decisions(text)) {
    const c = cells(line);
    if (!c || c.length < 3 || !FORK.test(c[1].replace(/`/g, ''))) continue;
    const span = c[2].match(/`([^`]*)`/);
    if (!span) return null;
    const command = parse(span[1]);
    if (!command) return null;
    found.push(command);
  }
  if (found.length === 0) return null;
  const key = (x) => JSON.stringify(x);
  return found.every((x) => key(x) === key(found[0])) ? found[0] : null;
}
