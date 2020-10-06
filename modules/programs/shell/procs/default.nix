{ pkgs, config, ... }:
let dots = "${config.home.homeDirectory}/.dotfiles";
in {
  home.packages = with pkgs; [ procs ];

  xdg.configFile = {
    "procs/config.toml".source = "${dots}/configs/procs/config.toml";
  };
}

