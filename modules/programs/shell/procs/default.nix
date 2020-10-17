{ pkgs, config, lib, ... }:
let dots = "${config.home.homeDirectory}/.dotfiles";
in {
  config = lib.mkIf (config.dotfiles.shell.procs.enable) {
    home.packages = with pkgs; [ procs ];

    xdg.configFile = {
      "procs/config.toml".source = "${dots}/configs/procs/config.toml";
    };
  };
}

