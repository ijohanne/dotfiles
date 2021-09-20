{ pkgs, secrets, config, ... }:
{
  imports = [
    ./node.nix
    ./nftables.nix
    ./unbound.nix
    ./smokeping.nix
    ./wireguard.nix
    (import ./unpoller.nix { inherit pkgs secrets config; })
    (import ./hue.nix { inherit pkgs secrets config; })
  ];
}
