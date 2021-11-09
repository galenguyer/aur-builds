#!/bin/bash
source ./constants.sh

export PACKAGE_LIST="yay"

sudo pacman -Syu
aur sync --sign -A --noconfirm --noview --database "$REPO_NAME" --root "$REPO_ROOT" "$PACKAGE_LIST"
