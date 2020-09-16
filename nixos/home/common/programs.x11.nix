let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { };
in {
  programs.firefox = {
    enable = true;
    extensions = with sources.nur.repos.rycee.firefox-addons; [
      ublock-origin
      lastpass-password-manager
      reddit-enhancement-suite
    ];
  };

  home.packages = with pkgs; [ alacritty libsixel ];

  xdg.configFile."alacritty/alacritty.yml".source =
    ../../../configs/terminal/alacritty.yml;

}
