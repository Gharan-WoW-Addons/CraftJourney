#!/usr/bin/env bash
# Copies the addon files into the game's AddOns folder, so that the game loads
# the working copy. A symbolic link would be simpler, but it breaks the game
# updates in Battle.net (issue #14).
#
# Usage: scripts/sync-to-game.sh "<game folder>/_forever_/Interface/AddOns"
#
# Run it by hand, or on save with the Run on Save extension (see CONTRIBUTING.md).
set -euo pipefail

ADDON_NAME="CraftJourney"

addons_dir="${1:-}"
addons_dir="${addons_dir%/}"

# Safety net: rsync --delete removes from the target whatever is not in the
# repository, so the target must really be the AddOns folder of the game.
if [[ "$addons_dir" != */Interface/AddOns ]]; then
  echo "Usage: $0 \"<game folder>/_forever_/Interface/AddOns\"" >&2
  exit 1
fi
if [[ ! -d "$addons_dir" ]]; then
  echo "AddOns folder not found: $addons_dir" >&2
  exit 1
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="$addons_dir/$ADDON_NAME"

# The game only loads a folder with its .toc file: without it, nothing to copy.
if [[ ! -f "$repo_dir/$ADDON_NAME.toc" ]]; then
  echo "No $ADDON_NAME.toc in $repo_dir: nothing for the game to load, nothing copied." >&2
  exit 1
fi

if [[ -L "$target" ]]; then
  echo "$target is a symbolic link: remove it first (it breaks the Battle.net updates)." >&2
  exit 1
fi

# Everything the game does not need stays out of the AddOns folder.
rsync --recursive --times --delete \
  --exclude='.*' \
  --exclude='._*' \
  --exclude='lua_modules/' \
  --exclude='spec/' \
  --exclude='docs/' \
  --exclude='scripts/' \
  --exclude='*.md' \
  --exclude='LICENSE' \
  --exclude='stylua.toml' \
  --exclude='luacov.*' \
  "$repo_dir/" "$target/"

# macOS stores extended attributes as "._*" files on disks without native
# support (exFAT, FAT32): remove them from the addon folder.
if command -v dot_clean >/dev/null; then
  dot_clean -m "$target"
  rm -f "$addons_dir/._$ADDON_NAME"
fi

echo "Synced $ADDON_NAME to $target"
