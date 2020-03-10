{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    enableIcedTea = true;
  };

}
