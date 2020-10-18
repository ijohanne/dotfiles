self: _: {
  bottom = self.callPackage ./bottom.nix { };
  lfs = self.callPackage ./lfs.nix { };
}
