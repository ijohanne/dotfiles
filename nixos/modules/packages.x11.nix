{ pkgs, ... }: {
  imports = [ ./packages.nix ];
  home.packages = with pkgs.unstable; [
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
