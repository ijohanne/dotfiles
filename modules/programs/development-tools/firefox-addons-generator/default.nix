{ pkgs, lib, config, ... }:

{
  config = lib.mkIf
    (config.dotfiles.development-tools.firefox-addons-generator.enable) {
      home.packages = with pkgs.nur.rycee; [ firefox-addons-generator ];
    };
}

