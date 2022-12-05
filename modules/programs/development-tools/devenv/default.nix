{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.devenv;
in
{
  config = mkIf (cfg.enable) {
    home.packages = [ (import pkgs.niv-sources.devenv).default ];
  };
}
