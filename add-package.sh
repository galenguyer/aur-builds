#!/usr/bin/env bash
set -euo pipefail

_script="$0"
_package="$1"

function log() {
        echo "[$(basename $_script)] $@"
}

if grep -qP '^'"$_package"'$' packages; then
        log "package list already contains $_package"
        exit 0
fi
if grep -qP '^#'"$_package"'$' packages; then
        log "package list already contains $_package but it is disabled"
        exit 0
fi

echo "$_package" >> packages

_tmpfile="$(mktemp)"
cat "packages" | sort > "$_tmpfile"
cp "$_tmpfile" "packages"

log "added $_package to package list"
