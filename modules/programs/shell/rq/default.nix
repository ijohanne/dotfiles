{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.rq.enable) {
    home.packages = with pkgs; [ rq ];
  };
}
