{ pkgs, config, ... }:
let
  secrets = (import ./secrets.nix);
  sources = (import /home/ij/.dotfiles/nix/sources.nix);
  ijohanne-nur = import sources.ijohanne-nur-packages { inherit pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
      ./users.nix
      ./security.nix
      (import ./services { inherit secrets pkgs config; })
      ./networking.nix
      ijohanne-nur.modules.prometheus-hue-exporter
      ijohanne-nur.modules.prometheus-netatmo-exporter
      ijohanne-nur.modules.prometheus-unpoller-exporter
      ijohanne-nur.modules.prometheus-nftables-exporter
    ];

  nixpkgs.overlays = [
    (import "${sources.ijohanne-nur-packages}/overlay.nix")
  ];

  system.stateVersion = "21.05";
}
