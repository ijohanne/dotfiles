{ sources, self, ... }:
rec {
  global_git_ignore_list = name:
    self.lib.splitString "\n" (builtins.readFile ("${sources.gitignore}" + name));
}
