#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
if [ -z "$1" ]; then
	echo "Missing argument for which type machine to link to"
	exit 1
fi
if [ -z "$2" ]; then
	echo "Missing argument for which machine to link to"
	exit 1
fi
mkdir -p "$HOME/.config/nixpkgs"
ln -sf "$HOME/.dotfiles/machines/$1/$2/home.nix" "$HOME/.config/nixpkgs/home.nix"
nix-shell --run "home-manager switch"
