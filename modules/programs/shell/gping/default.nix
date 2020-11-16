{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.gping.enable) {
    home.packages = with pkgs.nur-ijohanne; [ gping ];
  };
}
