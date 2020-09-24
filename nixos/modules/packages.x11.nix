{ pkgs, ... }: {
  home.packages = with pkgs; [
    slack
    element-desktop
    thunderbird
    libreoffice
    spotify
    pavucontrol
    bemenu
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
