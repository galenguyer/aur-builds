#!/usr/bin/env bash
_scriptname="$(basename $0)"

function log() {
        echo "[$_scriptname] $@"
}

if [[ -z $1 ]]; then
        log "no package given"
        exit 1
fi

_pkg="$1"
_basename="$(basename $_pkg)"

log "signing $_basename"
gpg --detach-sign --no-armor --batch --output "$_pkg.sig" "$_pkg"

log "adding $_basename to repo"
cp -v "$_pkg"* $HOME/pub/
repo-add -s pub/aur-builds.db.tar.zst pub/"$_basename"
