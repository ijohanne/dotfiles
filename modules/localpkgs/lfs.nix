{ pkgs, darwin, stdenv, ... }:

with pkgs;
let
  sources = import ../../nix/sources.nix;
  rustPlatform =
    let rust = pkgs.latest.rustChannels.stable.rust;
    in
    pkgs.makeRustPlatform {
      cargo = rust;
      rustc = rust;
    };
  inherit (pkgs) lib;
in
rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "master";
  src = pkgs.fetchFromGitHub { inherit (sources.lfs) owner repo rev sha256; };
  cargoSha256 = "02mgmimp4dbq8ahhrs9np665c5pl6z997zmxlz1g3pw14x3dw2h9";
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin
    darwin.apple_sdk.frameworks.IOKit;

  meta = with lib; {
    homepage = "https://github.com/Canop/lfs";
    description = "A small linux utility listing your filesystems.";
    license = licenses.mit;
  };
}
