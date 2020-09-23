let sources = import ../../nix;
in {
  programs = {
    home-manager = {
      enable = true;
      path = "${sources.home-manager}";
    };
  };

  imports = [
    ../../modules/fonts-themes.nix
    ../../modules/packages.shell.nix
    ../../modules/packages.tex.nix
    ../../modules/packages.x11.nix
    ../../modules/programs.shell.nix
    ../../modules/programs.x11.nix
    ../../modules/services.shell.nix
    ../../modules/services.x11.nix
    ../../modules/files.nix
    ../../modules/environment.nix
  ];

  home.sessionVariables = { DRI_PRIME = "1"; };
}
