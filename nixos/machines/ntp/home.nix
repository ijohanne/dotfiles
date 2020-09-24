let sources = import ../../nixpkgs;
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
    ../../modules/programs.shell.nix
    ../../modules/files.nix
    ../../modules/environment.nix
    ../../modules/services.shell.nix
    ../../modules/packages.nix
  ];

  dconf.enable = false;

}
