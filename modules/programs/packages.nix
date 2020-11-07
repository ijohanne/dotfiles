let
  sources = import ../../nix/sources.nix;
  upstreamPkgs = import sources.nixpkgs { };
in { pkgs, ... }: {
  nixpkgs.overlays = [
    (import sources.mozilla-overlay)
    (import ../localpkgs)
    (_: _: rec {
      inherit sources;
      niv = import sources.niv { };
      # Temporary fix see https://github.com/NixOS/nixpkgs/issues/103009
      rust-src-lib = pkgs.stdenv.mkDerivation {
        name = "rust-lib-src";
        src = pkgs.rustc.src;
        phases = [ "unpackPhase" "installPhase" ];

        installPhase = ''
          mv library $out
        '';
      };
      rust-analyzer-unwrapped =
        upstreamPkgs.rust-analyzer-unwrapped.overrideAttrs (attrs: {
          preCheck = pkgs.lib.optionalString attrs.doCheck ''
            export RUST_SRC_PATH=${rust-src-lib}
          '';
        });
      rust-analyzer = let
        unwrapped = rust-analyzer-unwrapped;
        version = unwrapped.version;
        pname = "rust-analyzer";
      in pkgs.runCommandNoCC "${pname}-${version}" {
        inherit pname version;
        inherit (unwrapped) src meta;
        nativeBuildInputs = with pkgs; [ makeWrapper ];
      } ''
        mkdir -p $out/bin
        makeWrapper ${unwrapped}/bin/rust-analyzer $out/bin/rust-analyzer \
          --set-default RUST_SRC_PATH "${rust-src-lib}"
      '';
      # Override fix to enable neovim building, and bump to the bundled one for neovim
      tree-sitter = upstreamPkgs.tree-sitter.overrideAttrs (attrs: {
        version = "0.17.3";
        rev = "c439a676cf169e88234f768ca0f69d42e5bd68c5";
        sha256 = "1r9zvbl1d9ah3nwj9798kjkfxyqmys5jbax8wc87ygawpz93q2xr";
        outputs = [ "out" "dev" "lib" ];
        postInstall = ''
          make
          mkdir -p $dev/include/tree_sitter
          cp lib/include/tree_sitter/* $dev/include/tree_sitter
          mkdir -p $lib
          cp libtree-sitter.so* $lib
          cp libtree-sitter.a* $lib
        '';
        nativeBuildInputs = attrs.nativeBuildInputs
          ++ (with pkgs; [ cmake gnumake ]);
      });
      neovim-nightly = pkgs.neovim-unwrapped.overrideAttrs (attrs: {
        pname = "neovim-nightly";
        version = "master";

        nativeBuildInputs = attrs.nativeBuildInputs
          ++ [ tree-sitter.dev tree-sitter.lib ];
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
  home.sessionVariables = {
    NIX_PATH =
      "nixpkgs=${sources.nixpkgs}:home-manager=${sources.home-manager}:nixos-config=/etc/nixos/configuration.nix";
  };
}
