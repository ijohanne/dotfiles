{ sources, pkgs, ... }:
rec {
  global_git_ignore_list = name:
    pkgs.lib.splitString "\n" (builtins.readFile ("${sources.gitignore}" + name));
}
