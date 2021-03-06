{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.browsers.firefox.enable) {
    nixpkgs.config.firefox.enableFXCastBridge = false;
    home.packages = [
      (
        pkgs.firefox-hardened-wayland.override
          {
            nixExtensions = with pkgs.firefoxPlugins; [ ublock-origin facebook-container lastpass-password-manager reddit-enhancement-suite enhancer-for-youtube darkreader certificate-pinner ];
          }
      )
    ];
    home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };
  };
}
