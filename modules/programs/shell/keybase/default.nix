{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.keybase.enable) {
    home.packages = with pkgs; [ keybase kbfs ];
    services.keybase.enable = true;
    services.kbfs.enable = true;
  };
}
