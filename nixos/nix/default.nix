let
  sources = import ./sources.nix;
  pkgs = import sources.nixpkgs { };
in rec {
  home-manager = sources.home-manager;
  nixpkgs = sources.nixpkgs;
  nur = import sources.NUR { inherit pkgs; };
  neovim-overlay = import sources.neovim-overlay;
  mozilla-overlay = import sources.mozilla-overlay;
  LS_COLORS = sources.LS_COLORS;
  bass = sources.bass;
  oh-my-fish-plugin-ssh = sources.oh-my-fish-plugin-ssh;
  oh-my-fish-plugin-foreign-env = sources.oh-my-fish-plugin-foreign-env;
  fish-ssh-agent = sources.fish-ssh-agent;
}
