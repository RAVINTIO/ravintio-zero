#!/usr/bin/env bash
# Brand guard (0000394 ADR-001): flags tracked files that use the retired
# product name outside the shared allowlist.
#
# Usage: brand-guard.sh [--root DIR] [--allowlist FILE] < paths
#   Reads repo-relative paths on stdin. Prints "path:line" for each line that
#   names the word and no allowlist entry covers, and "path" for each path that
#   names it. Exits 1 on any hit.
#
# The allowlist file is ravintio-zero/tests/brand-guard-allowlist.txt. The CI
# test test-0000160-req-006-brand-guard.sh sources this file and calls
# brand_guard_load, so the hook and CI read one list.
#
# The two allowlist files name the word in their own rows, so the guard skips
# them by exact path in brand_guard_skips_path. The allowlist holds no row for them.
#
# This source joins the word from two halves, so a scan does not match it.

BG_TAB=$'\t'
BG_WORD="plani""fest"

# brand_guard_load <file>: fills ALLOWLIST and EXCLUDED_PREFIXES.
brand_guard_load() {
  local file="$1" line
  ALLOWLIST=()
  EXCLUDED_PREFIXES=()
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*) continue ;;
      '!'*) EXCLUDED_PREFIXES+=("${line#!}") ;;
      *) ALLOWLIST+=("$line") ;;
    esac
  done < "$file"
}

# brand_guard_skips_path <path>: returns 0 for the two allowlist files, by exact
# path (ADR-0298). The names are fixed strings, not patterns, and no allowlist
# row can add to them. The hook and the CI test both call this function.
brand_guard_skips_path() {
  case "$1" in
    src/ravintio-zero/tests/brand-guard-allowlist.txt) return 0 ;;
    ravintio-zero/tests/brand-guard-allowlist.txt) return 0 ;;
  esac
  return 1
}

brand_guard_main() {
  local root="" allow="" arg path prefix skip hit num text entry path_re line_re ok rc=0
  while [ "$#" -gt 0 ]; do
    arg="$1"
    case "$arg" in
      --root) root="$2"; shift 2 ;;
      --allowlist) allow="$2"; shift 2 ;;
      *) echo "brand-guard: unknown argument $arg" >&2; return 2 ;;
    esac
  done
  [ -n "$root" ] || root="$(git rev-parse --show-toplevel)"
  if [ -z "$allow" ]; then
    # The pack source lives at src/ravintio-zero/. A consumer install keeps ravintio-zero/.
    allow="$root/src/ravintio-zero/tests/brand-guard-allowlist.txt"
    [ -f "$allow" ] || allow="$root/ravintio-zero/tests/brand-guard-allowlist.txt"
  fi
  if [ ! -f "$allow" ]; then
    echo "brand-guard: allowlist not found at $allow" >&2
    return 2
  fi
  brand_guard_load "$allow"

  while IFS= read -r path; do
    [ -n "$path" ] || continue
    brand_guard_skips_path "$path" && continue
    skip=0
    for prefix in "${EXCLUDED_PREFIXES[@]}"; do
      case "$path" in "$prefix"*) skip=1; break ;; esac
    done
    [ "$skip" -eq 0 ] || continue
    if printf '%s\n' "$path" | grep -qi -- "$BG_WORD"; then
      echo "$path"
      rc=1
    fi
    [ -f "$root/$path" ] || continue
    while IFS= read -r hit; do
      [ -n "$hit" ] || continue
      num="${hit%%:*}"
      text="${hit#*:}"
      ok=1
      for entry in "${ALLOWLIST[@]}"; do
        path_re="${entry%%"$BG_TAB"*}"
        line_re="${entry#*"$BG_TAB"}"
        if [[ "$path" =~ $path_re ]] && [[ "$text" =~ $line_re ]]; then ok=0; break; fi
      done
      if [ "$ok" -ne 0 ]; then
        echo "$path:$num"
        rc=1
      fi
    done <<< "$(grep -inI -- "$BG_WORD" "$root/$path" 2>/dev/null)"
  done
  return "$rc"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  brand_guard_main "$@"
  exit $?
fi
