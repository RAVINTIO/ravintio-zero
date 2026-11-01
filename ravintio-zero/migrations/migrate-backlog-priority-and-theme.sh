#!/usr/bin/env bash
# migrate-backlog-priority-and-theme.sh - Add default priority and theme to backlog entries.
# Idempotent: safe to run multiple times. It adds each key only when it is absent.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-backlog-priority-and-theme.sh

set -euo pipefail

BACKLOG="plan/backlog"
INDEX_SCRIPT="ravintio-zero/scripts/backlog-index.mjs"

# Refuse a symlink at any path this helper writes through.
for p in "plan" "$BACKLOG"; do
    if [ -L "$p" ]; then
        echo "ERROR: $p is a symlink. Refusing to continue. Nothing was written."
        echo "Replace the link with a real folder, then run this helper again."
        exit 1
    fi
done

if [ ! -d "$BACKLOG" ]; then
    echo "Nothing to do: $BACKLOG is not a folder."
    exit 0
fi

changed=0
for f in "$BACKLOG"/*/entry.md; do
    [ -f "$f" ] || continue
    if [ -L "$f" ] || [ -L "$(dirname "$f")" ]; then
        echo "Skipped $f: symlink."
        continue
    fi
    tmp="$(mktemp)"
    # Insert the missing keys before the closing rule of the first frontmatter block.
    # A CR before the newline is kept on the new lines. Other lines pass through.
    awk '
        BEGIN { state = 0 }
        {
            line = $0
            if (state == 0) {
                if (NR == 1 && line ~ /^---\r?$/) { state = 1 } else { state = 3 }
                print line; next
            }
            if (state == 1) {
                if (line ~ /^---\r?$/) {
                    cr = (line ~ /\r$/) ? "\r" : ""
                    if (!hasp) print "priority: \"medium\"" cr
                    if (!hast) print "theme: \"unsorted\"" cr
                    state = 2
                } else {
                    if (line ~ /^priority:/) hasp = 1
                    if (line ~ /^theme:/) hast = 1
                }
            }
            print line
        }
        END { if (state == 1) exit 2 }
    ' "$f" > "$tmp" || { rm -f "$tmp"; echo "Skipped $f: frontmatter is not closed."; continue; }
    # Keep a missing final newline missing.
    if [ -s "$f" ] && [ -n "$(tail -c 1 "$f")" ]; then
        size="$(wc -c < "$tmp")"
        head -c "$((size - 1))" "$tmp" > "$tmp.n" && mv "$tmp.n" "$tmp"
    fi
    if cmp -s "$f" "$tmp"; then
        rm -f "$tmp"
        continue
    fi
    cat "$tmp" > "$f"
    rm -f "$tmp"
    echo "Updated $f."
    changed=$((changed + 1))
done

echo "Done. Updated $changed entry file(s)."

if [ -f "$INDEX_SCRIPT" ]; then
    echo "Regenerating the backlog index."
    if ! node "$INDEX_SCRIPT"; then
        echo "ERROR: $INDEX_SCRIPT failed. The entries are updated. Fix the cause and run it again."
        exit 1
    fi
fi
exit 0
