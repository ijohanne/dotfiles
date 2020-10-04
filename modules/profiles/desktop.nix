{ pkgs, ... }:

{
  imports = [
    ../programs/sway
    ../programs/neovim
    ../programs/fish
    ../programs/git.nix
    ../programs/starship.nix
    ../programs/htop.nix
    ../programs/direnv.nix
    ../programs/home-manager.nix
    ../programs/alacritty.nix
    ../programs/firefox.nix
    ../programs/lorri.nix
    ../programs/gpg-agent.nix
    ../programs/tex.nix
    ../fonts-themes.nix
  ];

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
    skype
    feh
    openconnect
    obs-studio
    lsof
    whois
    haskellPackages.nixfmt
    ripgrep
    mtr
    mkpasswd
    docker-compose
    ldns
    imagemagick
    niv
    perl
    gitAndTools.gh
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    MOZ_ENABLE_WAYLAND = "1";
    DRI_PRIME = "1";
  };

}

