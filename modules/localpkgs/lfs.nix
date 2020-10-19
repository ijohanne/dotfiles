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
  cargoSha256 = "02mgmimp4dbq8ahhrs9np665c5pl6z997zmxlz1g3pw14x3dw2h9";
  buildInputs = [ ];
  CARGO_HOME = "$(mktemp -d cargo-home.XXX)";

  meta = with lib; {
    homepage = "https://github.com/Canop/lfs";
    description = "A small linux utility listing your filesystems.";
    license = licenses.mit;
  };
}
