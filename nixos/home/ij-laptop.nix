let
  sources = import ./nix;
  home-manager = sources.home-manager;
  pkgs = import sources.nixpkgs { overlays = [ sources.neovim-overlay];};
in {
  programs = {
    home-manager = {
      enable = true;
      path = "${home-manager}";
    };
  };

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/packages.tex.nix
    ./common/packages.x11.nix
    ./common/programs.shell.nix
    ./common/programs.x11.nix
    ./common/programs.local.nix
    ./common/services.shell.nix
    ./common/services.x11.nix
    ./common/files.nix
    ./common/environment.nix
  ];

  home.sessionVariables = { DRI_PRIME = "1"; };
}
