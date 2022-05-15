{ pkgs, config, ... }:
let
  secrets = (import ./secrets.nix);
  sources = (import /home/ij/.dotfiles/nix/sources.nix);
  ijohanne-nur = import sources.ijohanne-nur-packages { inherit pkgs; };
  interfaces = {
    external = "enp7s0";
    internal = "enp1s0f0";
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
      (import ./networking.nix { inherit interfaces; })
      ijohanne-nur.modules.prometheus-hue-exporter
      ijohanne-nur.modules.prometheus-netatmo-exporter
      ijohanne-nur.modules.prometheus-unpoller-exporter
      ijohanne-nur.modules.prometheus-nftables-exporter
      ijohanne-nur.modules.prometheus-tplink-p110-exporter
      ijohanne-nur.modules.multicast-relay
    ];

  nixpkgs.overlays = [
    (import "${sources.ijohanne-nur-packages}/overlay.nix")
  ];

  system.stateVersion = "21.05";
}
