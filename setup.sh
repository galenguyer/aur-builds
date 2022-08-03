#!/usr/bin/env bash
source ./constants.sh

echo "updating packages..."
sudo pacman -Syu --needed --noconfirm
sudo pacman -S base base-devel git --needed --noconfirm

echo "building aurutils..."
cd /tmp
git clone https://aur.archlinux.org/aurutils.git
cd aurutils
makepkg --syncdeps --noconfirm
mkdir -p "$REPO_ROOT"
sudo pacman -U --noconfirm aurutils-*.pkg.tar.zst
repo-add -s "$REPO_ROOT/$REPO_NAME.db.tar.zst"
