#!/usr/bin/env bash
cd $(dirname $0)
nix-shell --run "home-manager switch"
