#!/usr/bin/env node
// initiative-run.mjs - runs each initiative step in a fresh claude -p session (0000043 ADR-004).
//
// Usage, run from the repository root:
//
//   node ravintio-zero/scripts/initiative-run.mjs [--root <dir>]
//
// Arguments:
//   --root   The working tree that holds plan/. Defaults to the current directory.
//
// Environment:
//   CLAUDE_BIN   The claude executable. Defaults to "claude", found through PATH.
//   RAVINTIO_INITIATIVE_MODEL
//                The model for every step, passed as --model. Defaults to "sonnet".
//                It must match ^[A-Za-z0-9][A-Za-z0-9._:\[\]-]{0,63}$.
//   RAVINTIO_INITIATIVE_MAX_TURNS
//                A turn cap for every step, passed as --max-turns. If unset or empty,
//                no cap applies and no default ships. It must be 1 to 9999. If claude
//                exits non-zero while a cap is set, the stop line names the cap.
//   RAVINTIO_ROADMAP_MODEL, RAVINTIO_ROADMAP_MAX_TURNS, PLANIFEST_ROADMAP_MODEL,
//   PLANIFEST_ROADMAP_MAX_TURNS
//                Old names. The driver no longer reads them. If one is set and non-empty,
//                the driver stops before it spawns a step and names the new variable.
//
// Labels: the child's OTEL_RESOURCE_ATTRIBUTES gets these labels appended, with each value
// percent-encoded by scripts/initiative-labels.mjs. The old value stays as it was.
//   work.kind=initiative
//   ravintio.initiative={id}-{slug}
//   ravintio.step={position}
// Only the child sees the change. The labels hold identifiers, never prompt or file text.
//
// Logs: each step writes the child's stdout and stderr, in arrival order, to
// plan/.initiative-logs/step-{position}.log. If that log already exists, the driver first
// renames it to step-{position}.attempt-{k}.log, with the lowest k whose path is free, and
// then opens a fresh step-{position}.log. A rerun keeps every earlier attempt, and the
// latest attempt keeps the plain name. A stop line that names a log also names the earlier
// attempts, as "Earlier: {paths}. Log: {path}". The driver copies the child's stderr to its own
// stderr and never prints the child's stdout or any log content. It excludes the folder
// through .git/info/exclude. The driver refuses a symlink at plan, at the log folder, or at
// the log file, and stops with "I-C Run: Blocked: refused a symlinked step log path". Logs
// are private to the user: the folder has mode 700 and each log mode 600. Every stop after a step starts ends with
// "Log: plan/.initiative-logs/step-{position}.log".
//
// What it does:
//   1. Reads plan/current-initiative/initiative.md and stops unless status is "active".
//   2. Takes plan/.initiative-runner.lock. If the lock exists, it refuses to start and leaves
//      the lock alone. The one exception is a lock that holds only a pid for a process that
//      no longer runs. The driver prints the pid, removes the lock, and takes it. A pid that
//      runs, text that is not a pid, and a symlink still refuse.
//   3. Runs `claude -p --output-format stream-json --verbose --permission-mode auto
//      --append-system-prompt "Write all prose to ravintio-zero/standards/writing-standards.md." --model {model} [--max-turns {n}]
//      "Run initiative step {position}"`
//      and waits. Each step starts a fresh session. The position goes to claude as one
//      argument, never through a shell. The driver never passes --continue. It passes --resume
//      only as step 3a describes.
//   3a. If claude exits 0, no block exists, and the position did not move, the step may have
//      ended its turn early (0000334). The driver reads the last session_id from the stream
//      events, checks it against ^[A-Za-z0-9_-]{8,128}$, and runs the same command with
//      "--resume {session}" and a continue prompt, up to two times. It prints "I-C Run:
//      Resuming: step {n} ended its turn unmerged, resume {k} of 2" before each. The resume
//      writes to the same step log. If the step is still unmerged after the second resume, it
//      prints "I-C Run: Blocked: step {n} exited without merging after 2 resumes" and exits 1.
//      With no valid session id it does not resume. A non-zero exit or a block never resumes.
//   4. After each step it stops if plan/current/build-log.md ends on a
//      "Blocked:" or "Question:" line with no later "Resolved:" line. A step that ends its
//      turn on a question is never resumed, so it cannot guess an answer (0000370). It runs the same check on
//      plan/_archive/{feature-id}-*/build-log.md, in the newest folder (by name) whose
//      name starts with the step's feature id and that changed after the step started.
//      Ship archives plan/current/ before CI, so a block can sit only in the archive. The
//      driver skips a symlinked archive folder or build log. The stop line is
//      "I-C Run: Blocked: step {n} stopped." plus the message.
//   5. It reads position and status after each step from the initiative branch ref, with
//      `git show {branch}:plan/current-initiative/initiative.md` (0000205 ADR-002). A step
//      that did not merge leaves the branch file unchanged, so the driver stops with
//      "I-C Run: Blocked: step {n} is not merged into the initiative branch, position
//      stayed at {n}". If the ref is unreadable or the root is not a git work tree, it
//      reads the working-tree file. The driver passes git its arguments as an array, with
//      no shell.
//   6. After a merged step it compares the initiative branch ref before and after the step.
//      If the step changed initiative-run.mjs, initiative-watch.mjs, or the initiative skill,
//      the running driver and its watcher hold old code. The driver prints
//      "I-D Advance: Restart: step {n} changed {files}. Start a new driver so step {next}
//      runs the new code.", releases the lock, and exits 1. The initiative skill starts a new
//      driver and watcher at once. If git or the ref is unreadable, the check is skipped.
//      The same comparison covers ravintio-zero/skills/, hooks/, setup.sh, and setup/. If the
//      step changed any of them, the installed copies are stale. The driver prints
//      "I-D Advance: Setup: step {n} changed {files}. Rerun setup, then start a new driver.",
//      releases the lock, and exits 1. If the step also changed a restart file, it prints one
//      line, "I-D Advance: Restart: Setup: step {n} changed {files}. Rerun setup, then start a
//      new driver so step {next} runs the new code." The files list restart files first, names
//      each once, and shows at most 5, then "and {k} more". After the last step the Setup
//      check also runs, before the Pending line, and a hit stops the driver with no Pending (0000373).
//      Before it stops on a Setup hit, the driver reads the setup "Confirmation:" row of the chart
//      with setup-command.mjs. If the row names the pack setup.sh with flag words, the driver runs
//      that command with bash and no shell, prints "I-D Advance: Setup: step {n} ran the approved
//      setup command", and carries on. A missing row, another form, a main tree it cannot bring to
//      the merged ref, or a non-zero exit keeps the stop (0000448). A Restart hit still stops.
//   7. It repeats until delivery: initiative.md is gone and
//      plan/_archive/{id}-{slug}-initiative-*/ exists. It then exits 0.
//      If every step in the "## Steps" table has merged but the archive is not there yet,
//      it prints "I-E Delivery: Pending: all {n} steps merged, initiative delivery runs
//      from the initiative skill" and exits 0 without starting another step.
//
// Child environment: each step session gets CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0, so
// background subagents keep running. A value in the parent environment, even another
// value, wins. Each step session also gets RAVINTIO_INITIATIVE_STEP=1, which the
// auto-trigger hook reads to load the orchestrator and not the initiative skill.
//
// Concurrent mode (0000379): the steps above describe the serial path. The driver takes it when the
// chart has no **Concurrency:** field, or holds an unfilled "{{...}}" placeholder there. With the
// field, the scheduler runs instead:
//   - It reads the chart from origin/{branch}, or the local branch when no origin ref exists. It
//     fetches the branch quietly before each read and before it cuts a worktree.
//   - It starts the steps that readySteps in initiative-chart.mjs returns, in chart order, until
//     the running count equals the cap. A ready step still holds its lane until it merges.
//   - Each step gets the worktree plan/.initiative-worktrees/step-{n} on branch feat/{feature-id},
//     cut from the initiative ref. The driver copies .claude, CLAUDE.md, AGENTS.md, and .codex from
//     the root into it, skipping symlinks. The session runs with its cwd in the worktree and gets
//     RAVINTIO_INITIATIVE_QUEUE=1, RAVINTIO_INITIATIVE_ROOT, and RAVINTIO_INITIATIVE_CONTROL.
//   - The control folder plan/.initiative-control/step-{n}/ holds "running", the driver pid, and
//     "ready", the PR number the step writes. A step succeeds when ready exists. The resume rule
//     applies when it does not. On a driver restart, ready queues the step with no new session.
//     If ready is empty or invalid, the driver looks up the one open PR for feat/{feature-id} with gh,
//     rewrites the file, and carries on. With no single PR it stops (0000442, ADR-0304).
//     A running file without ready restarts the session in the existing worktree.
//   - Before the queue removes a step worktree, the driver lists the untracked files under
//     plan/backlog/ in it. If it finds any, or git cannot list them, it keeps the worktree and stops
//     the queue for the step with a line that names up to five files. The ready file stays, so a new
//     driver queues the step again. The removal would delete untracked backlog entries (0000497).
//   - At start, the driver sweeps the worktree of each merged step in the chart. It removes the
//     worktree only when no live pid sits in the step's running file, "git status" lists no file,
//     and the head is on origin/feat/{feature-id} or that branch is gone. Otherwise it keeps the
//     worktree and prints "I-C Run: Kept: step {n} {reason}". A kept worktree never stops the run
//     (0000501, ADR-0326).
//   - The queue takes one ready step at a time, in ready order. It removes the step worktree and
//     runs "node {merge-queue.mjs} run --step {n} --pr {k} --root {queue worktree}". MERGE_QUEUE_BIN
//     overrides the script. The queue worktree is plan/.initiative-worktrees/queue, detached at the
//     initiative ref. Its output goes to the step log. A merge prints "I-D Advance: Complete: step
//     {n} merged" and deletes the control folder. The Restart and Setup checks then run.
//   - A block, a failed session, a queue failure, or a Restart or Setup hit stops new starts. It
//     prints "I-C Run: Stopping:". Running steps still reach ready or stop. The queue still merges
//     every other ready step, also after a queue failure (0000446). On a queue failure the driver
//     prints "I-D Advance: Blocked: queue stopped on step {n}" and the reason at once. It also
//     appends that line to the step log (0000450). The stop line at exit repeats it. A failed step gets one attempt,
//     keeps its ready file, and reads stopped. A new driver queues it again. Before exit 1 the driver prints "I-C Run: Step {n}: {state}"
//     for every step, then the first stop line with the log of the step that caused it.
//   - Handoff (0000493, ADR-0323): a merge that changed a watched file and no setup file is a
//     Restart-only hit. The driver fast-forwards the root to the merged ref and starts
//     "node initiative-run.mjs --root {root} --handoff {pid}" detached, with its own output handles.
//     It writes the successor pid into the lock, gives up the lock, and prints "I-D Advance:
//     Restart: step {n} changed {files}. A new driver took over new starts." It then starts no step
//     and runs no queue. It supervises its own sessions and exits 0 when they end. The successor
//     checks that the lock holds its pid, then reads the control folders. A ready file queues the
//     step. A running file that holds the old pid, while that pid lives, adopts the step: no second
//     session starts and the step counts against the cap. If the old pid dies, the step restarts in
//     its worktree. A handed-over step that blocks or fails gets a stopped file (one stop line, 500
//     characters at most) that stops new starts in the successor. A driver without --handoff
//     removes stale stopped files. A Setup hit, a failed spawn, and a failed fast-forward keep the
//     stop line.
//   - The driver refuses a symlink at plan, at either folder, or at a step entry in either. Worktrees
//     and control folders of unmerged steps stay on every exit.

