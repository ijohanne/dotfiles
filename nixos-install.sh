#!/usr/bin/env bash
cd $(dirname $0)
nix-shell --run "sudo -E nixos-install -I nixpkgs=$NIXPKGS_PATH $@"
