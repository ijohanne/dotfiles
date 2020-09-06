let 
  home-manager = (import ./nix/sources.nix).home-manager;
in {
  programs = {
    home-manager = {
      enable = true;
      path = "${home-manager}";
    };
  };

  nixpkgs.overlays = [
    (import ./nix).neovim-overlay
  ];

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/packages.tex.nix
    ./common/packages.x11.nix
    ./common/programs.shell.nix
    ./common/programs.x11.nix
    ./common/services.shell.nix
    ./common/services.x11.nix
    ./common/services.local.nix
    ./common/files.nix
    ./common/environment.nix
  ];

  programs.vscode = { userSettings = { "window.zoomLevel" = -1; }; };
  
}
