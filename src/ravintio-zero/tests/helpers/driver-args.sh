# Holds the arguments that initiative-run.mjs passes to claude, so a driver flag change edits
# this file and not each driver suite (0000354 REQ-004).

# Prints the fixed argument prefix.
driver_args_prefix() {
  printf '%s' '-p --output-format stream-json --verbose --permission-mode auto --append-system-prompt Write all prose to ravintio-zero/standards/writing-standards.md.'
}

# driver_args <model> <max-turns or ""> <prompt words...>: prints the full argument line the
# stub claude logs for a step.
driver_args() {
  local model="$1" turns="$2"
  shift 2
  local line
  line="$(driver_args_prefix) --model $model"
  [ -n "$turns" ] && line="$line --max-turns $turns"
  printf '%s %s' "$line" "$*"
}
