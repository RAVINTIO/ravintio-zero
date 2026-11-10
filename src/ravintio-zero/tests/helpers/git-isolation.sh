#!/usr/bin/env bash
# Git isolation for the test runners (0000462, ADR-0301).
#
# isolate_git_env gives every git process that the caller starts a global config
# that holds no identity and refuses to guess one. A suite that commits with no
# identity then fails on a developer machine, as it does on a CI runner.
#
# It exports GIT_CONFIG_GLOBAL for a temporary file, sets GIT_CONFIG_NOSYSTEM,
# and unsets the author, committer, and EMAIL variables. It sets
# GIT_ISOLATION_CONFIG to the temporary file. The caller removes that file on
# exit with remove_git_isolation.

isolate_git_env() {
  GIT_ISOLATION_CONFIG="$(mktemp "${TMPDIR:-/tmp}/ravintio-gitconfig.XXXXXX")"
  printf '[user]\n\tuseConfigOnly = true\n' > "$GIT_ISOLATION_CONFIG"
  export GIT_ISOLATION_CONFIG GIT_CONFIG_GLOBAL="$GIT_ISOLATION_CONFIG" GIT_CONFIG_NOSYSTEM=1
  unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_AUTHOR_DATE
  unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_COMMITTER_DATE EMAIL
}

remove_git_isolation() {
  [ -n "${GIT_ISOLATION_CONFIG:-}" ] && rm -f "$GIT_ISOLATION_CONFIG"
  return 0
}
