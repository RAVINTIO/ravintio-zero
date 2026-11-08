#!/usr/bin/env bash
# migrate-retired-commands.sh - Remove the three retired pack commands.
# Idempotent: safe to run multiple times. It removes a file only if its front
# matter holds the matching "name:" line, so a developer's own command stays.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-retired-commands.sh

set -euo pipefail

DIR=".claude/commands"

for p in ".claude" "$DIR"; do
    if [ -L "$p" ]; then
        echo "ERROR: $p is a symlink. Refusing to continue. Nothing was removed."
        echo "Replace the link with a real folder, then run this helper again."
        exit 1
    fi
done

if [ ! -d "$DIR" ]; then
    echo "Nothing to do: $DIR is not a folder."
    exit 0
fi

removed=0
for name in fast-path change-pipeline retrofit; do
    f="$DIR/$name.md"
    [ -f "$f" ] || continue
    if [ -L "$f" ]; then
        echo "Skipped $f: symlink."
        continue
    fi
    if head -8 "$f" | grep -Eq "^name:[[:space:]]*$name[[:space:]]*"$'\r'"?$"; then
        rm -f "$f"
        echo "Removed $f."
        removed=$((removed + 1))
    else
        echo "Skipped $f: no matching name line, so it is not the pack command."
    fi
done

echo "Done. Removed $removed file(s)."
exit 0
