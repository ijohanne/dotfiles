{ pkgs, ... }:

with pkgs;
let
  sources = import ../../nix/sources.nix;
  rustPlatform = let rust = pkgs.latest.rustChannels.stable.rust;
  in pkgs.makeRustPlatform {
    cargo = rust;
    rustc = rust;
  };
  inherit (pkgs) lib;
in rustPlatform.buildRustPackage rec {
  name = "lfs-${version}";
  version = "master";
  src = pkgs.fetchFromGitHub { inherit (sources.lfs) owner repo rev sha256; };
  cargoSha256 = "1v35563zp1sikk92sp0420gk242pa5khm926ixjwhdk8cxp6nqws";
  buildInputs = [ ];
  CARGO_HOME = "$(mktemp -d cargo-home.XXX)";

  meta = with lib; {
    homepage = "https://github.com/Canop/lfs";
    description = "A small linux utility listing your filesystems.";
    license = licenses.mit;
  };
}
