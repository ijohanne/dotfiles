{ pkgs, secrets, config, ... }:
{
  imports = [
    ./node.nix
    ./nftables.nix
    ./smokeping.nix
    ./zfs.nix
    ./nut.nix
    ./ipmi.nix
    (import ./unbound.nix { inherit config; })
    (import ./wireguard.nix { inherit config; })
    (import ./unpoller.nix { inherit pkgs secrets config; })
    (import ./hue.nix { inherit secrets; })
    (import ./netatmo.nix { inherit secrets; })
    (import ./telegraf.nix { inherit secrets; })
    (import ./tplink-p110.nix { inherit secrets; })
  ];
}
