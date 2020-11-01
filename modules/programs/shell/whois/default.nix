{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.whois.enable) {
    home.packages = with pkgs; [ whois ];
  };
}

