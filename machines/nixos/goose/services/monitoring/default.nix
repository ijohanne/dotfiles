{ pkgs, secrets, config, ... }:
{
  imports = [
    ./node.nix
    ./nftables.nix
    ./smokeping.nix
    (import ./unbound.nix { inherit config; })
    (import ./wireguard.nix { inherit config; })
    (import ./unpoller.nix { inherit pkgs secrets config; })
    (import ./hue.nix { inherit secrets; })
  ];
}
