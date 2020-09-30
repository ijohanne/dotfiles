{
  imports = [
    ../../../modules/home/fonts-themes.nix
    ../../../modules/home/packages.shell.nix
    ../../../modules/home/programs.shell.nix
    ../../../modules/home/files.nix
    ../../../modules/home/environment.nix
    ../../../modules/home/services.shell.nix
    ../../../modules/home/packages.nix
  ];

  dconf.enable = false;

}