// Final report: the driver keeps a list of the steps it ran. At delivery it prints one
// "I-E Delivery: Complete: step {n} merged" line per step, in order. The last line is
// "I-E Delivery: Complete: initiative {id}-{slug} archived, driver done".
//
// Exclusions: the driver adds the lock, the log folder, and plan/.initiative-queue/ to
// .git/info/exclude, so a step never commits the queue folder.
//
// Output: one line per stage, written and flushed at once so a parent session
// can stream it with Monitor. Lines start with "I-C Run:" or "I-D Advance:"
// and the final lines with "I-E Delivery:". A stop line names the reason and,
// for a block, repeats the Blocked: message cut to 500 characters.
//
// Exit codes:
//   0  Delivery is complete.
//   1  A stop: invalid or inactive initiative, existing lock, block, stalled
//      position, failed claude call, interruption, or a restart for a tooling change.
//
// The lock is released on every exit path, including SIGINT and SIGTERM.
// The driver never edits the working tree. The steps it launches do that.
// It has no dependencies beyond Node.

import { spawn, spawnSync } from 'node:child_process';
import { appendFileSync, chmodSync, closeSync, constants as fsConstants, cpSync, existsSync, lstatSync, mkdirSync, openSync, readFileSync, readdirSync, realpathSync, renameSync, rmSync, unlinkSync, writeFileSync, writeSync } from 'node:fs';
import { dirname, isAbsolute, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parseChart, readySteps } from './initiative-chart.mjs';
import { withInitiativeLabels } from './initiative-labels.mjs';
import { namedItems } from './initiative-queue.mjs';
import { findSetupCommand } from './setup-command.mjs';

const INITIATIVE = 'plan/current-initiative/initiative.md';
const LOCK = 'plan/.initiative-runner.lock';
const LOGS = 'plan/.initiative-logs';
const QUEUE = 'plan/.initiative-queue/';
const BUILD_LOG = 'plan/current/build-log.md';
const ARCHIVE = 'plan/_archive';
// Files whose change leaves the running driver, or the session that relays its output, on old code.
const WATCHED = [
  'ravintio-zero/scripts/initiative-run.mjs',
  'src/ravintio-zero/scripts/initiative-run.mjs',
  'ravintio-zero/scripts/initiative-watch.mjs',
  'src/ravintio-zero/scripts/initiative-watch.mjs',
  'ravintio-zero/skills/ravintio-initiative/SKILL.md',
  'src/ravintio-zero/skills/ravintio-initiative/SKILL.md',
];
// Paths whose change leaves the installed copies of the pack stale until setup reruns.
const SETUP_WATCHED = [
  'ravintio-zero/skills/',
  'src/ravintio-zero/skills/',
  'ravintio-zero/hooks/',
  'src/ravintio-zero/hooks/',
  'ravintio-zero/setup.sh',
  'src/ravintio-zero/setup.sh',
  'ravintio-zero/setup/',
  'src/ravintio-zero/setup/',
];
const MAX_NAMES = 5;
const STATUS = /^(proposed|charted|draft|active|blocked|delivered|done)$/;
const POSITION = /^[1-9][0-9]{0,2}$/;
const BRANCH = /^initiative\/([0-9]{7})-([a-z0-9]+(-[a-z0-9]+)*)$/;
const MAX_LINE = 500;
const MODEL = /^[A-Za-z0-9][A-Za-z0-9._:[\]-]{0,63}$/;
const TURNS = /^[1-9][0-9]{0,3}$/;
const DEFAULT_MODEL = 'sonnet';
const SESSION = /^[A-Za-z0-9_-]{8,128}$/;
const SESSION_FIELD = /"session_id"\s*:\s*"([^"]*)"/g;
const MAX_RESUMES = 2;
const REPLY_MAX = 4 * 1024 * 1024;
const CONTINUE_PROMPT = (n, log, queue = '') => `Continue initiative step ${n}. ${log}. Do not end your turn before I-D Advance: Complete:, a Blocked: line, or a Question: line.${queue}`;
const LOG_LINE = 'Read plan/current/build-log.md first';

// The concurrent driver (0000379). It runs only when the chart holds a **Concurrency:** field.
const WORKTREES = 'plan/.initiative-worktrees';
const CONTROL = 'plan/.initiative-control';
const FEATURE = /^[0-9]{7}-[a-z0-9]+(-[a-z0-9]+)*$/;
const PR = /^[1-9][0-9]{0,6}$/;
// Git-ignored setup output that a fresh worktree lacks (ADR-004).
const SETUP_OUTPUT = ['.claude', 'CLAUDE.md', 'AGENTS.md', '.codex'];

class Stop extends Error {}

// Local time as hh:mm, 24-hour and zero padded. Every printed line starts with it (0000388).
const clock = () => {
  const d = new Date();
  return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
};
const out = (line) => writeSync(1, `${clock()} ${line}\n`);

function parseArgs(argv) {
  let root = process.cwd();
  let handoff = 0;
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--root' && argv[i + 1]) root = argv[++i];
    else if (argv[i] === '--handoff' && /^[1-9][0-9]{0,9}$/.test(argv[i + 1] ?? '')) handoff = Number(argv[++i]);
    else throw new Stop(`I-C Run: Blocked: unknown argument "${argv[i].slice(0, 40)}"`);
  }
  return { root: resolve(root), handoff };
}

// Reads "name: value" or "- **name:** value" lines. The body wins over the frontmatter,
// because the agent updates the body fields. Falls back to the frontmatter.
// Strips a trailing " # comment" and one matching pair of surrounding quotes.
function field(text, name) {
  const fm = text.match(/^---\r?\n[\s\S]*?\r?\n---\r?\n?/);
  const head = fm ? fm[0] : '';
  const body = text.slice(head.length);
  return fieldIn(body, name) || fieldIn(head, name);
}

