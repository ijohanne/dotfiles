let
  sources = import ./nix/sources.nix;
  nixpkgs = sources."nixpkgs";
  pkgs = import nixpkgs { };
  nix-pre-commit-hooks = import sources.pre-commit-hooks-nix;
in pkgs.mkShell rec {
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      shellcheck.enable = true;
      nix-linter.enable = true;
      nixfmt.enable = true;
      yamllint.enable = true;
    };
  };
  name = "home-manager-shell";
  buildInputs = with pkgs; [
    (import sources.niv { }).niv
    (import sources.home-manager { inherit pkgs; }).home-manager
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:home-manager=${sources."home-manager"}"
    export NIXPKGS_PATH=${nixpkgs}
    ${pre-commit-check.shellHook}
  '';
}
