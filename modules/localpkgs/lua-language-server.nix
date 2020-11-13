{ stdenv
, fetchFromGitHub
, pkgconfig
, makeWrapper
, lua52Packages
, ncurses
, ninja
, readline
, zlib
, lib
}:
with lib;
let
  sources = import ../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  pname = "lua-language-server";
  version = "master";

  src = fetchFromGitHub {
    inherit (sources.lua-language-server) owner repo rev sha256;
    fetchSubmodules = true;
  };

  buildPhase = ''
    cd 3rd/luamake

  ''
  + optionalString
    (stdenv.isLinux)
    "ninja -f ninja/linux.ninja"
  + optionalString
    (stdenv.isDarwin)
    "ninja -f ninja/linux.ninja"
  +
  ''

    cd ../..
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/Linux/lua-language-server $out/bin
  '';

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
    ninja
  ];

  buildInputs = [
    lua52Packages.lua
    ncurses
    readline
    zlib
  ];

  meta = with stdenv.lib; {
    description = "Lua language server";
    homepage = "https://github.com/sumneko/lua-language-server";
    platforms = with platforms; linux ++ darwin;
  };
}
