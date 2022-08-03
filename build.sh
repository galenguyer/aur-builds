#!/usr/bin/env bash
source ./constants.sh

readonly PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
readonly XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
readonly AURDEST=${AURDEST:-$XDG_CACHE_HOME/aurutils/sync}
readonly AURVCS=${AURVCS:-".*-(cvs|svn|git|hg|bzr|darcs)"}

export PACKAGE_LIST="$(cat packages | grep -Pv '^#')"

TMPDIR="$(mktemp -d)"
function cleanup {
        rm -rf "$TMPDIR"
}
trap cleanup EXIT

sudo pacman --noconfirm -Syu
aur sync \
        --sign \
        --ignore-arch \
        --remove \
        --noconfirm \
        --noview \
        --database "$REPO_NAME" \
        --root "$REPO_ROOT" \
        $PACKAGE_LIST

cd "$AURDEST"

aur repo --list | grep -E $AURVCS > "$TMPDIR/local"
aur repo --list | grep -E $AURVCS | cut -f1 | xargs -r aur srcver > "$TMPDIR/vcs"
aur vercmp -p "$TMPDIR/vcs" < "$TMPDIR/local" | cut -d\  -f1 > "$TMPDIR/updates"

if [[ "$(cat $TMPDIR/updates | wc -l)" -gt 0 ]]; then
        xargs -a "$TMPDIR/updates" aur sync \
                --sign \
                --ignore-arch \
                --remove \
                --noconfirm \
                --noview \
                --no-ver-argv \
                --database "$REPO_NAME" \
                --root "$REPO_ROOT"
fi
