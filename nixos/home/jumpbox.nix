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
    ./common/programs.shell.nix
    ./common/programs.remote.nix
    ./common/files.nix
    ./common/environment.nix
    ./common/services.shell.nix
  ];
}
