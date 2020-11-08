{ pkgs }:
let sources = import ../../../../nix/sources.nix;
in {
  nvim-web-devicons = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-web-devicons";
    src = pkgs.fetchFromGitHub {
      inherit (sources.nvim-web-devicons) owner repo rev sha256;
    };
  };
  nvim-lsp-extensions = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-lsp-extensions";
    src = pkgs.fetchFromGitHub {
      inherit (sources.lsp_extensions-nvim) owner repo rev sha256;
    };
  };
  nvim-lspconfig = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lspconfig";
    src = pkgs.fetchFromGitHub {
      inherit (sources.nvim-lspconfig) owner repo rev sha256;
    };
  };
  Language-tool-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "Language-tool-nvim";
    src = pkgs.fetchFromGitHub {
      inherit (sources.LanguageTool-nvim) owner repo rev sha256;
    };
  };
  neovim-treesitter = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neovim-treesitter";
    src = pkgs.fetchFromGitHub {
      inherit (sources.nvim-treesitter) owner repo rev sha256;
    };
  };
  ranger-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "ranger-vim";
    src = pkgs.fetchFromGitHub {
      inherit (sources.ranger-vim) owner repo rev sha256;
    };
  };

}

