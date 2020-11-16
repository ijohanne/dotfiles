let
  sources = import ../../nix/sources.nix;
  imported-overlays = self: pkgs:
    {
      niv = (import sources.niv { }).niv;
      home-manager = (import sources.home-manager { inherit pkgs; }).home-manager;
      nur = (import sources.NUR
        {
          inherit pkgs;
        }).repos;
      nur-ijohanne = (import sources.ijohanne-nur-packages { inherit pkgs; });
      vimPlugins = (pkgs.vimPlugins or { }) // self.nur-ijohanne.vimPlugins;
      fishPlugins = (pkgs.fishPlugins or { }) // self.nur-ijohanne.fishPlugins;
      firefoxPlugins = (pkgs.firefoxPlugins or { }) // self.nur-ijohanne.firefoxPlugins;
    };

  overlays = [
    imported-overlays
    (import ../localpkgs { inherit sources; })
    (import sources.mozilla-overlay)

  ];
in
self: super: (super.lib.foldl' super.lib.composeExtensions (_: _: { }) overlays) self super
