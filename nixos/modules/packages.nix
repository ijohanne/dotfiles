let sources = import ../nix/sources.nix;
in { pkgs, config, lib, ... }: {
  nixpkgs.overlays = [
    (import sources.mozilla-overlay)
    (self: super: rec {
      inherit sources;
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
