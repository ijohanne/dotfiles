{ self, sources }:
with self;
with sources;
{
  bass = {
    name = "bass";
    src = fetchFromGitHub {
      inherit (bass) owner repo rev sha256;
    };
  };
  oh-my-fish-plugin-ssh = {
    name = "oh-my-fish-plugin-ssh";
    src = fetchFromGitHub {
      inherit (oh-my-fish-plugin-ssh) owner repo rev sha256;
    };
  };
  oh-my-fish-plugin-foreign-env = {
    name = "oh-my-fish-plugin-foreign-env";
    src = fetchFromGitHub {
      inherit (oh-my-fish-plugin-foreign-env) owner repo rev sha256;
    };
  };

  fish-ssh-agent = {
    name = "fish-ssh-agent";
    src = fetchFromGitHub {
      inherit (fish-ssh-agent) owner repo rev sha256;
    };
  };
  fzf-fish = {
    name = "fzf-fish";
    src = fetchFromGitHub {
      inherit (fzf-fish) owner repo rev sha256;
    };
  };
  fish-exa = {
    name = "fish-exa";
    src = fetchFromGitHub {
      inherit (fish-exa) owner repo rev sha256;
    };
  };
}
