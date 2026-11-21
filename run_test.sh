#!/bin/sh
set -e
cd "$(dirname "$0")"
command -v nix-instantiate >/dev/null || . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
command -v nix-instantiate >/dev/null || { echo "nix not found, install it: https://nixos.org/download" >&2; exit 1; }
failed=$(nix-instantiate --eval -E 'builtins.length (import ./test.nix)')
[ "$failed" = 0 ] && echo "all tests passed!" || { nix-instantiate --eval --strict test.nix; echo "$failed failed!"; exit 1; }
