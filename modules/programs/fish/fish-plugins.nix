{ pkgs }:
let sources = import ../../../nix/sources.nix;
in {
  bass = {
    name = "bass";
    src =
      pkgs.fetchFromGitHub { inherit (sources.bass) owner repo rev sha256; };
  };
  oh-my-fish-plugin-ssh = {
    name = "oh-my-fish-plugin-ssh";
    src = pkgs.fetchFromGitHub {
      inherit (sources.oh-my-fish-plugin-ssh) owner repo rev sha256;
    };
  };
  oh-my-fish-plugin-foreign-env = {
    name = "oh-my-fish-plugin-foreign-env";
    src = pkgs.fetchFromGitHub {
      inherit (sources.oh-my-fish-plugin-foreign-env) owner repo rev sha256;
    };
  };

  fish-ssh-agent = {
    name = "fish-ssh-agent";
    src = pkgs.fetchFromGitHub {
      inherit (sources.fish-ssh-agent) owner repo rev sha256;
    };
  };
  fish-fzf = {
    name = "fish-fzf";
    src = pkgs.fetchFromGitHub {
      inherit (sources.fish-fzf) owner repo rev sha256;
    };
  };
}

