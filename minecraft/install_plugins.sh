#!/bin/bash

set -eu

cd "$(dirname "$0")"

readonly PLUGINS=(
  "https://github.com/HimaJyun/ChestSafe/releases/download/1.1.2/ChestSafe-1.1.2.jar"
  "https://media.forgecdn.net/files/2766/440/SetHomes.jar"
  "https://media.forgecdn.net/files/913/166/multiworld.jar"
  "https://media.forgecdn.net/files/909/154/PermissionsEx-1.23.4.jar"
)

readonly PLUGINS_DIR=opt/minecraft/data/plugins

for url in "${PLUGINS[@]}"; do
  filename="$(sed -E "s@^.*/@@g" <<< "$url")"
  filepath="$PLUGINS_DIR/$filename"
  wget --tries 3 -qO "$filepath" "$url"
  echo -e "[ \x1b[32mOK\x1b[m ] Installing => $filepath"
done
