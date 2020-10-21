{ pkgs, darwin, stdenv, ... }:

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
  pname = "bottom";
  version = "master";
  src =
    pkgs.fetchFromGitHub { inherit (sources.bottom) owner repo rev sha256; };
  cargoSha256 = "1m0njsvz2zx4abfiaz7n20ysldmc4lkzm2s46wyb86xjd1az1zg8";
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin
    darwin.apple_sdk.frameworks.IOKit;
  doCheck = false;
  meta = with lib; {
    homepage = "https://github.com/ClementTsang/bottom";
    description =
      "A cross-platform graphical process/system monitor with a customizable interface and a multitude of features. Supports Linux, macOS, and Windows.";
    license = licenses.mit;
  };
}
