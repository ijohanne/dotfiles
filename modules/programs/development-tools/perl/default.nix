{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.perl;
in
{
  config = mkIf (cfg.enable)
    {
      home.packages = with pkgs; [ perl ];
    };
}
