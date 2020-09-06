let home-manager = (import ./nix/sources.nix).home-manager;
in {
  programs = {
    home-manager = {
      enable = true;
      path = "${home-manager}";
    };
  };

  nixpkgs.overlays = [ (import ./nix).neovim-overlay ];

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/programs.shell.nix
    ./common/programs.remote.nix
    ./common/files.nix
    ./common/environment.nix
    ./common/services.shell.nix
  ];

  dconf.enable = false;

}
