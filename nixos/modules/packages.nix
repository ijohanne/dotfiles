let sources = import ../nix/sources.nix;
in { pkgs, config, lib, ... }: {
  nixpkgs.overlays = [
    (self: super: rec {
      inherit sources;
      mozilla-overlay = (import sources.mozilla-overlay { }).packages;

      neovim-nightly = pkgs.neovim-unwrapped.overrideAttrs (_: {
        pname = "neovim-nightly";
        version = "master";
        src = pkgs.fetchFromGitHub {
          inherit (sources.neovim) owner repo rev sha256;
        };
      });

      nur = (import sources.NUR { pkgs = import sources.nixpkgs { }; }).repos;
    })
  ];
}
