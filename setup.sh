#!/bin/bash
source ./constants.sh

echo "updating packages..."
sudo pacman -Syyu --noconfirm
sudo pacman -S base base-devel git --noconfirm

echo "building aurutils..."
cd /tmp
curl --output aurutils.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/aurutils.tar.gz
tar xf aurutils.tar.gz
cd aurutils
makepkg --syncdeps --noconfirm
mkdir -p "$REPO_ROOT"
sudo pacman -U --noconfirm aurutils-*.pkg.tar.zst
repo-add "$REPO_ROOT/$REPO_NAME.db.tar.zst"
