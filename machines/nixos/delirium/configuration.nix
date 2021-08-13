{ config, pkgs, lib, ... }:

let
  secrets = (import ./secrets.nix);
  pr_119719 = builtins.fetchTarball {
    name = "nixos-pr_119719";
    url = "https://api.github.com/repos/greizgh/nixpkgs/tarball/seafile";
    sha256 = "1xs075sh741ra2479id9q3yms93v3i0j1rfmvxvc563wbxdpfs7r";
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      (builtins.fetchTarball {
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.05/nixos-mailserver-nixos-21.05.tar.gz";
        sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
      })
      (import (./mail.nix) { inherit secrets config pkgs lib; })
      (import (./seafile.nix) { inherit secrets config pkgs lib; })
      (import (./martin8412.nix) { inherit secrets config pkgs lib; })
      ./users.nix
      ./networking.nix
      ./services.nix
      ./security.nix
      ./boot.nix
      ./common.nix
    ];
  system.stateVersion = "21.05";
}
