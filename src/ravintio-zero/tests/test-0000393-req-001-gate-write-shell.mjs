import { spawnSync } from "node:child_process";
import { join } from "node:path";
import { GATE_WRITE, check, makeProject, finish } from "./helpers/gate-write-harness.mjs";

function bash(cwd, command) {
  const r = spawnSync("node", [GATE_WRITE], {
    input: JSON.stringify({ cwd, tool_name: "Bash", tool_input: { command } }),
    encoding: "utf8",
  });
  return r.status ?? 1;
}

console.log("\n=== REQ-001: gate-write checks shell writes ===");

const none = makeProject();
const dsg = makeProject({ design: true });
const sen = makeProject({ design: true, sentinel: true });

check(2, bash(none, "cat > src/comp/x.js <<'EOF'\nhello\nEOF\n"), "AC-1 req-001 heredoc redirect with no design exits 2");
check(0, bash(none, "cat > plan/backlog/x/entry.md <<'EOF'\n> quoted line\nbody\nEOF\n"), "AC-2 req-001 heredoc to plan/backlog with a > body line exits 0");
check(2, bash(none, "echo x | tee src/comp/y"), "req-001 tee target with no design exits 2");
check(2, bash(none, "sed -i 's/a/b/' src/comp/y"), "req-001 sed -i target with no design exits 2");
check(2, bash(none, "sed -ni 's/a/b/p' src/comp/y"), "req-001 sed -ni target with no design exits 2");
check(2, bash(none, "sed --in-place=.bak -e 's/a/b/' src/comp/y"), "req-001 sed --in-place target with no design exits 2");
check(0, bash(none, "sed -i '' 's/a/b/' plan/x"), "req-001 macOS sed -i '' on plan/x exits 0");
check(0, bash(none, "sed 's/a/b/' src/comp/y"), "req-001 sed without in-place flag exits 0");
check(0, bash(none, "echo hi > /dev/null"), "req-001 redirect to /dev/null exits 0");
check(0, bash(none, "cmd 2>&1"), "req-001 fd duplication exits 0");
check(0, bash(none, "cmd >&2"), "req-001 redirect to stderr duplicate exits 0");
check(2, bash(none, "cmd 2>src/comp/err"), "req-001 fd-prefixed redirect is a target and exits 2");
check(2, bash(none, "echo a >> src/comp/log"), "req-001 append redirect exits 2");
check(2, bash(none, "ls && echo a > src/comp/z"), "req-001 redirect after && exits 2");
check(0, bash(dsg, "cat > src/comp/x"), "req-001 design covering src/comp lets redirect pass");
check(2, bash(dsg, "cat > other/x"), "req-001 target outside component paths exits 2");
check(2, bash(none, "echo a > plan/current/x.md"), "req-001 plan/current without sentinel exits 2");
check(0, bash(sen, "echo a > plan/current/x.md"), "req-001 plan/current with sentinel exits 0");
check(0, bash(none, 'cat > "$OUT"'), "req-001 variable target passes");
check(0, bash(none, "cat > `mktemp`"), "req-001 backtick target passes");
check(0, bash(none, 'echo "a > b"'), "req-001 quoted > passes");
check(0, bash(none, "echo 'a > src/comp/b'"), "req-001 single-quoted redirect passes");
check(0, bash(none, "ls -la"), "req-001 command without writes passes");
check(0, bash(none, "echo 'unterminated > src/comp/x"), "req-001 unterminated quote does not block");

console.log("\n=== REQ-001: Write and Edit stay as before ===");
function write(cwd, target) {
  return spawnSync("node", [GATE_WRITE], {
    input: JSON.stringify({ cwd, tool_name: "Write", tool_input: { file_path: target } }),
    encoding: "utf8",
  }).status ?? 1;
}
check(2, write(none, join(none, "src", "comp", "a.js")), "req-001 Write with no design still exits 2");
check(0, write(dsg, join(dsg, "src", "comp", "a.js")), "req-001 Write covered by design still exits 0");
finish();
