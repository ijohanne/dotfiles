{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.development-tools.git.enable) {
    home.packages = with pkgs; [ gitAndTools.gh ];

    programs.git = {
      enable = true;
      userName = "Ian Johannesen";
      userEmail = "ij@opsplaza.com";
      lfs.enable = true;
      extraConfig = { pull = { ff = "only"; }; };
    };
  };
}

