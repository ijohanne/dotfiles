{ pkgs, ... }:

{

  programs.vscode = {
    enable = true;
    extensions = [ pkgs.vscode-extensions.bbenoist.Nix ];
    userSettings = { "editor.fontFamily" = "'Inconsolata'"; };
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
  };

}
