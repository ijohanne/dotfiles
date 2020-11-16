{ sources, ... }:
_: pkgs: {
  niv-sources = sources;
  lib = (pkgs.lib or { }) // import ./lib { inherit pkgs sources; };
}
