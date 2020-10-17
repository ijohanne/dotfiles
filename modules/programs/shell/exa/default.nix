{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.exa.enable) {
    home.packages = with pkgs; [ exa ];
  };

}

