{ self, sources }:
with self.vimUtils;
with sources;
{
  nvim-web-devicons = buildVimPluginFrom2Nix {
    name = "nvim-web-devicons";
    src = self.fetchFromGitHub {
      inherit (nvim-web-devicons) owner repo rev sha256;
    };
  };
  nvim-lsp-extensions = buildVimPluginFrom2Nix {
    name = "nvim-lsp-extensions";
    src = self.fetchFromGitHub {
      inherit (lsp_extensions-nvim) owner repo rev sha256;
    };
  };
  nvim-lspconfig = buildVimPluginFrom2Nix {
    name = "nvim-lspconfig";
    src = self.fetchFromGitHub {
      inherit (nvim-lspconfig) owner repo rev sha256;
    };
  };
  Language-tool-nvim = buildVimPluginFrom2Nix {
    name = "Language-tool-nvim";
    src = self.fetchFromGitHub {
      inherit (LanguageTool-nvim) owner repo rev sha256;
    };
  };
  neovim-treesitter = buildVimPluginFrom2Nix {
    name = "neovim-treesitter";
    src = self.fetchFromGitHub {
      inherit (nvim-treesitter) owner repo rev sha256;
    };
  };
  ranger-vim = buildVimPluginFrom2Nix {
    name = "ranger-vim";
    src = self.fetchFromGitHub {
      inherit (ranger-vim) owner repo rev sha256;
    };
  };
  git-blame-nvim = buildVimPluginFrom2Nix {
    name = "git-blame-nvim";
    src = self.fetchFromGitHub {
      inherit (git-blame-nvim) owner repo rev sha256;
    };
  };
}
