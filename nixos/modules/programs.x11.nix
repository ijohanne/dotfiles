{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-bin.override ({ pname = "firefox"; });
    extensions = with pkgs.nur.rycee.firefox-addons; [
      ublock-origin
      lastpass-password-manager
      reddit-enhancement-suite
    ];
  };

  home.packages = with pkgs; [ alacritty libsixel ];

  xdg.configFile."alacritty/alacritty.yml".source =
    ../../configs/terminal/alacritty.yml;
}
