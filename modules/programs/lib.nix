{ lib, ... }:
with lib;
let sources = import ../../nix/sources.nix;
in rec {
  global_git_ignore_list = name:
    lib.splitString "\n" (builtins.readFile ("${sources.gitignore}" + name));
}

