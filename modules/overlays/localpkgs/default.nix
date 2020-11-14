{ sources, ... }:
self: super:
{
  niv-sources = sources;
  lib = (super.lib or { }) // import ./lib.nix { inherit self sources; };
  bottom = self.callPackage ./bottom.nix { inherit sources; };
  lfs = self.callPackage ./lfs.nix { inherit sources; };
  pueue = self.callPackage ./pueue.nix { inherit sources; };
  themes = self.libsForQt5.callPackage ./sddm-themes.nix { inherit sources; };
  yubikey-touch-detector = self.callPackage ./yubikey-touch-detector { inherit sources; };
  lua-language-server = self.callPackage ./lua-language-server.nix { inherit sources; };
  gping = self.callPackage ./gping.nix { inherit sources; };
  fishPlugins = (super.fishPlugins or { }) // import ./fish-plugins.nix { inherit self sources; };
  vimPlugins = (super.vimPlugins or { }) // import ./vim-plugins.nix { inherit self sources; };
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
