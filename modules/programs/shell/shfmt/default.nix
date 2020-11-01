{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.shfmt.enable) {
    home.packages = with pkgs; [ shfmt ];
  };

}

