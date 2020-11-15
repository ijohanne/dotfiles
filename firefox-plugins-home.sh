#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
nix-shell --run "nixpkgs-firefox-addons $HOME/.dotfiles/modules/overlays/localpkgs/firefox-plugins/addons.json \
        $HOME/.dotfiles/modules/overlays/localpkgs/firefox-plugins/default.nix"
