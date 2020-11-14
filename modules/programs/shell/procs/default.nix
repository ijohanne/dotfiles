{ pkgs, config, lib, ... }:
with lib;
{
  config = mkIf (config.dotfiles.shell.procs.enable) {
    home.packages = with pkgs; [ procs ];

    xdg.configFile = {
      "procs/config.toml".source = ../../../../configs/procs/config.toml;
    };
  };
}
