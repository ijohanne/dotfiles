{ pkgs, config, ... }:
let
  secrets = (import ./secrets.nix);
  sources = (import /home/ij/.dotfiles/nix/sources.nix);
  ijohanne-nur = import sources.ijohanne-nur-packages { inherit pkgs; };
  interfaces = {
    external = "enp5s0d1";
    internal = "enp5s0";
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
      ./users.nix
      ./security.nix
      (import ./services { inherit secrets pkgs config interfaces; })
      (import ./networking.nix { inherit interfaces pkgs; })
      ijohanne-nur.modules.prometheus-hue-exporter
      ijohanne-nur.modules.prometheus-netatmo-exporter
      ijohanne-nur.modules.prometheus-unpoller-exporter
      ijohanne-nur.modules.prometheus-nftables-exporter
      ijohanne-nur.modules.prometheus-tplink-p110-exporter
      ijohanne-nur.modules.prometheus-ipmi-exporter
      ijohanne-nur.modules.multicast-relay
    ];

  nixpkgs.overlays = [
    (import "${sources.ijohanne-nur-packages}/overlay.nix")
  ];

  system.stateVersion = "22.05";
}
