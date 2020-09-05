{ pkgs, ... }:

{
  programs.zsh = {
    oh-my-zsh = { plugins = [ "git" "zsh_reload" "kubectl" ]; };
  };
}
