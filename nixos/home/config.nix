{ pkgs, ... }:

{
  allowUnfree = true;
  packageOverrides = pkgs:
  with pkgs; {
    nixfmt = import (builtins.fetchTarball
    "https://github.com/serokell/nixfmt/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}
