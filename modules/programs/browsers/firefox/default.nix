{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.browsers.firefox.enable) {
    home.packages = [
      (
        (pkgs.firefox-hardened-wayland.override {
          nixExtensions = with pkgs.firefoxPlugins; [ ublock-origin facebook-container lastpass-password-manager reddit-enhancement-suite enhancer-for-youtube darkreader certificate-pinner bitwarden-password-manager ];
        }).overrideAttrs (_:
          {
            desktopItem = pkgs.makeDesktopItem {
              name = "firefox";
              exec = "env MOZ_ENABLE_WAYLAND=1 MOZ_DBUS_REMOTE=1 MOZ_DISABLE_CONTENT_SANDBOX=1 firefox %u";
              icon = "firefox";
              comment = "";
              desktopName = "Firefox";
              genericName = "Web Browser";
              categories = [ "Network" "WebBrowser" ];
              mimeTypes = [
                "text/html"
                "text/xml"
                "application/xhtml+xml"
                "application/vnd.mozilla.xul+xml"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
                "x-scheme-handler/ftp"
              ];
            };
          }
        ))
    ];
    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications =
      {
        # Add other defaults here too
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/vnd.mozilla.xul+xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/ftp" = [ "firefox.desktop" ];
      };
  };
}
