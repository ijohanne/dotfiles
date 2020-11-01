{ pkgs, config, lib, ... }:
with lib;
let dots = "${config.home.homeDirectory}/.dotfiles";
in {
  config = mkIf (config.dotfiles.shell.procs.enable) {
    home.packages = with pkgs; [ procs ];

    xdg.configFile = {
      "procs/config.toml".source = "${dots}/configs/procs/config.toml";
    };
  };
}

