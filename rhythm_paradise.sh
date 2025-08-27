#!/bin/sh
echo -ne '\033c\033]0;rhythm_paradise\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/rhythm_paradise.arm64" "$@"
