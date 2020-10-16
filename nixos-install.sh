#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
nix-shell --run "sudo -E nixos-install -I nixpkgs=$NIXPKGS_PATH $(printf ' %q' "$@")"
