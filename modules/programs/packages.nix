let sources = import ../../nix/sources.nix;
in { pkgs, ... }: {
  nixpkgs.overlays = [
    (import sources.mozilla-overlay)
    (import ../localpkgs)
    (_: _: rec {
      inherit sources;
      niv = import sources.niv { };
      neovim-nightly = pkgs.neovim-unwrapped.overrideAttrs (_: {
        pname = "neovim-nightly";
        version = "master";
        src = pkgs.fetchFromGitHub {
          inherit (sources.neovim) owner repo rev sha256;
        };
      });

      nur = (import sources.NUR {
        pkgs = import sources.nixpkgs { config.allowUnfree = true; };
      }).repos;
    })
  ];
  nixpkgs.config.allowUnfree = true;
}
