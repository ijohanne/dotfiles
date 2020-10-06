{ pkgs, config, ... }:
let dots = "${config.home.homeDirectory}/.dotfiles";
in {
  home.packages = with pkgs; [
    niv
    perl
    gitAndTools.gh
    tokei
    du-dust
    exa
    procs
  ];

  xdg.configFile = {
    "procs/config.toml".source = "${dots}/configs/procs/config.toml";
  };
}

