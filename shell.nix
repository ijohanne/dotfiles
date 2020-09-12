let
  sources = import ./nixos/home/nix;
  nixpkgs = sources."nixpkgs";
  pkgs = import nixpkgs { };
in pkgs.mkShell rec {
  name = "home-manager-shell";
  buildInputs = with pkgs; [
    niv
    (import sources.home-manager { inherit pkgs; }).home-manager
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:home-manager=${sources."home-manager"}"
    export HOME_MANAGER_CONFIG="$HOME/.config/nixpkgs/home.nix"
  '';
}