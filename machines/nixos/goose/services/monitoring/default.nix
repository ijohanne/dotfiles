{ pkgs, secrets, config, ... }:
{
  imports = [
    ./node.nix
    ./nftables.nix
    ./unbound.nix
    ./smokeping.nix
    (import ./unpoller.nix { inherit pkgs secrets config; })
  ];
}
