{ sources, pkgs, installShellFiles, darwin, stdenv, ... }:

with pkgs;
let
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
  pname = "bottom";
  version = "master";
  src =
    pkgs.fetchFromGitHub { inherit (sources.bottom) owner repo rev sha256; };
  cargoSha256 = "11bl72v4siqg338x5iypyx1w7a2vr9gifdjkaxlqhv6kil50vwc3";
  nativeBuildInputs = [ installShellFiles ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin
    darwin.apple_sdk.frameworks.IOKit;
  doCheck = false;
  postInstall = ''
    target_dir=$(ls $releaseDir/build/bottom-*/out/btm.bash | head -n1 | xargs dirname)
    installShellCompletion --bash --name btm.bash $target_dir/btm.bash
    installShellCompletion --fish --name btm.fish $target_dir/btm.fish
    installShellCompletion --zsh --name _btm $target_dir/_btm
  '';
  meta = with lib; {
    homepage = "https://github.com/ClementTsang/bottom";
    description =
      "A cross-platform graphical process/system monitor with a customizable interface and a multitude of features. Supports Linux, macOS, and Windows.";
    license = licenses.mit;
  };
}