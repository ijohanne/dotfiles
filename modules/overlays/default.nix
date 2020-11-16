let
  sources = import ../../nix/sources.nix;
  imported-overlays = _: pkgs:
    {
      niv = (import sources.niv { }).niv;
      home-manager = (import sources.home-manager { inherit pkgs; }).home-manager;
      nur = (import sources.NUR
        {
          inherit pkgs;
        }).repos;
    };

  overlays = [
    imported-overlays
    (import "${sources.ijohanne-nur-packages}/overlay.nix")
    (import ../localpkgs { inherit sources; })
    (import sources.mozilla-overlay)

  ];
in
self: super: (super.lib.foldl' super.lib.composeExtensions (_: _: { }) overlays) self super
