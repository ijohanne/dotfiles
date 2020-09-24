#!/usr/bin/env bash
cd $(dirname $0)
nix-shell --run "sudo nixos-rebuild -I nixos-config=/etc/nixos/configuration.nix $@"
