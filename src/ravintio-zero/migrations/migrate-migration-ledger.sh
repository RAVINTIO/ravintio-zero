#!/usr/bin/env bash
# migrate-migration-ledger.sh - Copy the pack's _done/ records into the migration ledger.
# Idempotent: safe to run multiple times. It only appends rows and deletes nothing.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-migration-ledger.sh [PACK_VERSION]
# Without an argument, the version comes from ravintio-zero/component.yml.

set -euo pipefail

DONE_DIR="ravintio-zero/migrations/_done"
LEDGER_DIR="plan/state"
LEDGER="$LEDGER_DIR/migrations.md"

# Refuse a symlink at any path this helper writes through.
for p in "plan" "$LEDGER_DIR" "$LEDGER"; do
    if [ -L "$p" ]; then
        echo "ERROR: $p is a symlink. Refusing to continue. Nothing was written."
        echo "Replace the link with a real file or folder, then run this helper again."
        exit 1
    fi
done

version="${1:-}"
if [ -z "$version" ]; then
    if [ -f "ravintio-zero/component.yml" ]; then
        version="$(sed -nE 's/^version:[[:space:]]*["'\'']?([0-9]+\.[0-9]+\.[0-9]+)["'\'']?[[:space:]]*$/\1/p' ravintio-zero/component.yml | head -n 1)"
    fi
fi
if ! printf '%s' "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "ERROR: no pack version found in ravintio-zero/component.yml. Nothing was written."
    exit 1
fi

if [ ! -d "$DONE_DIR" ] || [ -L "$DONE_DIR" ]; then
    echo "Nothing to do: $DONE_DIR is not a folder."
    exit 0
fi

if [ ! -f "$LEDGER" ]; then
    mkdir -p "$LEDGER_DIR"
    {
        echo "# Migration ledger"
        echo
        echo "The migrator appends one row per migration. The result is \`done\` or \`not applicable\`."
        echo "The id is the four-digit migration number, or the file name without \`.md\` for an older file."
        echo "The pack version is the version when the row was written."
        echo
        echo "| Migration | Result | Pack version |"
        echo "|---|---|---|"
    } > "$LEDGER"
    echo "Created $LEDGER."
elif [ -s "$LEDGER" ] && [ -n "$(tail -c 1 "$LEDGER")" ]; then
    echo >> "$LEDGER"
fi

added=0
for f in "$DONE_DIR"/*.md; do
    [ -f "$f" ] || continue
    [ -L "$f" ] && continue
    stem="$(basename "$f" .md)"
    id="$stem"
    if printf '%s' "$stem" | grep -qE '^[0-9]{4}-'; then
        id="${stem%%-*}"
    fi
    if grep -qF "| $id |" "$LEDGER"; then
        echo "Skipped $id: already in the ledger."
        continue
    fi
    echo "| $id | done | $version |" >> "$LEDGER"
    echo "Added $id."
    added=$((added + 1))
done

echo "Done. Added $added row(s) to $LEDGER."
