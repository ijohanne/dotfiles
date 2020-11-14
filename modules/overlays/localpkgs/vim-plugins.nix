{ self, sources }:
{
  nvim-web-devicons = self.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-web-devicons";
    src = self.fetchFromGitHub {
      inherit (sources.nvim-web-devicons) owner repo rev sha256;
    };
  };
  nvim-lsp-extensions = self.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lsp-extensions";
    src = self.fetchFromGitHub {
      inherit (sources.lsp_extensions-nvim) owner repo rev sha256;
    };
  };
  nvim-lspconfig = self.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lspconfig";
    src = self.fetchFromGitHub {
      inherit (sources.nvim-lspconfig) owner repo rev sha256;
    };
  };
  Language-tool-nvim = self.vimUtils.buildVimPluginFrom2Nix {
    name = "Language-tool-nvim";
    src = self.fetchFromGitHub {
      inherit (sources.LanguageTool-nvim) owner repo rev sha256;
    };
  };
  neovim-treesitter = self.vimUtils.buildVimPluginFrom2Nix {
    name = "neovim-treesitter";
    src = self.fetchFromGitHub {
      inherit (sources.nvim-treesitter) owner repo rev sha256;
    };
  };
  ranger-vim = self.vimUtils.buildVimPluginFrom2Nix {
    name = "ranger-vim";
    src = self.fetchFromGitHub {
      inherit (sources.ranger-vim) owner repo rev sha256;
    };
  };
  git-blame-nvim = self.vimUtils.buildVimPluginFrom2Nix {
    name = "git-blame-nvim";
    src = self.fetchFromGitHub {
      inherit (sources.git-blame-nvim) owner repo rev sha256;
    };
  };
}