function fieldIn(text, name) {
  const re = new RegExp(`^\\s*(?:[-*]\\s+)?\\**${name}\\**\\s*:\\s*\\**\\s*\`?([^\`\\n]*?)\`?\\s*$`, 'mi');
  const m = text.match(re);
  if (!m) return '';
  const v = m[1].replace(/\s+#.*$/, '').trim();
  return /^(["']).*\1$/.test(v) ? v.slice(1, -1).trim() : v;
}

// Old name to new name. A set old variable stops the driver (0000189 REQ-006).
const OLD_VARIABLES = [
  ['RAVINTIO_ROADMAP_MODEL', 'RAVINTIO_INITIATIVE_MODEL'],
  ['PLANIFEST_ROADMAP_MODEL', 'RAVINTIO_INITIATIVE_MODEL'],
  ['RAVINTIO_ROADMAP_MAX_TURNS', 'RAVINTIO_INITIATIVE_MAX_TURNS'],
  ['PLANIFEST_ROADMAP_MAX_TURNS', 'RAVINTIO_INITIATIVE_MAX_TURNS'],
];

// Reads and validates the child settings. The stop lines name the variable, never the value.
function readChildConfig() {
  for (const [old, current] of OLD_VARIABLES) {
    if (process.env[old]) throw new Stop(`I-C Run: Blocked: ${old} is no longer read. Set ${current} instead.`);
  }
  const model = process.env.RAVINTIO_INITIATIVE_MODEL || DEFAULT_MODEL;
  if (!MODEL.test(model)) {
    throw new Stop('I-C Run: Blocked: RAVINTIO_INITIATIVE_MODEL must match ^[A-Za-z0-9][A-Za-z0-9._:[\\]-]{0,63}$');
  }
  const turns = process.env.RAVINTIO_INITIATIVE_MAX_TURNS || '';
  if (turns !== '' && !TURNS.test(turns)) {
    throw new Stop('I-C Run: Blocked: RAVINTIO_INITIATIVE_MAX_TURNS must be a positive integer of up to 4 digits');
  }
  return { model, turns };
}

function readInitiative(root) {
  const file = join(root, INITIATIVE);
  if (!existsSync(file)) throw new Stop(`I-C Run: Blocked: ${INITIATIVE} is missing`);
  return parseInitiative(readFileSync(file, 'utf8'));
}

// Reads initiative.md from the initiative branch ref. Falls back to the working tree if
// the root is not a git work tree or the ref cannot be read.
function readInitiativeFromBranch(root, branch) {
  const inside = spawnSync('git', ['rev-parse', '--is-inside-work-tree'], { cwd: root, encoding: 'utf8' });
  if (!inside.error && inside.status === 0 && inside.stdout.trim() === 'true') {
    const shown = spawnSync('git', ['show', `${branch}:${INITIATIVE}`], { cwd: root, encoding: 'utf8' });
    if (!shown.error && shown.status === 0 && shown.stdout.trim() !== '') return parseInitiative(shown.stdout);
  }
  return readInitiative(root);
}

function parseInitiative(text) {
  const status = field(text, 'status');
  const position = field(text, 'position');
  const branch = field(text, 'branch');
  if (!STATUS.test(status)) throw new Stop('I-C Run: Blocked: initiative status is missing or invalid');
  if (!POSITION.test(position)) throw new Stop('I-C Run: Blocked: initiative position is missing or invalid');
  const b = branch.match(BRANCH);
  if (!b) throw new Stop('I-C Run: Blocked: initiative branch is missing or invalid');
  return { status, position, branch, id: b[1], slug: b[2], text };
}

// Adds the lock path and the log folder to .git/info/exclude so a step session's
// "stage everything" never commits either. Skips quietly outside a git work tree.
// The concurrent driver passes the worktree and control folders as extra entries.
function excludeLock(root, extra = []) {
  const git = (...args) => spawnSync('git', args, { cwd: root, encoding: 'utf8' });
  const inside = git('rev-parse', '--is-inside-work-tree');
  if (inside.error || inside.status !== 0 || inside.stdout.trim() !== 'true') return;
  const p = git('rev-parse', '--git-path', 'info/exclude');
  if (p.status !== 0) return;
  const file = resolve(root, p.stdout.trim());
  let text = existsSync(file) ? readFileSync(file, 'utf8') : '';
  for (const entry of [LOCK, `${LOGS}/`, QUEUE, ...extra]) {
    if (text.split(/\r?\n/).includes(entry)) continue;
    const add = (text === '' || text.endsWith('\n') ? '' : '\n') + entry + '\n';
    appendFileSync(file, add);
    text += add;
  }
}

// Returns the feature id in the Steps table row for a position, or ''.
function featureIdFor(text, position) {
  for (const line of text.split(/\r?\n/)) {
    const m = line.match(/^\|\s*(\d+)\s*\|\s*([0-9]{7}-[a-z0-9-]+)\s*\|/);
    if (m && m[1] === position) return m[2];
  }
  return '';
}

// Counts the numbered rows in the "## Steps" section. Returns 0 if there is no such section.
function countSteps(text) {
  let inSteps = false;
  let n = 0;
  for (const line of text.split(/\r?\n/)) {
    if (/^##\s/.test(line)) inSteps = /^##\s+Steps\s*$/i.test(line);
    else if (inSteps && /^\|\s*\d+\s*\|/.test(line)) n++;
  }
  return n;
}

// True when the path is a symlink. A missing path is not one.
function isLink(path) {
  try {
    return lstatSync(path).isSymbolicLink();
  } catch {
    return false;
  }
}

// True when anything sits at the path, including a dangling symlink.
function present(path) {
  try {
    lstatSync(path);
    return true;
  } catch {
    return false;
  }
}

// Returns the root-relative paths of the kept attempt logs for a step, in attempt order.
function attemptLogs(root, position) {
  const re = new RegExp(`^step-${position}\\.attempt-([1-9][0-9]*)\\.log$`);
  try {
    return readdirSync(join(root, LOGS))
      .map((name) => ({ name, k: Number((re.exec(name) || [])[1]) }))
      .filter((e) => e.k)
      .sort((a, b) => a.k - b.k)
      .map((e) => `${LOGS}/${e.name}`);
  } catch {
    return [];
  }
}

// Opens plan/.initiative-logs/step-{position}.log for writing. If the log exists, it first
// renames it to the next free step-{position}.attempt-{k}.log, so a rerun keeps the earlier
// output. Refuses a symlink at plan, at the log folder, at the log file, or at an attempt
// path, and a log folder whose real path leaves the real root. The open adds O_NOFOLLOW
// where the platform has it. The folder gets mode 0o700 and each log 0o600. Returns the file
// descriptor, the root-relative path, and the root-relative paths of the attempt logs.
function openLog(root, position) {
  const rel = `${LOGS}/step-${position}.log`;
  const refuse = () => new Stop('I-C Run: Blocked: refused a symlinked step log path');
  try {
    const dir = join(root, LOGS);
    for (const part of [join(root, 'plan'), dir]) if (isLink(part)) throw refuse();
    mkdirSync(dir, { recursive: true, mode: 0o700 });
    const rootReal = realpathSync(root);
    const within = relative(rootReal, realpathSync(dir));
    if (within.startsWith('..') || isAbsolute(within)) throw refuse();
    const file = join(root, rel);
    if (isLink(file)) throw refuse();
    if (present(file)) {
      let k = 1;
      let kept = join(dir, `step-${position}.attempt-${k}.log`);
      while (present(kept)) {
        if (isLink(kept)) throw refuse();
        kept = join(dir, `step-${position}.attempt-${++k}.log`);
      }
      renameSync(file, kept);
      chmodSync(kept, 0o600);
    }
    const { O_WRONLY, O_CREAT, O_TRUNC, O_NOFOLLOW = 0 } = fsConstants;
    return { fd: openSync(file, O_WRONLY | O_CREAT | O_TRUNC | O_NOFOLLOW, 0o600), rel, earlier: attemptLogs(root, position) };
  } catch (e) {
    if (e instanceof Stop) throw e;
    throw new Stop('I-C Run: Blocked: could not open the step log');
  }
}

// Returns the last Blocked: or Question: line when no Resolved: line follows it, else null.
// Either line may carry a list marker, such as "- " or "* ". A Question: line may also carry a
// short prefix, such as "P0 Discovery: " (0000370).
function openBlock(root) {
  const file = join(root, BUILD_LOG);
  if (!existsSync(file)) return null;
  return blockIn(readFileSync(file, 'utf8'));
}

// A Blocked: or Question: line. It may carry a list marker, an hh:mm time, and a short prefix,
// such as "13:41 I-D Advance: " (0000440).
const BLOCK_LINE = /^\s*(?:[-*+]\s+)?(?:\d{1,2}:\d{2}\s+)?(?:[^:\n]{1,30}:\s+)?(?:Blocked:|Question:)/;

function blockIn(text) {
  let last = null;
  for (const line of text.split(/\r?\n/)) {
    if (BLOCK_LINE.test(line)) last = line.trim();
    else if (/^\s*(?:[-*+]\s+)?Resolved:/.test(line)) last = null;
  }
  return last === null ? null : last.slice(0, MAX_LINE);
}

// Checks the build log in the newest folder under plan/_archive/ whose name starts with the
// feature id and that changed after the step started. Skips symlinks and paths that leave
// the archive folder.
function archivedBlock(root, featureId, since) {
  if (!featureId) return null;
  try {
    const dir = join(root, ARCHIVE);
    if (isLink(join(root, 'plan')) || isLink(dir) || !existsSync(dir)) return null;
    const names = readdirSync(dir).filter((n) => n.startsWith(featureId)).sort();
    for (let i = names.length - 1; i >= 0; i--) {
      const folder = join(dir, names[i]);
      const st = lstatSync(folder);
      if (st.isSymbolicLink() || !st.isDirectory()) continue;
      if (st.mtimeMs < since) return null;
      const file = join(folder, 'build-log.md');
      const fst = lstatSync(file);
      if (fst.isSymbolicLink() || !fst.isFile()) return null;
      const within = relative(realpathSync(dir), realpathSync(file));
      if (within.startsWith('..') || isAbsolute(within)) return null;
      return blockIn(readFileSync(file, 'utf8'));
    }
  } catch {
    // A missing folder or log means no archived block.
  }
  return null;
}

// Returns the commit that the branch ref points to, or '' if git or the ref is unreadable.
function branchHead(root, branch) {
  const r = spawnSync('git', ['rev-parse', '--verify', '--quiet', `refs/heads/${branch}`], { cwd: root, encoding: 'utf8' });
  return !r.error && r.status === 0 ? r.stdout.trim() : '';
}

// Returns the watched files that changed between two commits. Returns [] if either commit is
// missing, the two are equal, or git cannot compare them.
function changedWatched(root, before, after) {
  if (!before || !after || before === after) return [];
  const r = spawnSync('git', ['diff', '--name-only', before, after, '--', ...WATCHED], { cwd: root, encoding: 'utf8' });
  if (r.error || r.status !== 0) return [];
  const names = new Set(r.stdout.split(/\r?\n/).filter(Boolean));
  return WATCHED.filter((f) => names.has(f));
}

// Returns the files changed between two commits under the setup paths, in git order. Returns []
// if either commit is missing, the two are equal, or git cannot compare them.
function changedSetup(root, before, after) {
  if (!before || !after || before === after) return [];
  const r = spawnSync('git', ['diff', '--name-only', before, after, '--', ...SETUP_WATCHED], { cwd: root, encoding: 'utf8' });
  if (r.error || r.status !== 0) return [];
  return r.stdout.split(/\r?\n/).filter(Boolean);
}

// Names at most MAX_NAMES files, then "and {k} more".
function nameFiles(files) {
  const shown = files.slice(0, MAX_NAMES).join(', ');
  return files.length > MAX_NAMES ? `${shown} and ${files.length - MAX_NAMES} more` : shown;
}

function delivered(root, id, slug) {
  if (existsSync(join(root, INITIATIVE))) return false;
  const dir = join(root, ARCHIVE);
  if (!existsSync(dir)) return false;
  // Folders archived before 0000192 use the -roadmap- form, so accept both.
  const prefixes = [`${id}-${slug}-initiative-`, `${id}-${slug}-roadmap-`];
  return readdirSync(dir).some((n) => prefixes.some((p) => n.startsWith(p)));
}

// Names the writing standard in each step session's system prompt (0000389 ADR-004).
// Names the file the continue prompt tells a resumed session to read. If the build log is gone,
// it names the archived log of the feature, or says none exists (0000440).
function logLine(root, featureId) {
  if (existsSync(join(root, BUILD_LOG))) return LOG_LINE;
  try {
    const dir = join(root, ARCHIVE);
    if (featureId && !isLink(join(root, 'plan')) && !isLink(dir) && existsSync(dir)) {
      const names = readdirSync(dir).filter((n) => n.startsWith(featureId)).sort();
      for (let i = names.length - 1; i >= 0; i--) {
        const file = join(dir, names[i], 'build-log.md');
        const st = lstatSync(file, { throwIfNoEntry: false });
        if (st && st.isFile() && !st.isSymbolicLink()) return `plan/current/build-log.md is gone. Read ${ARCHIVE}/${names[i]}/build-log.md first`;
      }
    }
  } catch {
    // An unreadable archive means no archived log.
  }
  return 'plan/current/build-log.md is gone and there is no build log in the archive, so check git log and the PR';
}

const WRITING_LINE = 'Write all prose to ravintio-zero/standards/writing-standards.md.';

// Names the queue items that name the step (0000444). The sentence holds folder names that match
// NAME and the queue path. It never holds item content. An empty queue adds nothing.
function queueSentence(queueRoot, position) {
  try {
    const { items } = namedItems(queueRoot, position);
    if (items.length === 0) return '';
    const dir = join(queueRoot, 'plan', '.initiative-queue');
    return ` Queue items name this step: ${items.map((i) => i.name).join(', ')}. Read item.md in each folder under ${dir}/, act on it, and commit its destination or log "Queue item {name}: {reason}" in the build log.`;
  } catch {
    return '';
  }
}

// Runs one claude -p session for the step. With a session id it adds --resume and the continue
// prompt. Returns the exit status and the last session_id the child printed, or '' if none.
// The concurrent driver passes opts.cwd, the step worktree, and opts.env, the extra variables.
function runStep(root, position, cfg, fd, labels, resumeId, opts = {}) {
  return new Promise((resolveStep) => {
    const bin = process.env.CLAUDE_BIN || 'claude';
    const args = ['-p', '--output-format', 'stream-json', '--verbose', '--permission-mode', 'auto', '--append-system-prompt', WRITING_LINE, '--model', cfg.model];
    if (cfg.turns) args.push('--max-turns', cfg.turns);
    const queue = queueSentence(opts.queueRoot ?? root, position);
    if (resumeId) args.push('--resume', resumeId, CONTINUE_PROMPT(position, logLine(opts.cwd ?? root, opts.featureId), queue));
    else args.push(queue ? `Run initiative step ${position}.${queue}` : `Run initiative step ${position}`);
    const child = spawn(bin, args, {
      cwd: opts.cwd ?? root,
      env: { ...process.env, CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS: process.env.CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS ?? '0', RAVINTIO_INITIATIVE_STEP: '1', OTEL_RESOURCE_ATTRIBUTES: withInitiativeLabels(process.env.OTEL_RESOURCE_ATTRIBUTES, labels.id, labels.slug, position), ...(opts.env ?? {}) },
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    activeChild = child;
    track(child);
    let session = '';
    let rest = '';
    let reply = '';
    let pending = '';
    // Keeps the text of the last result event. A line that is not JSON, or a result that is not
    // a string, adds nothing. The text is data and goes to blockIn only (0000440).
    const readReply = (line) => {
      if (!line.includes('"result"')) return;
      try {
        const ev = JSON.parse(line);
        if (ev && ev.type === 'result' && typeof ev.result === 'string') reply = ev.result;
      } catch {
        // Not an event line.
      }
    };
    child.stdout.on('data', (chunk) => {
      writeSync(fd, chunk);
      pending += chunk.toString('utf8');
      const nl = pending.lastIndexOf('\n');
      if (nl >= 0) {
        for (const line of pending.slice(0, nl).split('\n')) readReply(line);
        pending = pending.slice(nl + 1);
      }
      if (pending.length > REPLY_MAX) pending = '';
      // Events are one JSON object per line. Keep the tail of a split line for the next chunk.
      const text = rest + chunk.toString('utf8');
      const cut = text.lastIndexOf('\n');
      const whole = cut < 0 ? '' : text.slice(0, cut);
      rest = (cut < 0 ? text : text.slice(cut + 1)).slice(-4096);
      for (const m of whole.matchAll(SESSION_FIELD)) session = m[1];
    });
    child.stderr.on('data', (chunk) => {
      writeSync(fd, chunk);
      writeSync(2, chunk);
    });
    child.on('error', (e) => resolveStep({ error: e.code || 'spawn error', session: '' }));
    child.on('close', (code, signal) => {
      for (const m of rest.matchAll(SESSION_FIELD)) session = m[1];
      readReply(pending);
      resolveStep({ code, signal, session, reply });
    });
  });
}

let activeChild = null;
// Every live child, so a signal stops all of them when steps run at once.
const children = new Set();
function track(child) {
  children.add(child);
  child.on('close', () => children.delete(child));
  child.on('error', () => children.delete(child));
}
let currentLog = null;
let earlierLogs = [];

const withLog = (line) => {
  if (!currentLog) return line;
  const earlier = earlierLogs.length > 0 ? ` Earlier: ${earlierLogs.join(', ')}.` : '';
  return `${line}${earlier} Log: ${currentLog}`;
};
let lockPath = null;

function releaseLock() {
  if (!lockPath) return;
  try {
    unlinkSync(lockPath);
  } catch {
    // Already gone.
  }
  lockPath = null;
}

for (const sig of ['SIGINT', 'SIGTERM', 'SIGHUP']) {
  process.on(sig, () => {
    if (activeChild) activeChild.kill(sig);
    for (const c of children) if (c !== activeChild) c.kill(sig);
    releaseLock();
    out(withLog(`I-C Run: Blocked: driver stopped by ${sig}`));
    process.exit(1);
  });
}
process.on('exit', releaseLock);

// Returns the pid a lock names when that process no longer runs, else 0. A symlink, a file
// that holds anything but one decimal pid, and a pid that runs all return 0 (0000495, ADR-0324).
function deadLockPid(lock) {
  try {
    if (isLink(lock)) return 0;
    const text = readFileSync(lock, 'utf8');
    if (!/^[1-9][0-9]{0,9}\n?$/.test(text)) return 0;
    const pid = Number(text);
    return alive(pid) ? 0 : pid;
  } catch {
    return 0;
  }
}

// Writes this process id into the lock. If the lock exists, the driver refuses unless the lock
// names a process that no longer runs. It then reports the pid, removes the file, and writes
// again with wx, so only one of two racing drivers wins.
function takeLock(lock) {
  const refuse = () => new Stop(`I-C Run: Blocked: ${LOCK} exists, another driver may be running`);
  for (let attempt = 0; attempt < 2; attempt++) {
    try {
      writeFileSync(lock, `${process.pid}\n`, { flag: 'wx' });
      return;
    } catch (e) {
      if (e.code !== 'EEXIST') throw e;
    }
    const dead = deadLockPid(lock);
    if (!dead || attempt > 0) throw refuse();
    out(`I-C Run: Starting: lock named process ${dead}, which no longer runs. Taking the lock.`);
    // Remove the file only if it still names the dead process.
    if (deadLockPid(lock) !== dead) throw refuse();
    try {
      unlinkSync(lock);
    } catch (e) {
      if (e.code !== 'ENOENT') throw e;
    }
  }
}

async function main() {
  const { root, handoff } = parseArgs(process.argv.slice(2));
  const cfg = readChildConfig();
  let rm = readInitiative(root);
  if (rm.status !== 'active') throw new Stop(`I-C Run: Blocked: initiative status is ${rm.status}, not active`);
  const { id, slug } = rm;

  const concurrent = usesScheduler(root, rm);
  const lock = join(root, LOCK);
  excludeLock(root, concurrent ? [`${WORKTREES}/`, `${CONTROL}/`] : []);
  if (handoff) {
    // The old driver wrote this process id into the lock and gave up the lock (0000493).
    if (!concurrent) throw new Stop('I-C Run: Blocked: --handoff needs a chart with **Concurrency:**');
    if (!(await lockHeldBy(lock, process.pid))) throw new Stop(`I-C Run: Blocked: ${LOCK} does not hold the handoff driver`);
    lockPath = lock;
  } else {
    takeLock(lock);
    lockPath = lock;
  }
  if (concurrent) return schedule(root, cfg, rm, handoff);

  const ran = [];
  for (;;) {
    const position = rm.position;
    const featureId = featureIdFor(rm.text, position);
    const started = Date.now();
    const headBefore = branchHead(root, rm.branch);
    currentLog = null;
    earlierLogs = [];
    const log = openLog(root, position);
    currentLog = log.rel;
    earlierLogs = log.earlier;
    out(`I-C Run: Starting: initiative step ${position} in a fresh session`);
    // Runs the step, then once more per resume. A step that exits 0 without merging and without a
    // block may have ended its turn early (0000334), so the driver resumes its session.
    let session = '';
    let resumes = 0;
    try {
    for (;;) {
      const res = await runStep(root, position, cfg, log.fd, { id, slug }, resumes > 0 ? session : '', { featureId });
      activeChild = null;
      if (res.error) throw new Stop(`I-C Run: Blocked: could not start claude (${res.error})`);
      if (res.code !== 0) {
        const cap = cfg.turns ? `. The step may have reached RAVINTIO_INITIATIVE_MAX_TURNS=${cfg.turns}` : '';
        throw new Stop(`I-C Run: Blocked: claude exited ${res.code ?? res.signal} on step ${position}${cap}`);
      }
      if (res.session) session = res.session;
      if (delivered(root, id, slug)) {
        ran.push(position);
        reportSteps(ran);
        out(`I-E Delivery: Complete: initiative ${id}-${slug} archived, driver done`);
        return;
      }
      const block = openBlock(root) || archivedBlock(root, featureId, started - 1000) || blockIn(res.reply);
      if (block) throw new Stop(`I-C Run: Blocked: step ${position} stopped. ${block}`);
      rm = readInitiativeFromBranch(root, rm.branch);
      if (rm.position !== position) break;
      if (!SESSION.test(session)) {
        throw new Stop(`I-C Run: Blocked: step ${position} is not merged into the initiative branch, position stayed at ${position}`);
      }
      if (resumes >= MAX_RESUMES) {
        throw new Stop(`I-C Run: Blocked: step ${position} exited without merging after ${MAX_RESUMES} resumes, position stayed at ${position}`);
      }
      resumes++;
      out(`I-C Run: Resuming: step ${position} ended its turn unmerged, resume ${resumes} of ${MAX_RESUMES}`);
    }
    } finally {
      closeSync(log.fd);
    }
    ran.push(position);
    if (rm.status !== 'active') throw new Stop(`I-C Run: Blocked: initiative status is ${rm.status}, not active`);
    const total = countSteps(rm.text);
    if (total > 0 && Number(rm.position) > total) {
      // The last step may have changed pack files that setup installs. Name them before delivery
      // runs on stale installed copies (0000373). No next step exists, so no Restart label.
      const lastHead = branchHead(root, rm.branch);
      const lastSetup = changedSetup(root, headBefore, lastHead);
      if (lastSetup.length > 0) {
        const done = approvedSetup(root, rm.branch, rm.text, lastHead, position);
        if (done !== 'ran') {
          reportSteps(ran);
          throw new Stop(`I-D Advance: Setup: step ${position} changed ${nameFiles(lastSetup)}. ${setupNote(done)}Rerun setup, then start a new driver.`);
        }
      }
      reportSteps(ran);
      out(`I-E Delivery: Pending: all ${total} steps merged, initiative delivery runs from the initiative skill`);
      return;
    }
    out(`I-D Advance: Complete: step ${position} done, position now ${rm.position}`);
    const headAfter = branchHead(root, rm.branch);
    const restart = changedWatched(root, headBefore, headAfter);
    const setup = changedSetup(root, headBefore, headAfter);
    if (setup.length > 0) {
      const done = approvedSetup(root, rm.branch, rm.text, headAfter, position);
      if (done !== 'ran') {
        const files = nameFiles([...restart, ...setup.filter((f) => !restart.includes(f))]);
        if (restart.length > 0) {
          throw new Stop(`I-D Advance: Restart: Setup: step ${position} changed ${files}. ${setupNote(done)}Rerun setup, then start a new driver so step ${rm.position} runs the new code.`);
        }
        throw new Stop(`I-D Advance: Setup: step ${position} changed ${files}. ${setupNote(done)}Rerun setup, then start a new driver.`);
      }
    }
    if (restart.length > 0) {
      throw new Stop(`I-D Advance: Restart: step ${position} changed ${restart.join(', ')}. Start a new driver so step ${rm.position} runs the new code.`);
    }
  }
}

// ---------------------------------------------------------------- concurrent driver (0000379)

const gitIn = (cwd, args, env) => spawnSync('git', args, { cwd, encoding: 'utf8', env: env ?? process.env });
const ran0 = (r) => !r.error && r.status === 0;
const lastLine = (text) => (text || '').split(/\r?\n/).map((l) => l.trim()).filter(Boolean).pop() || '';

// True when the chart in the working tree or on the initiative ref holds a **Concurrency:** field.
// A chart that the parser rejects still counts when the field is there, so the scheduler names the
// error. Without the field, the serial path runs as before (ADR-002). An unfilled template
// placeholder, such as "{{1 to 9, default 3}}", counts as no field.
function usesScheduler(root, rm) {
  const texts = [rm.text];
  for (const ref of [`refs/remotes/origin/${rm.branch}`, `refs/heads/${rm.branch}`]) {
    const shown = gitIn(root, ['show', `${ref}:${INITIATIVE}`]);
    if (ran0(shown)) texts.push(shown.stdout);
  }
  return texts.some((t) => {
    const value = field(t, 'Concurrency');
    if (value === '' || /^\{\{.*\}\}$/.test(value)) return false;
    try {
      return parseChart(t).hasConcurrency;
    } catch {
      return true;
    }
  });
}

// Fetches the initiative branch when an origin remote exists. A failed fetch is ignored.
function fetchBranch(root, branch) {
  if (!ran0(gitIn(root, ['remote', 'get-url', 'origin']))) return;
  gitIn(root, ['fetch', '--quiet', 'origin', branch], { ...process.env, GIT_TERMINAL_PROMPT: '0' });
}

// Returns origin/{branch} when that ref exists, else the local branch, else ''.
function initiativeRef(root, branch) {
  for (const ref of [`refs/remotes/origin/${branch}`, `refs/heads/${branch}`]) {
    if (ran0(gitIn(root, ['rev-parse', '--verify', '--quiet', `${ref}^{commit}`]))) return ref;
  }
  return '';
}

function refHead(root, ref) {
  if (!ref) return '';
  const r = gitIn(root, ['rev-parse', '--verify', '--quiet', `${ref}^{commit}`]);
  return ran0(r) ? r.stdout.trim() : '';
}

// Reads the chart from the ref, or from the working tree when the ref is unreadable.
function readChart(root, ref) {
  let text = '';
  if (ref) {
    const shown = gitIn(root, ['show', `${ref}:${INITIATIVE}`]);
    if (ran0(shown)) text = shown.stdout;
  }
  if (text.trim() === '') text = readFileSync(join(root, INITIATIVE), 'utf8');
  try {
    return parseChart(text);
  } catch (e) {
    throw new Stop(`I-C Run: Blocked: the chart is invalid. ${String(e.message).slice(0, MAX_LINE)}`);
  }
}

const worktreeRefusal = () => new Stop('I-C Run: Blocked: refused a symlinked step worktree path');
const controlRefusal = () => new Stop('I-C Run: Blocked: refused a symlinked step control path');

// Makes the worktree or control folder under the root. Refuses a symlink at plan or at the folder,
// and a folder whose real path leaves the real root.
function ensureArea(root, base, refuse) {
  const dir = join(root, base);
  for (const part of [join(root, 'plan'), dir]) if (isLink(part)) throw refuse();
  mkdirSync(dir, { recursive: true, mode: 0o700 });
  const within = relative(realpathSync(root), realpathSync(dir));
  if (within === '' || within.startsWith('..') || isAbsolute(within)) throw refuse();
  return dir;
}

// Returns the path of one entry in an area, such as step-3 or queue. Refuses a symlink there.
function areaPath(root, base, name, refuse) {
  const dir = ensureArea(root, base, refuse);
  const path = join(dir, name);
  if (isLink(path)) throw refuse();
  return path;
}

// Stops unless the folder is the top of a git worktree. This keeps a later git call from reaching
// the main working tree through a plain folder.
function checkWorktree(path, rel) {
  const r = gitIn(path, ['rev-parse', '--show-toplevel']);
  if (!ran0(r) || realpathSync(r.stdout.trim()) !== realpathSync(path)) {
    throw new Stop(`I-C Run: Blocked: ${rel} is not a git worktree`);
  }
}

// Copies the setup output from the root into a worktree. Skips symlinks and never follows one.
function copySetup(root, wt, n) {
  for (const name of SETUP_OUTPUT) {
    const src = join(root, name);
    const dest = join(wt, name);
    if (!present(src) || isLink(src) || isLink(dest)) continue;
    try {
      cpSync(src, dest, { recursive: true, force: true, dereference: false, filter: (s) => !isLink(s) });
    } catch {
      throw new Stop(`I-C Run: Blocked: could not copy ${name} into the worktree of step ${n}`);
    }
  }
}

// Cuts or reuses the step worktree on branch feat/{featureId}. Returns its absolute path.
function prepareWorktree(root, n, featureId, ref) {
  const rel = `${WORKTREES}/step-${n}`;
  const wt = areaPath(root, WORKTREES, `step-${n}`, worktreeRefusal);
  if (present(wt)) {
    checkWorktree(wt, rel);
  } else {
    const branch = `feat/${featureId}`;
    const exists = ran0(gitIn(root, ['rev-parse', '--verify', '--quiet', `refs/heads/${branch}`]));
    const args = exists ? ['worktree', 'add', '--quiet', wt, branch] : ['worktree', 'add', '--quiet', '--no-track', '-b', branch, wt, ref];
    const r = gitIn(root, args);
    if (!ran0(r)) throw new Stop(`I-C Run: Blocked: could not create the worktree of step ${n}. ${lastLine(r.stderr).slice(0, MAX_LINE)}`);
  }
  copySetup(root, wt, n);
  return wt;
}

// Puts the queue worktree, detached, on the fresh initiative ref. Returns its absolute path.
function prepareQueue(root, ref) {
  const rel = `${WORKTREES}/queue`;
  const q = areaPath(root, WORKTREES, 'queue', worktreeRefusal);
  let r;
  if (present(q)) {
    checkWorktree(q, rel);
    r = gitIn(q, ['checkout', '--quiet', '--force', '--detach', ref]);
  } else {
    r = gitIn(root, ['worktree', 'add', '--quiet', '--detach', q, ref]);
  }
  if (!ran0(r)) throw new Stop(`could not prepare ${rel}. ${lastLine(r.stderr)}`);
  return q;
}

// Stops before the removal if the step worktree holds an untracked file under plan/backlog/, or if
// git cannot list the files. The removal deletes untracked files (0000497 ADR-0325).
function keepUntrackedEntries(wt, n) {
  const r = gitIn(wt, ['ls-files', '--others', '--exclude-standard', '-z', '--', 'plan/backlog']);
  if (!ran0(r)) throw new Stop(`could not list untracked backlog entries in ${WORKTREES}/step-${n}. ${lastLine(r.stderr)}`);
  const files = r.stdout.split('\0').filter(Boolean);
  if (files.length === 0) return;
  const shown = files.slice(0, 5).join(', ');
  const rest = files.length > 5 ? ` and ${files.length - 5} more` : '';
  throw new Stop(`${WORKTREES}/step-${n} holds untracked backlog entries: ${shown}${rest}. Commit them in the worktree, then start a new driver.`);
}

function removeWorktree(root, n) {
  const wt = areaPath(root, WORKTREES, `step-${n}`, worktreeRefusal);
  if (!present(wt)) return;
  keepUntrackedEntries(wt, n);
  const r = gitIn(root, ['worktree', 'remove', '--force', wt]);
  if (!ran0(r)) throw new Stop(`could not remove ${WORKTREES}/step-${n}. ${lastLine(r.stderr)}`);
}

// Returns why a merged step's worktree is unsafe to remove, or '' when it is safe. A git command that
// fails counts as unsafe (0000501 ADR-0326).
function unsafeWorktree(wt, featureId) {
  const inspect = (r) => `worktree could not be inspected: ${lastLine(r.stderr) || r.error?.code || 'git failed'}`.slice(0, MAX_LINE);
  const status = gitIn(wt, ['status', '--porcelain', '-z']);
  if (!ran0(status)) return inspect(status);
  const files = status.stdout.split('\0').filter(Boolean).map((e) => e.slice(3));
  if (files.length > 0) {
    const rest = files.length > 5 ? ` and ${files.length - 5} more` : '';
    return `worktree holds uncommitted files: ${files.slice(0, 5).join(', ')}${rest}`;
  }
  const head = gitIn(wt, ['rev-parse', 'HEAD']);
  if (!ran0(head)) return inspect(head);
  const branch = `feat/${featureId}`;
  const remote = gitIn(wt, ['ls-remote', '--heads', 'origin', `refs/heads/${branch}`]);
  if (!ran0(remote)) return inspect(remote);
  const tip = remote.stdout.trim().split(/\s+/)[0];
  if (!tip || tip === head.stdout.trim()) return '';
  const below = gitIn(wt, ['merge-base', '--is-ancestor', head.stdout.trim(), tip]);
  if (below.status === 0) return '';
  return below.status === 1 ? `worktree head is not on origin/${branch}` : inspect(below);
}

// Removes the worktree of each merged step when it is safe, once at start. It prints one Kept line for
// each worktree it leaves, and never stops the run (0000501 ADR-0326).
function sweepMergedWorktrees(root, steps, merged) {
  for (const s of steps) {
    if (!merged.has(s.step)) continue;
    const n = s.step;
    const keep = (why) => out(`I-C Run: Kept: step ${n} ${why}`.slice(0, MAX_LINE));
    try {
      const wt = areaPath(root, WORKTREES, `step-${n}`, worktreeRefusal);
      if (!present(wt)) continue;
      const pid = runningPid(root, n);
      if (pid && alive(pid)) {
        keep('a session still runs');
        continue;
      }
      const why = unsafeWorktree(wt, s.featureId);
      if (why) {
        keep(why);
        continue;
      }
      const r = gitIn(root, ['worktree', 'remove', '--force', wt]);
      if (!ran0(r)) keep(`worktree could not be removed: ${lastLine(r.stderr)}`);
    } catch (e) {
      keep(`worktree could not be inspected: ${e instanceof Stop ? e.message : e.code || e.name}`);
    }
  }
}

function controlDir(root, n) {
  const dir = areaPath(root, CONTROL, `step-${n}`, controlRefusal);
  mkdirSync(dir, { recursive: true, mode: 0o700 });
  return dir;
}

// Looks up the one open PR for the step branch (0000442 REQ-002, ADR-0304). Returns its number as a
// string, or '' if gh fails, answers with anything but one valid number, or finds none or many.
// The branch goes to gh as one argument and never to a shell.
function recoverPr(root, featureId) {
  if (!FEATURE.test(featureId ?? '')) return '';
  const gh = process.env.RAVINTIO_GH_BIN || 'gh';
  const r = spawnSync(gh, ['pr', 'list', '--head', `feat/${featureId}`, '--state', 'open', '--json', 'number'], {
    cwd: root,
    encoding: 'utf8',
  });
  if (r.error || r.status !== 0) return '';
  let list;
  try {
    list = JSON.parse(r.stdout);
  } catch {
    return '';
  }
  if (!Array.isArray(list) || list.length !== 1) return '';
  const n = String(list[0]?.number);
  return PR.test(n) ? n : '';
}

// Reads a step's control folder. Returns the PR number in ready, or '', and whether running exists.
// If ready is empty or invalid, it recovers the number from the step branch and rewrites the file.
function readControl(root, n, featureId) {
  const dir = areaPath(root, CONTROL, `step-${n}`, controlRefusal);
  const file = (name) => {
    const p = join(dir, name);
    if (isLink(p)) throw controlRefusal();
    return present(p) ? p : '';
  };
  if (!present(dir)) return { ready: '', running: false };
  const readyFile = file('ready');
  let ready = '';
  if (readyFile) {
    ready = lstatSync(readyFile).isFile() ? readFileSync(readyFile, 'utf8').trim() : '';
    if (!PR.test(ready)) {
      const found = lstatSync(readyFile).isFile() ? recoverPr(root, featureId) : '';
      if (!found) throw new Stop(`I-C Run: Blocked: step ${n} wrote an invalid ready file`);
      const tmp = join(dir, `.ready.${process.pid}.tmp`);
      try {
        writeFileSync(tmp, `${found}\n`, { mode: 0o600, flag: 'wx' });
        renameSync(tmp, readyFile);
      } catch {
        rmSync(tmp, { force: true });
        throw new Stop(`I-C Run: Blocked: step ${n} wrote an invalid ready file`);
      }
      out(`I-D Advance: Ready: step ${n} recovered PR #${found} from the step branch`);
      ready = found;
    }
  }
  return { ready, running: file('running') !== '' };
}

function removeControl(root, n) {
  const dir = areaPath(root, CONTROL, `step-${n}`, controlRefusal);
  rmSync(dir, { recursive: true, force: true });
}

// Opens the step log for append, with the same refusals as openLog and no rotation.
function appendLog(root, position) {
  const rel = `${LOGS}/step-${position}.log`;
  const refuse = () => new Stop('I-C Run: Blocked: refused a symlinked step log path');
  try {
    const dir = join(root, LOGS);
    for (const part of [join(root, 'plan'), dir]) if (isLink(part)) throw refuse();
    mkdirSync(dir, { recursive: true, mode: 0o700 });
    const within = relative(realpathSync(root), realpathSync(dir));
    if (within.startsWith('..') || isAbsolute(within)) throw refuse();
    const file = join(root, rel);
    if (isLink(file)) throw refuse();
    const { O_WRONLY, O_CREAT, O_APPEND, O_NOFOLLOW = 0 } = fsConstants;
    return { fd: openSync(file, O_WRONLY | O_CREAT | O_APPEND | O_NOFOLLOW, 0o600), rel, earlier: attemptLogs(root, position) };
  } catch (e) {
    if (e instanceof Stop) throw e;
    throw new Stop('I-C Run: Blocked: could not open the step log');
  }
}

// Runs the merge queue for one PR in the queue worktree. Streams its output into the step log and
// copies its stderr to the driver's stderr. Returns the exit status and the last output line.
function runQueue(n, pr, queueDir, fd) {
  return new Promise((done) => {
    const bin = process.env.MERGE_QUEUE_BIN || join(dirname(fileURLToPath(import.meta.url)), 'merge-queue.mjs');
    const child = spawn(process.execPath, [bin, 'run', '--step', String(n), '--pr', pr, '--root', queueDir], {
      cwd: queueDir,
      env: process.env,
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    track(child);
    let tail = '';
    const keep = (chunk) => {
      writeSync(fd, chunk);
      tail = (tail + chunk.toString('utf8')).slice(-8192);
    };
    child.stdout.on('data', keep);
    child.stderr.on('data', (chunk) => {
      keep(chunk);
      writeSync(2, chunk);
    });
    child.on('error', (e) => done({ error: e.code || 'spawn error', last: '' }));
    child.on('close', (code, signal) => done({ code, signal, last: lastLine(tail) }));
  });
}

// Brings the root to the target commit. The root must sit on the initiative branch. Returns true
// when HEAD equals the target afterwards.
function fastForwardRoot(root, branch, target) {
  if (!target) return false;
  const head = gitIn(root, ['rev-parse', 'HEAD']);
  if (!ran0(head)) return false;
  if (head.stdout.trim() === target) return true;
  const current = gitIn(root, ['symbolic-ref', '--quiet', '--short', 'HEAD']);
  if (!ran0(current) || current.stdout.trim() !== branch) return false;
  return ran0(gitIn(root, ['merge', '--ff-only', '--quiet', target]));
}

// Handoff helpers (0000493, ADR-0323).
const alive = (pid) => {
  try {
    process.kill(pid, 0);
    return true;
  } catch (e) {
    return e.code === 'EPERM';
  }
};
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// Waits up to 5 s for the lock file to hold the pid.
async function lockHeldBy(lock, pid) {
  for (let i = 0; i < 100; i++) {
    try {
      if (!isLink(lock) && readFileSync(lock, 'utf8').trim() === String(pid)) return true;
    } catch {
      // The old driver has not written it yet.
    }
    await sleep(50);
  }
  return false;
}

// Starts the successor with the driver's own output handles and returns its pid, or 0.
// The argument list is fixed and no shell runs.
function spawnSuccessor(root, parentPid) {
  try {
    const script = fileURLToPath(import.meta.url);
    const child = spawn(process.execPath, [script, '--root', root, '--handoff', String(parentPid)], {
      cwd: root,
      detached: true,
      stdio: ['ignore', 1, 2],
      env: process.env,
    });
    child.on('error', () => {});
    child.unref();
    return child.pid || 0;
  } catch {
    return 0;
  }
}

// Reads the pid in a step's running file, or 0.
function runningPid(root, n) {
  try {
    const p = join(areaPath(root, CONTROL, `step-${n}`, controlRefusal), 'running');
    if (isLink(p)) throw controlRefusal();
    const v = readFileSync(p, 'utf8').trim();
    return /^[1-9][0-9]{0,9}$/.test(v) ? Number(v) : 0;
  } catch (e) {
    if (e instanceof Stop) throw e;
    return 0;
  }
}

// Reads the first line of a step's stopped file as data, cut to MAX_LINE. Returns '' if none.
function readStopped(root, n) {
  try {
    const p = join(areaPath(root, CONTROL, `step-${n}`, controlRefusal), 'stopped');
    if (isLink(p)) throw controlRefusal();
    return (readFileSync(p, 'utf8').split(/\r?\n/)[0] || '').slice(0, MAX_LINE);
  } catch (e) {
    if (e instanceof Stop) throw e;
    return '';
  }
}

function writeStopped(root, n, msg) {
  try {
    const p = join(controlDir(root, n), 'stopped');
    if (isLink(p)) return;
    writeFileSync(p, `${msg.split(/\r?\n/)[0].slice(0, MAX_LINE)}\n`, { mode: 0o600 });
  } catch {
    // The stop line still prints. The successor then misses it and waits for the step.
  }
}

function clearStopped(root, n) {
  try {
    const p = join(areaPath(root, CONTROL, `step-${n}`, controlRefusal), 'stopped');
    if (!isLink(p)) rmSync(p, { force: true });
  } catch {
    // Nothing to clear.
  }
}

// Runs the approved setup command at a Setup: hit (0000448, ADR-0310). The command comes from the
// setup Confirmation: row of the chart text, and setup-command.mjs accepts only the pack setup.sh
// with flag words. The root must hold the merged ref first. If the root sits on the initiative branch
// behind the ref, it fast-forwards. The command runs with bash, an argument array, and no shell.
// Returns 'ran' after a clean exit, 'failed' after any other exit, and 'none' if nothing ran.
function approvedSetup(root, branch, chartText, target, n) {
  const cmd = findSetupCommand(chartText);
  if (!cmd || !target) return 'none';
  if (!fastForwardRoot(root, branch, target)) return 'none';
  const script = join(root, cmd.file);
  if (isLink(script) || !existsSync(script)) return 'none';
  const r = spawnSync('bash', [script, ...cmd.args], { cwd: root, stdio: ['ignore', 2, 2] });
  if (r.error || r.status !== 0) return 'failed';
  out(`I-D Advance: Setup: step ${n} ran the approved setup command`);
  return 'ran';
}

// The sentence a Setup: stop line adds when the approved command ran and failed.
const setupNote = (done) => (done === 'failed' ? 'The approved setup command failed. ' : '');

// Reads the chart text from the ref, or from the working tree when the ref is unreadable.
function chartText(root, ref) {
  if (ref) {
    const shown = gitIn(root, ['show', `${ref}:${INITIATIVE}`]);
    if (ran0(shown) && shown.stdout.trim() !== '') return shown.stdout;
  }
  try {
    return readFileSync(join(root, INITIATIVE), 'utf8');
  } catch {
    return '';
  }
}

// Returns { line, files, handoff } for a merge that changed watched files. The line is the Restart
// or Setup stop line, or ''. The approved setup command runs first, and a clean run removes the
// Setup: part of the stop. handoff is true for a Restart-only hit, which may hand over (0000493).
function restartLine(root, n, before, after, branch) {
  const restart = changedWatched(root, before, after);
  const setup = changedSetup(root, before, after);
  if (setup.length > 0) {
    const done = approvedSetup(root, branch, chartText(root, initiativeRef(root, branch)), after, n);
    if (done !== 'ran') {
      const files = nameFiles([...restart, ...setup.filter((f) => !restart.includes(f))]);
      if (restart.length > 0) {
        return { line: `I-D Advance: Restart: Setup: step ${n} changed ${files}. ${setupNote(done)}Rerun setup, then start a new driver so the next step runs the new code.`, files, handoff: false };
      }
      return { line: `I-D Advance: Setup: step ${n} changed ${files}. ${setupNote(done)}Rerun setup, then start a new driver.`, files, handoff: false };
    }
  }
  if (restart.length > 0) {
    const files = restart.join(', ');
    return { line: `I-D Advance: Restart: step ${n} changed ${files}. Start a new driver so the next step runs the new code.`, files, handoff: true };
  }
  return { line: '', files: '', handoff: false };
}

// Runs one step session in its worktree until the step writes ready. Applies the resume rule.
// Returns the PR number from the ready file.
async function runScheduledStep(root, rec, cfg, rm) {
  const n = rec.n;
  const position = String(n);
  fetchBranch(root, rm.branch);
  const ref = initiativeRef(root, rm.branch);
  if (!ref) throw new Stop(`I-C Run: Blocked: the initiative branch ${rm.branch} has no readable ref`);
  const log = openLog(root, position);
  rec.log = { rel: log.rel, earlier: log.earlier };
  try {
    const wt = prepareWorktree(root, n, rec.featureId, ref);
    const ctl = controlDir(root, n);
    const runningFile = join(ctl, 'running');
    if (isLink(runningFile)) throw controlRefusal();
    writeFileSync(runningFile, `${process.pid}\n`, { mode: 0o600 });
    out(`I-C Run: Starting: initiative step ${position} in a fresh session`);
    const opts = {
      cwd: wt,
      queueRoot: root,
      featureId: rec.featureId,
      env: { RAVINTIO_INITIATIVE_QUEUE: '1', RAVINTIO_INITIATIVE_ROOT: root, RAVINTIO_INITIATIVE_CONTROL: ctl },
    };
    const started = Date.now();
    let session = '';
    let resumes = 0;
    for (;;) {
      const res = await runStep(wt, position, cfg, log.fd, { id: rm.id, slug: rm.slug }, resumes > 0 ? session : '', opts);
      if (res.error) throw new Stop(`I-C Run: Blocked: could not start claude (${res.error})`);
      if (res.code !== 0) {
        const cap = cfg.turns ? `. The step may have reached RAVINTIO_INITIATIVE_MAX_TURNS=${cfg.turns}` : '';
        throw new Stop(`I-C Run: Blocked: claude exited ${res.code ?? res.signal} on step ${position}${cap}`);
      }
      if (res.session) session = res.session;
      const block = openBlock(wt) || archivedBlock(wt, rec.featureId, started - 1000) || blockIn(res.reply);
      if (block) throw new Stop(`I-C Run: Blocked: step ${position} stopped. ${block}`);
      const pr = readControl(root, n, rec.featureId).ready;
      if (pr) return pr;
      if (!SESSION.test(session)) throw new Stop(`I-C Run: Blocked: step ${position} exited without reaching ready`);
      if (resumes >= MAX_RESUMES) {
        throw new Stop(`I-C Run: Blocked: step ${position} exited without reaching ready after ${MAX_RESUMES} resumes`);
      }
      resumes++;
      out(`I-C Run: Resuming: step ${position} ended its turn before ready, resume ${resumes} of ${MAX_RESUMES}`);
    }
  } finally {
    closeSync(log.fd);
  }
}

// The scheduler. It starts ready steps up to the concurrency cap, each in its own worktree, and
// merges ready steps through the merge queue one at a time. A stop ends new starts. Running steps
// still reach ready or stop, and the queue still merges every ready step, also after a queue failure.
async function schedule(root, cfg, rm, handoff = 0) {
  const { id, slug, branch } = rm;
  const merged = new Set();
  const mergeOrder = [];
  const readyOrder = [];
  let chart;
  const refresh = () => {
    fetchBranch(root, branch);
    chart = readChart(root, initiativeRef(root, branch));
    for (const s of chart.steps) if (s.status === 'merged') merged.add(s.step);
  };
  refresh();
  if (!initiativeRef(root, branch)) throw new Stop(`I-C Run: Blocked: the initiative branch ${branch} has no readable ref`);
  if (chart.steps.length === 0) throw new Stop('I-C Run: Blocked: the chart has no steps');
  ensureArea(root, WORKTREES, worktreeRefusal);
  ensureArea(root, CONTROL, controlRefusal);

  // One record per chart step. Driver restart: a ready file queues the step, and a running file
  // without ready restarts its session in the existing worktree.
  const recs = new Map();
  const recFor = (s) => {
    if (!POSITION.test(String(s.step))) throw new Stop(`I-C Run: Blocked: step ${String(s.step).slice(0, 40)} is not a valid step number`);
    if (!FEATURE.test(s.featureId)) throw new Stop(`I-C Run: Blocked: step ${s.step} has an invalid feature id`);
    if (!recs.has(s.step)) recs.set(s.step, { n: s.step, featureId: s.featureId, state: 'pending', resume: false, pr: '', log: null });
    return recs.get(s.step);
  };
  for (const s of chart.steps) {
    const rec = recFor(s);
    if (merged.has(s.step)) {
      rec.state = 'merged';
      continue;
    }
    const c = readControl(root, s.step, s.featureId);
    if (c.ready) {
      rec.state = 'ready';
      rec.pr = c.ready;
      readyOrder.push(s.step);
      out(`I-D Advance: Ready: step ${s.step} has PR #${c.ready} waiting for the queue`);
    } else if (c.running) {
      if (handoff && runningPid(root, s.step) === handoff && alive(handoff)) {
        // The old driver still supervises this session. Track it and start no second one.
        rec.state = 'running';
        rec.adopted = true;
        out(`I-C Run: Adopted: step ${s.step} runs under the old driver`);
      } else {
        rec.resume = true;
      }
    }
    if (!handoff) clearStopped(root, s.step);
  }
  // A driver that did not take over from another sweeps the worktrees of merged steps (0000501).
  if (!handoff) sweepMergedWorktrees(root, chart.steps, merged);

  const stop = { msg: '', log: null };
  const setStop = (msg, rec) => {
    if (stop.msg) return;
    stop.msg = msg;
    stop.log = rec ? rec.log : null;
    out(`I-C Run: Stopping: no new step starts after step ${rec ? rec.n : 'none'}`);
  };
  let queueBusy = false;
  let lastMerge = null;
  let handedOff = false;

  // Wakes the loop when a task ends. The flag keeps a wake that comes before the wait.
  let woken = false;
  let waiter = null;
  const notify = () => {
    woken = true;
    if (waiter) {
      const w = waiter;
      waiter = null;
      w();
    }
  };
  const wait = async (ms = 0) => {
    if (!woken) {
      await new Promise((r) => {
        waiter = r;
        if (ms > 0) {
          setTimeout(() => {
            if (waiter === r) {
              waiter = null;
              r();
            }
          }, ms);
        }
      });
    }
    woken = false;
  };

  // Tracks the steps that the old driver still runs. A ready file queues the step. A stopped file
  // stops new starts. A dead supervisor turns the step into a session restart.
  const pollAdopted = () => {
    for (const rec of recs.values()) {
      if (!rec.adopted || rec.state !== 'running') continue;
      const c = readControl(root, rec.n, rec.featureId);
      const stopped = readStopped(root, rec.n);
      if (c.ready) {
        rec.adopted = false;
        rec.state = 'ready';
        rec.pr = c.ready;
        readyOrder.push(rec.n);
        out(`I-D Advance: Ready: step ${rec.n} has PR #${c.ready} waiting for the queue`);
      } else if (stopped) {
        rec.adopted = false;
        rec.state = 'stopped';
        setStop(stopped, rec);
      } else if (!alive(handoff)) {
        rec.adopted = false;
        rec.state = 'pending';
        rec.resume = true;
      }
    }
  };
  const adopted = () => [...recs.values()].some((r) => r.adopted && r.state === 'running');

  const allMerged = () => chart.steps.every((s) => merged.has(s.step));
  const running = () => [...recs.values()].filter((r) => r.state === 'running').length;

  const startable = () => {
    if (stop.msg || handedOff) return [];
    const free = chart.concurrency - running();
    if (free <= 0) return [];
    const states = new Map();
    for (const r of recs.values()) {
      if (r.state === 'running' || r.state === 'ready') states.set(r.n, r.state);
      else if (r.state === 'stopped') states.set(r.n, 'stopped');
      else if (r.resume && r.state === 'pending') states.set(r.n, 'running');
    }
    const steps = chart.steps.map((s) => (merged.has(s.step) ? { ...s, status: 'merged' } : s));
    const resumes = chart.steps.map((s) => recs.get(s.step)).filter((r) => r && r.resume && r.state === 'pending');
    const fresh = readySteps(steps, states).map((s) => recFor(s));
    return [...resumes, ...fresh].slice(0, free);
  };

  const stepTask = async (rec) => {
    rec.state = 'running';
    rec.resume = false;
    try {
      rec.pr = await runScheduledStep(root, rec, cfg, rm);
      rec.state = 'ready';
      // After a handoff the successor reads the ready file and runs the queue.
      if (!handedOff) {
        readyOrder.push(rec.n);
        out(`I-D Advance: Ready: step ${rec.n} raised PR #${rec.pr}, waiting for the queue`);
      }
    } catch (e) {
      rec.state = 'stopped';
      const msg = e instanceof Stop ? e.message : `I-C Run: Blocked: driver error ${e.code || e.name}`;
      if (handedOff) writeStopped(root, rec.n, msg);
      setStop(msg, rec);
    } finally {
      notify();
    }
  };

  // Hands new starts and the queue to a successor driver (0000493, ADR-0323). Returns false, with
  // nothing changed, when the root cannot reach the merged ref or the successor does not start.
  const handOver = (n, files, target) => {
    if (!fastForwardRoot(root, branch, target)) return false;
    const pid = spawnSuccessor(root, process.pid);
    if (!pid) return false;
    try {
      writeFileSync(join(root, LOCK), `${pid}\n`);
    } catch {
      try {
        process.kill(pid);
      } catch {
        // Already gone.
      }
      return false;
    }
    lockPath = null;
    handedOff = true;
    // The successor reads the ready files itself.
    readyOrder.length = 0;
    out(`I-D Advance: Restart: step ${n} changed ${files}. A new driver took over new starts.`);
    return true;
  };

  const queueTask = async (rec) => {
    queueBusy = true;
    const n = rec.n;
    let log = null;
    try {
      log = appendLog(root, String(n));
      if (!rec.log) rec.log = { rel: log.rel, earlier: log.earlier };
      const blocked = (why) => {
        const stopped = new Stop(`I-D Advance: Blocked: queue stopped on step ${n}${why ? `. ${why.slice(0, MAX_LINE)}` : ''}`);
        stopped.queueFailure = true;
        return stopped;
      };
      let qdir;
      let before;
      try {
        removeWorktree(root, n);
        fetchBranch(root, branch);
        const ref = initiativeRef(root, branch);
        before = refHead(root, ref);
        qdir = prepareQueue(root, ref);
      } catch (e) {
        throw blocked(e instanceof Stop ? e.message : `${e.code || e.name}`);
      }
      const res = await runQueue(n, rec.pr, qdir, log.fd);
      if (res.error) throw blocked(`could not start the merge queue (${res.error})`);
      if (res.code !== 0) throw blocked(res.last);
      rec.state = 'merged';
      merged.add(n);
      mergeOrder.push(n);
      out(`I-D Advance: Complete: step ${n} merged`);
      removeControl(root, n);
      refresh();
      const after = refHead(root, initiativeRef(root, branch));
      lastMerge = { rec, before, after };
      // After the last merge the end runs the Setup check instead, as the serial path does.
      if (!allMerged()) {
        const hit = restartLine(root, n, before, after, branch);
        if (hit.line) {
          if (hit.handoff && !stop.msg && !handedOff && handOver(n, hit.files, after)) {
            rec.handedOver = true;
          } else {
            setStop(hit.line, rec);
          }
        }
      }
    } catch (e) {
      // One failed PR never holds back the other ready PRs (0000446). The failed step keeps its
      // ready file, so a new driver queues it again. The first stop line ends the run.
      rec.state = 'stopped';
      const msg = e instanceof Stop ? e.message : `I-C Run: Blocked: driver error ${e.code || e.name}`;
      // A queue failure prints at once and lands in the step log, so the watcher sees it (0000450).
      const announced = e instanceof Stop && e.queueFailure === true;
      if (announced) {
        out(msg);
        try {
          if (log) writeSync(log.fd, `${msg}\n`);
        } catch {
          // The line already reached stdout. A log write failure changes no stop.
        }
      }
      if (stop.msg) {
        if (!announced) out(msg);
      } else setStop(msg, rec);
    } finally {
      if (log) closeSync(log.fd);
      queueBusy = false;
      notify();
    }
  };

  for (;;) {
    if (handoff) pollAdopted();
    for (const rec of startable()) stepTask(rec);
    if (!queueBusy && !handedOff && readyOrder.length > 0) queueTask(recs.get(readyOrder.shift()));
    if (running() === 0 && !queueBusy && readyOrder.length === 0) break;
    await wait(adopted() ? 1000 : 0);
  }

  if (handedOff) {
    // The successor holds the lock and runs everything else. This driver ends with its sessions.
    if (stop.msg) {
      currentLog = stop.log ? stop.log.rel : null;
      earlierLogs = stop.log ? stop.log.earlier : [];
      throw new Stop(stop.msg);
    }
    out('I-D Advance: Restart: the old driver has no sessions left and is done');
    return;
  }

  const report = () => {
    for (const s of chart.steps) {
      const r = recs.get(s.step);
      const state = merged.has(s.step) ? 'merged' : r.state === 'pending' && r.resume ? 'running' : r.state;
      out(`I-C Run: Step ${s.step}: ${state}`);
    }
  };
  const stopWith = (msg, log) => {
    currentLog = log ? log.rel : null;
    earlierLogs = log ? log.earlier : [];
    return new Stop(msg);
  };
  if (stop.msg) {
    report();
    throw stopWith(stop.msg, stop.log);
  }
  if (!allMerged()) {
    report();
    const left = chart.steps.filter((s) => !merged.has(s.step)).length;
    throw stopWith(`I-C Run: Blocked: no step can start, ${left} steps are not merged`, null);
  }
  if (lastMerge) {
    // The last merge may have changed pack files that setup installs (0000373).
    const lastSetup = changedSetup(root, lastMerge.before, lastMerge.after);
    if (lastSetup.length > 0) {
      const done = approvedSetup(root, branch, chartText(root, initiativeRef(root, branch)), lastMerge.after, lastMerge.rec.n);
      if (done !== 'ran') {
        reportSteps(mergeOrder);
        throw stopWith(`I-D Advance: Setup: step ${lastMerge.rec.n} changed ${nameFiles(lastSetup)}. ${setupNote(done)}Rerun setup, then start a new driver.`, lastMerge.rec.log);
      }
    }
  }
  reportSteps(mergeOrder);
  if (delivered(root, id, slug)) out(`I-E Delivery: Complete: initiative ${id}-${slug} archived, driver done`);
  else out(`I-E Delivery: Pending: all ${chart.steps.length} steps merged, initiative delivery runs from the initiative skill`);
}

function reportSteps(ran) {
  for (const n of ran) out(`I-E Delivery: Complete: step ${n} merged`);
}

main().then(
  () => process.exit(0),
  (e) => {
    out(e instanceof Stop ? withLog(e.message) : `I-C Run: Blocked: driver error ${e.code || e.name}`);
    process.exit(1);
  },
);
