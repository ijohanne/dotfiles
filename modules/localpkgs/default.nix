{ sources, ... }:
self: pkgs: {
  niv-sources = sources;
  lib = (pkgs.lib or { }) // import ./lib { inherit pkgs sources; };
  bottom = self.callPackage ./bottom { inherit sources; };
  lfs = self.callPackage ./lfs { inherit sources; };
  pueue = self.callPackage ./pueue { inherit sources; };
  themes = self.libsForQt5.callPackage ./sddm-themes { inherit sources; };
  yubikey-touch-detector = self.callPackage ./yubikey-touch-detector { inherit sources; };
  lua-language-server = self.callPackage ./lua-language-server { inherit sources; };
  gping = self.callPackage ./gping { inherit sources; };
  fishPlugins = (pkgs.fishPlugins or { }) // import ./fish-plugins { inherit pkgs sources; };
  vimPlugins = (pkgs.vimPlugins or { }) // import ./vim-plugins { inherit pkgs sources; };
  neovim-nightly = pkgs.callPackage ./neovim-nightly { inherit pkgs sources; };
  firefoxPlugins = pkgs.callPackage ./firefox-plugins { buildFirefoxXpiAddon = self.nur.rycee.firefox-addons.buildFirefoxXpiAddon; };
}
