{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-bin.override ({ pname = "firefox"; });
    extensions = with pkgs.nur.rycee.firefox-addons; [
      ublock-origin
      lastpass-password-manager
      reddit-enhancement-suite
    ];
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
}
