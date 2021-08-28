{ secrets, pkgs, lib, config }:
let
  mkRtorrentInstance = (import ../modules/rtorrent.nix);
in
{
  imports = [
    (import (./martin8412.nix) { inherit secrets config pkgs lib mkRtorrentInstance; })
    (import (./krumme.nix) { inherit secrets config pkgs lib mkRtorrentInstance; })
    (import (./izabella.nix) { inherit secrets config pkgs lib mkRtorrentInstance; })
    (import (./sniffy.nix) { inherit secrets config pkgs lib; })
    ./opsplaza.nix
  ];
}
