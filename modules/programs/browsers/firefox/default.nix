{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.browsers.firefox.enable) {
    home.packages = [
      (
        pkgs.firefox-hardened-wayland.override
          {
            nixExtensions = with pkgs.firefoxPlugins; [ ublock-origin facebook-container lastpass-password-manager reddit-enhancement-suite enhancer-for-youtube darkreader certificate-pinner bitwarden-password-manager ];
          }
      )
    ];
    home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };
  };
}
