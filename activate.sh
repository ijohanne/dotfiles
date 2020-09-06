#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "Missing argument for which machine to link to"
    exit 1;
fi
mkdir -p $HOME/.config/nixpkgs
ln -s $HOME/.dotfiles/nixos/home/$1.nix $HOME/.config/nixpkgs/home.nix
ln -s $HOME/.dotfiles/nixos/home/config.nix $HOME/.config/nixpkgs/config.nix
nix-shell --run "home-manager switch"
