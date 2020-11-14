let
  sources = import ../../nix/sources.nix;
  overlays = [
    (import ./localpkgs { inherit sources; })
    (import sources.mozilla-overlay)
  ];
in
self: super: (super.lib.foldl' super.lib.composeExtensions (_: _: { }) overlays) self super
