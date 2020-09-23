#!/usr/bin/env bash
cd $(dirname $0)
if [ -z "$1" ]; then
    echo "Missing argument for which machine to link to"
    exit 1;
fi
mkdir -p $HOME/.config/nixpkgs
ln -sf $HOME/.dotfiles/nixos/machines/$1/home.nix $HOME/.config/nixpkgs/home.nix
ln -sf $HOME/.dotfiles/nixos/machines/pkgs-config.nix $HOME/.config/nixpkgs/config.nix
nix-shell --run "home-manager switch"
