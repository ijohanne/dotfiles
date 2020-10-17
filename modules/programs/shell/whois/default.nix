{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.whois.enable) {
    home.packages = with pkgs; [ whois ];
  };
}

