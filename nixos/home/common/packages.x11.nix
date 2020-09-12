let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
in {
  home.packages = with pkgs; [
    slack
    element-desktop
    thunderbird
    libreoffice
    spotify
    pavucontrol
    bemenu
    termite
    inconsolata
    zathura
    seafile-client
    mako
    skype
    feh
    openconnect
    obs-studio
    grim
    slurp
    xdg-user-dirs
    wl-clipboard
  ];
}
