self: _: {
  bottom = self.callPackage ./bottom.nix { };
  lfs = self.callPackage ./lfs.nix { };
  pueue = self.callPackage ./pueue.nix { };
  themes = self.libsForQt514.callPackage ./sddm-themes.nix { };
}
