{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs { overlays = [ (import ./modules/overlays) ]; }
}:
pkgs.mkShell rec {
  pre-commit-check = (import sources.pre-commit-hooks-nix).run {
    src = (import sources.nix-gitignore { }).gitignoreSource ./.;
    hooks = {
      shellcheck.enable = true;
      nix-linter.enable = true;
      nixpkgs-fmt.enable = true;
      yamllint.enable = true;
    };
    excludes = [
      "machines/nixos/delirium"
    ];
  };
  name = "home-manager-shell";
  buildInputs = with pkgs; [
    niv
    home-manager
    shellcheck
    shfmt
    nixpkgs-fmt
    git
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${sources.nixpkgs}:home-manager=${sources."home-manager"}:nixos-config=/etc/nixos/configuration.nix:nixpkgs-overlays=modules/overlays"
    export NIXPKGS_PATH=${sources.nixpkgs}
    ${pre-commit-check.shellHook}
  '';
}
