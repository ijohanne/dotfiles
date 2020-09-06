let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
in {
  programs.zsh = {
    oh-my-zsh = { plugins = [ "git" "zsh_reload" "kubectl" ]; };
  };
}
