#!/usr/bin/env node
// Exits 1 when the newest commit of a ref is a squashed initiative PR.
// Usage: node check-main-merge.mjs [--root dir] [--ref ref]
// Exit codes: 0 clean, 1 squash found, 2 usage or git error.
// A merge commit has two parents. A squash has one and a titled subject.
// Reads git only and keeps no state.
import { execFileSync } from 'node:child_process';

const MERGE_SUBJECT = /^Merge pull request #\d+ from [^/\s]+\/initiative\//;
const TITLED = /^\d{7}-[a-z0-9-]+: .+ \(#\d+\)\s*$/;

const args = process.argv.slice(2);
let root = process.cwd();
let ref = 'HEAD';
for (let i = 0; i < args.length; i += 2) {
  if (args[i] === '--root' && args[i + 1]) root = args[i + 1];
  else if (args[i] === '--ref' && args[i + 1]) ref = args[i + 1];
  else {
    console.error('check-main-merge: usage: check-main-merge.mjs [--root dir] [--ref ref]');
    process.exit(2);
  }
}

let parents;
let subject;
let body;
try {
  const git = (...a) => execFileSync('git', ['-C', root, ...a], { encoding: 'utf8' });
  parents = git('rev-list', '--parents', '-n', '1', ref).trim().split(/\s+/).length - 1;
  subject = git('log', '-1', '--format=%s', ref).trim();
  body = git('log', '-1', '--format=%b', ref);
} catch {
  console.error('check-main-merge: cannot read git history');
  process.exit(2);
}

const bullets = body.split(/\r?\n/).map((l) => l.replace(/^\s*[-*]\s+/, ''));
const titled = [subject, ...bullets].some((l) => TITLED.test(l));
const fromInitiative = MERGE_SUBJECT.test(subject) || (parents === 1 && titled);

if (fromInitiative && parents === 1) {
  console.error(`check-main-merge: ${ref} is a squash of an initiative PR. Use a merge commit.`);
  process.exit(1);
}
process.exit(0);
