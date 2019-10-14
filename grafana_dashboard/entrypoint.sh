#!/bin/sh

set -eu

readonly LIB=grafonnet-lib

cd "$(dirname "$0")"
for script in *.jsonnet; do
  fn=dashboard/${script//.jsonnet/.json}
  jsonnet -J "$LIB" "$script" -o "$fn"
  echo "Generated -> $fn"
done
