{ pkgs, ... }: {
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
      };

    };
  };

  home.packages = with pkgs; [ alacritty libsixel ];

  xdg.configFile."alacritty/alacritty.yml".source =
    ../../configs/terminal/alacritty.yml;
}

