{ pkgs, ... }:

{
  home.packages = with pkgs; [ du-dust ];
  programs.fish.shellAliases = { du = "${pkgs.du-dust}/bin/dust"; };

}

