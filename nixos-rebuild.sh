#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
nix-shell --run "sudo -E nixos-rebuild -I nixos-config=/etc/nixos/configuration.nix $(printf ' %q' "$@")"
