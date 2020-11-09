let
  sources = import ./nix/sources.nix;
  nixpkgs = sources."nixpkgs";
  pkgs = import nixpkgs { };
  gis = import sources.nix-gitignore { };
  nix-pre-commit-hooks = import sources.pre-commit-hooks-nix;
in
pkgs.mkShell rec {
  pre-commit-check = nix-pre-commit-hooks.run {
    src = gis.gitignoreSource ./.;
    hooks = {
      shellcheck.enable = true;
      nix-linter.enable = true;
      nixpkgs-fmt.enable = true;
      yamllint.enable = true;
    };
    excludes = [ "modules/programs/browsers/firefox/addons.nix" ];
  };
  name = "home-manager-shell";
  buildInputs = with pkgs; [
    (import sources.niv { }).niv
    (import sources.home-manager { inherit pkgs; }).home-manager
    shellcheck
    shfmt
    nixpkgs-fmt
    git
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:home-manager=${
      sources."home-manager"
    }:nixos-config=/etc/nixos/configuration.nix"
    export NIXPKGS_PATH=${nixpkgs}
    ${pre-commit-check.shellHook}
  '';
}
