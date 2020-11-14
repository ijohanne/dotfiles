{ sources, ... }:
self: super:
{
  niv-sources = sources;
  lib = (super.lib or { }) // import ./lib { inherit self sources; };
  bottom = self.callPackage ./bottom { inherit sources; };
  lfs = self.callPackage ./lfs { inherit sources; };
  pueue = self.callPackage ./pueue { inherit sources; };
  themes = self.libsForQt5.callPackage ./sddm-themes { inherit sources; };
  yubikey-touch-detector = self.callPackage ./yubikey-touch-detector { inherit sources; };
  lua-language-server = self.callPackage ./lua-language-server { inherit sources; };
  gping = self.callPackage ./gping { inherit sources; };
  fishPlugins = (super.fishPlugins or { }) // import ./fish-plugins { inherit self sources; };
  vimPlugins = (super.vimPlugins or { }) // import ./vim-plugins { inherit self sources; };
  niv = import sources.niv { };
  neovim-nightly = self.neovim-unwrapped.overrideAttrs (attrs: {
    pname = "neovim-nightly";
    version = "master";
    nativeBuildInputs = attrs.nativeBuildInputs
      ++ [ self.tree-sitter ];
    src = self.fetchFromGitHub {
      inherit (sources.neovim) owner repo rev sha256;
    };
  });
  nur = (import sources.NUR {
    pkgs = import sources.nixpkgs { config.allowUnfree = true; };
  }).repos;
}
