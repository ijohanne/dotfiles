{ pkgs, config, lib, secrets }:
{
  imports = [
    (import ./docker.nix { inherit secrets config pkgs; })
    (import ./dovecot2.nix { inherit secrets config pkgs; })
    (import ./gitea.nix { inherit secrets config pkgs; })
    (import ./matrix-synapse.nix { inherit secrets config pkgs; })
    (import ./mariadb.nix { inherit secrets config pkgs; })
    (import ./nginx.nix { inherit secrets config pkgs; })
    (import ./node.nix { inherit secrets config pkgs; })
    (import ./postfix.nix { inherit secrets config pkgs; })
    (import ./postgres.nix { inherit secrets config pkgs; })
    (import ./redis.nix { inherit secrets config pkgs; })
    (import ./rspamd.nix { inherit secrets config pkgs; })
    (import ./smokeping.nix { inherit secrets config pkgs; })
    (import ./systemd.nix { inherit secrets config pkgs; })
    (import ./teamspeak3.nix { inherit secrets config pkgs; })
  ];
}
