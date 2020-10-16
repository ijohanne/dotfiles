{ pkgs, ... }: {
  home.packages = with pkgs; [ bottom ];
  programs.fish.shellAliases = { top = "${pkgs.bottom}/bin/btm"; };
}

