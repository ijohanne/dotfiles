{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.browsers.firefox.enable) {
    programs.firefox = {
      enable = true;
      package = pkgs.latest.firefox-bin.override ({ pname = "firefox"; });
      extensions = with pkgs.nur.rycee.firefox-addons;
        [
          ublock-origin
          lastpass-password-manager
          reddit-enhancement-suite
          facebook-container
        ] ++ (with pkgs.firefoxPlugins; [ darkreader enhancer-for-youtube ]);
      profiles.default = {
        id = 0;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "extensions.autoDisableScopes" = 0;
          "browser.uidensity" = 1;
          "browser.search.openintab" = true;
          "xpinstall.signatures.required" = false;
          "extensions.update.enabled" = false;
          "identity.fxaccounts.enabled" = false;
          "signon.rememberSignons" = false;
          "signon.rememberSignons.visibilityToggle" = false;
          "media.eme.enabled" = true;
          "browser.eme.ui.enabled" = true;
        };
      };
    };

    home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };
  };
}
