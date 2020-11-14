{ self, sources }:
rec
{
  bass = {
    name = "bass";
    src =
      self.fetchFromGitHub { inherit (sources.bass) owner repo rev sha256; };
  };
  oh-my-fish-plugin-ssh = {
    name = "oh-my-fish-plugin-ssh";
    src = self.fetchFromGitHub {
      inherit (sources.oh-my-fish-plugin-ssh) owner repo rev sha256;
    };
  };
  oh-my-fish-plugin-foreign-env = {
    name = "oh-my-fish-plugin-foreign-env";
    src = self.fetchFromGitHub {
      inherit (sources.oh-my-fish-plugin-foreign-env) owner repo rev sha256;
    };
  };

  fish-ssh-agent = {
    name = "fish-ssh-agent";
    src = self.fetchFromGitHub {
      inherit (sources.fish-ssh-agent) owner repo rev sha256;
    };
  };
  fzf-fish = {
    name = "fzf-fish";
    src = self.fetchFromGitHub {
      inherit (sources.fzf-fish) owner repo rev sha256;
    };
  };
  fish-exa = {
    name = "fish-exa";
    src = self.fetchFromGitHub {
      inherit (sources.fish-exa) owner repo rev sha256;
    };
  };

}
