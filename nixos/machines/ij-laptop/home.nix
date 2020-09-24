{
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
    ../../modules/packages.nix
  ];

  home.sessionVariables = { DRI_PRIME = "1"; };
}
