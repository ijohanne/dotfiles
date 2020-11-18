{ sources, ... }:
_: pkgs: {
  niv-sources = sources;
  lib = (pkgs.lib or { }) // import ./lib { inherit pkgs sources; };
  # This is currenctly broken in nixos-unstable-small, so ignore the tests for now
  mercurial = pkgs.mercurial.overrideAttrs (_: {
    propagatedBuildInputs = [
      (pkgs.python38Packages.dulwich.overrideAttrs (_: {
        doInstallCheck = false;
      }))
    ];
  });
}
