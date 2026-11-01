/**
 * Hook launcher (0000316 ADR-001).
 *
 * Usage: node guard-run.mjs <guard|advisory> <script>.mjs
 *
 * Setup wires every Claude Code hook through this file, so the command reads
 * the project root from CLAUDE_PROJECT_DIR and the working directory plays no
 * part. The launcher finds <script> beside itself and runs it with the same
 * stdin, stdout, and stderr.
 *
 * Guard mode fails closed. Claude Code treats exit 1 as a non-blocking error,
 * so a guard that cannot load or that crashes would allow the tool call. Here
 * a missing script, a spawn error, a signal, and any exit code other than 0
 * and 2 all become exit 2, with one stderr line that names the script. Exit 0
 * and exit 2 from the script pass through.
 *
 * Advisory mode never blocks. A missing script exits 0 and prints one stderr
 * line, once for each script and project. Any other result passes through.
 */
import { spawnSync } from "node:child_process";
import { createHash } from "node:crypto";
import { existsSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { tmpdir } from "node:os";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const [mode, script] = process.argv.slice(2);

function failGuard(reason) {
  process.stderr.write(`[RAVINTIO] guard-run: ${reason} Blocking, because a guard that cannot run must not allow the call. Rerun setup.\n`);
  process.exit(2);
}

if (mode !== "guard" && mode !== "advisory") {
  failGuard("the mode is not guard or advisory.");
}
if (typeof script !== "string" || !/^[A-Za-z0-9._-]+\.mjs$/.test(script) || script.startsWith(".")) {
  if (mode === "guard") failGuard(`the script name ${JSON.stringify(script ?? "")} is not a plain .mjs file name.`);
  process.exit(0);
}

const target = join(here, script);

if (!existsSync(target)) {
  if (mode === "guard") failGuard(`the hook script ${script} is missing from ${here}.`);
  const marker = join(
    tmpdir(),
    `ravintio-hook-missing-${createHash("sha256").update(target).digest("hex").slice(0, 16)}`,
  );
  if (!existsSync(marker)) {
    try { writeFileSync(marker, "reported\n"); } catch { /* report anyway */ }
    process.stderr.write(`[RAVINTIO] guard-run: the advisory hook script ${script} is missing from ${here}. Rerun setup. This line prints once.\n`);
  }
  process.exit(0);
}

const result = spawnSync(process.execPath, [target], { stdio: "inherit" });

if (mode === "advisory") {
  process.exit(typeof result.status === "number" ? result.status : 0);
}
if (result.status === 0 || result.status === 2) process.exit(result.status);
if (result.error) failGuard(`the guard ${script} did not start (${result.error.code ?? "spawn error"}).`);
if (result.signal) failGuard(`the guard ${script} ended on signal ${result.signal}.`);
failGuard(`the guard ${script} exited with exit ${result.status}.`);
