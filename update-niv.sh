#!/usr/bin/env bash
cd $(dirname $0)
nix-shell --run "( cd nixos/home && niv update )"
