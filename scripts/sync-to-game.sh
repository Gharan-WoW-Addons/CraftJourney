#!/usr/bin/env bash
# Copies the addon files into the game's AddOns folder, so that the game loads
# the working copy. A symbolic link would be simpler, but it breaks the game
# updates in Battle.net (issue #14).
#
# The working copy goes to its own "CraftJourney-dev" folder: the released
# version keeps the "CraftJourney" folder, and both stay installed side by
# side. Enable one of them at a time in the AddOns list of the game.
#
# Usage: scripts/sync-to-game.sh "<game folder>/_forever_/Interface/AddOns"
#
# Run it by hand, or on save with the Run on Save extension (see CONTRIBUTING.md).
set -euo pipefail

ADDON_NAME="CraftJourney"
DEV_NAME="$ADDON_NAME-dev"

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
target="$addons_dir/$DEV_NAME"

# The game only loads a folder with its .toc file: without it, nothing to copy.
if [[ ! -f "$repo_dir/$ADDON_NAME.toc" ]]; then
  echo "No $ADDON_NAME.toc in $repo_dir: nothing for the game to load, nothing copied." >&2
  exit 1
fi

if [[ -L "$target" ]]; then
  echo "$target is a symbolic link: remove it first (it breaks the Battle.net updates)." >&2
  exit 1
fi

# Everything the game does not need stays out of the AddOns folder. The .toc
# file is copied apart, under the name of the dev folder.
rsync --recursive --times --delete \
  --exclude="/$ADDON_NAME.toc" \
  --exclude="/$DEV_NAME.toc" \
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

# The game only loads a .toc file named after its folder. The "(dev)" suffix
# tells the two versions apart in the AddOns list.
sed -E 's/^(## Title(-[A-Za-z]+)?:.*)$/\1 (dev)/' "$repo_dir/$ADDON_NAME.toc" >"$target/$DEV_NAME.toc"

# macOS stores extended attributes as "._*" files on disks without native
# support (exFAT, FAT32): remove them from the addon folder.
if command -v dot_clean >/dev/null; then
  dot_clean -m "$target"
  rm -f "$addons_dir/._$DEV_NAME"
fi

echo "Synced $ADDON_NAME to $target"
