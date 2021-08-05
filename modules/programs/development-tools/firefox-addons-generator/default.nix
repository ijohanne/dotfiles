{ pkgs, lib, config, ... }:
with lib; {
  config =
    mkIf (config.dotfiles.development-tools.firefox-addons-generator.enable) {
      home.packages = with pkgs.nur.ijohanne; [ nixpkgs-firefox-addons ];
    };
}
