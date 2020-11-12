self: _: {
  bottom = self.callPackage ./bottom.nix { };
  lfs = self.callPackage ./lfs.nix { };
  pueue = self.callPackage ./pueue.nix { };
  themes = self.libsForQt5.callPackage ./sddm-themes.nix { };
  yubikey-touch-detector = self.callPackage ./yubikey-touch-detector { };
  lua-language-server = self.callPackage ./lua-language-server.nix { };
}
