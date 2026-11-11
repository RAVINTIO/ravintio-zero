# Fixture for the concurrent driver suites (0000379 REQ-002 to REQ-005).
#
# Source after assert.sh. Set WORK to a temporary folder first. The helpers build a real git repo
# with a bare origin, a stub claude, and a stub merge queue. Nothing reaches the network.
#
#   make_repo <name> <concurrency> <row>...   prints the root. Each row is "step|lane|after".
#   run_sched <root>                          runs the driver. Sets OUT and CODE.
#   origin_status <root> <step>               prints the step's Status on origin.
#
# The stub claude reads STUB_MODE_{n}. The modes are:
#   ready       writes the ready file at once
#   pair:M      waits up to 10 s for step M to start, notes the overlap, then writes ready
#   afterdone:M waits up to 10 s for step M to write ready, then writes ready
#   block       writes a Blocked: line to the step build log and exits 0
#   waitstop    waits up to 10 s for the driver's Stopping: line, then writes ready
#   none        exits 0 with no ready file and no session id
# It records its cwd, branch, and environment in $STUB_DIR/step-{n}.env.

BRANCH_NAME="initiative/0000050-demo"

_write_stubs() {
  mkdir -p "$WORK/bin"
  cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
last="${!#}"
[[ "$last" =~ step\ ([0-9]+) ]] && n="${BASH_REMATCH[1]}"
d="$STUB_DIR"
printf '%s\n' "$n" >> "$d/claude.log"
mkdir -p "$d/live"
touch "$d/live/$n"
trap 'rm -f "$d/live/$n"' EXIT
ls "$d/live" | wc -l | tr -d ' ' >> "$d/live.counts"
{
  echo "cwd=$(pwd -P)"
  echo "branch=$(git rev-parse --abbrev-ref HEAD)"
  echo "STEP=${RAVINTIO_INITIATIVE_STEP:-}"
  echo "QUEUE=${RAVINTIO_INITIATIVE_QUEUE:-}"
  echo "ROOT=${RAVINTIO_INITIATIVE_ROOT:-}"
  echo "CONTROL=${RAVINTIO_INITIATIVE_CONTROL:-}"
  echo "claude_dir=$([ -f .claude/settings.json ] && echo yes || echo no)"
  echo "claude_md=$([ -f CLAUDE.md ] && echo yes || echo no)"
  echo "queued_before=$(cut -d' ' -f1 "$d/queue.log" 2>/dev/null | tr '\n' ',')"
  echo "done_before=$(ls "$d" | grep -c '\.done$')"
} > "$d/step-$n.env"
touch "$d/$n.started"
wait_for() {
  local i
  for i in $(seq 100); do [ -e "$1" ] && return 0; sleep 0.1; done
  return 1
}
ready() {
  printf '%s\n' "$((100 + n))" > "$RAVINTIO_INITIATIVE_CONTROL/ready"
  touch "$d/$n.done"
  exit 0
}
v="STUB_MODE_$n"
mode="${!v:-ready}"
case "$mode" in
  ready) ready ;;
  pair:*) wait_for "$d/${mode#pair:}.started" && touch "$d/$n.overlap"; ready ;;
  afterdone:*) wait_for "$d/${mode#afterdone:}.done"; ready ;;
  block) printf 'Blocked: step %s cannot go on\n' "$n" >> plan/current/build-log.md; exit 0 ;;
  waitstop)
    for i in $(seq 100); do grep -q 'Stopping:' "$DRIVER_OUT" && break; sleep 0.1; done
    ready ;;
  none) exit 0 ;;
esac
STUB
  chmod +x "$WORK/bin/claude"

  cat > "$WORK/bin/queue.mjs" <<'STUB'
