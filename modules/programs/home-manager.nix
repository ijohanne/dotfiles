{ pkgs, ... }:
{
  programs = {
    home-manager = {
      enable = true;
      path = "${pkgs.niv-sources.home-manager}";
    };
  };
}
