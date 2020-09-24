{ config, sources ? import ../../nixpkgs, pkgs ? import sources.nixpkgs { }, ... }:

{
  networking.networkmanager.enable = true;
}
