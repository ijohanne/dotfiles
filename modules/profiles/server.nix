{ pkgs, ... }:

{
  imports = [
    ../programs/neovim
    ../programs/fish
    ../programs/git.nix
    ../programs/starship.nix
    ../programs/htop.nix
    ../programs/direnv.nix
    ../programs/home-manager.nix
    ../programs/lorri.nix
  ];

  home.packages = with pkgs; [
    lsof
    whois
    haskellPackages.nixfmt
    ripgrep
    mtr
    mkpasswd
    ldns
    niv
    perl
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    MOZ_ENABLE_WAYLAND = "1";
    DRI_PRIME = "1";
  };

}

