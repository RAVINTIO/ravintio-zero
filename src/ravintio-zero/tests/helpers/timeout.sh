#!/usr/bin/env bash
# Portable time limit for a test command (0000380 ADR-002).
# macOS has no timeout command, so this helper uses perl alarm and falls back
# to a Bash watchdog when perl is absent. It runs external commands only.
#
# Usage: with_timeout <seconds> <command> [args...]
# Exit:  124 when the limit stops the command, otherwise the command's own code.
# Set RAVINTIO_TIMEOUT_NO_PERL=1 to force the Bash watchdog.

with_timeout() {
  local secs="$1" rc
  shift
  if [ "${RAVINTIO_TIMEOUT_NO_PERL:-0}" != "1" ] && command -v perl >/dev/null 2>&1; then
    perl -e 'alarm shift; exec @ARGV or exit 127' "$secs" "$@"
    rc=$?
    # SIGALRM ends the command with status 128 + 14.
    [ "$rc" -eq 142 ] && rc=124
    return "$rc"
  fi
  local flag pid wd
  flag="$(mktemp "${TMPDIR:-/tmp}/with-timeout.XXXXXX")"
  rm -f "$flag"
  "$@" &
  pid=$!
  (
    i=0
    while [ "$i" -lt "$secs" ] && kill -0 "$pid" 2>/dev/null; do
      sleep 1
      i=$((i + 1))
    done
    if kill -0 "$pid" 2>/dev/null; then
      : > "$flag"
      kill "$pid" 2>/dev/null
    fi
  ) >/dev/null 2>&1 &
  wd=$!
  wait "$pid" 2>/dev/null
  rc=$?
  kill "$wd" 2>/dev/null
  wait "$wd" 2>/dev/null
  if [ -e "$flag" ]; then
    rm -f "$flag"
    return 124
  fi
  return "$rc"
}
