let sources = import ./nix;
in {
  programs = {
    home-manager = {
      enable = true;
      path = "${sources.home-manager}";
    };
  };

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/packages.tex.nix
    ./common/packages.x11.nix
    ./common/programs.shell.nix
    ./common/programs.x11.nix
    ./common/services.shell.nix
    ./common/services.x11.nix
    ./common/files.nix
    ./common/environment.nix
  ];

}