import { spawnSync } from 'node:child_process';
import { appendFileSync, existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
const a = process.argv.slice(2);
const opt = (k) => a[a.indexOf(k) + 1];
const step = opt('--step');
const pr = opt('--pr');
const root = opt('--root');
const d = process.env.STUB_DIR;
appendFileSync(join(d, 'queue.log'), `${step} ${pr}\n`);
const wt = join(process.env.STUB_ROOT, 'plan/.initiative-worktrees', `step-${step}`);
appendFileSync(join(d, 'queue-wt.log'), `${step} ${existsSync(wt) ? 'present' : 'gone'}\n`);
if ((process.env.QUEUE_FAIL_STEP || '').split(',').includes(step)) {
  console.error(`merge-queue: CI failed on PR #${pr}`);
  process.exit(1);
}
const B = 'initiative/0000050-demo';
const g = (...x) => {
  const r = spawnSync('git', ['-C', root, ...x], { encoding: 'utf8' });
  if (r.status !== 0) { console.error(`merge-queue: git ${x[0]} failed ${r.stderr}`); process.exit(1); }
  return r.stdout;
};
g('fetch', '--quiet', 'origin', B);
g('checkout', '--quiet', '--detach', `origin/${B}`);
const chart = join(root, 'plan/current-initiative/initiative.md');
const lines = readFileSync(chart, 'utf8').split('\n').map((l) => (l.startsWith(`| ${step} |`) ? l.replace('| pending |', '| merged |') : l));
writeFileSync(chart, lines.join('\n'));
if (process.env.QUEUE_RESTART_STEP === step) {
  mkdirSync(join(root, 'ravintio-zero/scripts'), { recursive: true });
  writeFileSync(join(root, 'ravintio-zero/scripts/initiative-run.mjs'), '// changed\n');
}
if (process.env.QUEUE_SETUP_STEP === step) {
  mkdirSync(join(root, 'ravintio-zero/skills'), { recursive: true });
  writeFileSync(join(root, 'ravintio-zero/skills/s.md'), 'changed\n');
}
g('add', '-A');
g('commit', '-q', '-m', `merge step ${step}`);
g('push', '-q', 'origin', `HEAD:refs/heads/${B}`);
console.log(`merged PR #${pr}`);
STUB
}

make_repo() {
  local name="$1" conc="$2"
  shift 2
  local base="$WORK/$name"
  local r="$base/root"
  mkdir -p "$base/stub" "$r"
  [ -x "$WORK/bin/claude" ] || _write_stubs
  git init -q --bare -b "$BRANCH_NAME" "$base/origin.git"
  git init -q -b "$BRANCH_NAME" "$r"
  git -C "$r" config user.email t@example.com
  git -C "$r" config user.name Test
  git -C "$r" config commit.gpgsign false
  mkdir -p "$r/plan/current-initiative" "$r/plan/current" "$r/.claude"
  printf '/.claude/\n/CLAUDE.md\n' > "$r/.gitignore"
  printf '{}\n' > "$r/.claude/settings.json"
  printf '# boot\n' > "$r/CLAUDE.md"
  : > "$r/plan/current/build-log.md"
  {
    printf '# Initiative: demo\n\n'
    printf '**Branch:** %s\n**Status:** active\n**Position:** 1\n' "$BRANCH_NAME"
    [ -n "$conc" ] && printf '**Concurrency:** %s\n' "$conc"
    printf '\n## Steps\n\n'
    printf '| Step | Feature id | Title | Bump | Version | Status | Lane | After |\n'
    printf '|------|------------|-------|------|---------|--------|------|-------|\n'
    local row step lane after
    for row in "$@"; do
      IFS='|' read -r step lane after <<< "$row"
      printf '| %s | 000005%s-s%s | Step %s | minor | | pending | %s | %s |\n' "$step" "$step" "$step" "$step" "$lane" "$after"
    done
    printf '\n## Notes\n\nNone.\n'
  } > "$r/plan/current-initiative/initiative.md"
  git -C "$r" add -A
  git -C "$r" commit -q -m chart
  git -C "$r" remote add origin "$base/origin.git"
  git -C "$r" push -q origin "$BRANCH_NAME"
  git -C "$r" fetch -q origin
  printf '%s' "$r"
}

run_sched() {
  local r="$1" base
  base="$(dirname "$r")"
  : > "$base/out.txt"
  (cd "$r" && PATH="$WORK/bin:$PATH" STUB_DIR="$base/stub" STUB_ROOT="$r" DRIVER_OUT="$base/out.txt" \
    MERGE_QUEUE_BIN="$WORK/bin/queue.mjs" node "$DRIVER" --root "$r" > "$base/out.txt" 2>"$base/err.txt")
  CODE=$?
  OUT="$(cat "$base/out.txt")"
}

origin_status() {
  git --git-dir="$(dirname "$1")/origin.git" show "$BRANCH_NAME:plan/current-initiative/initiative.md" \
    | awk -F'|' -v s="$2" '$2 + 0 == s { gsub(/ /, "", $7); print $7 }'
}

stub_env() {
  sed -n "s/^$3=//p" "$(dirname "$1")/stub/step-$2.env" 2>/dev/null
}
