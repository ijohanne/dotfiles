{ config, pkgs, lib, ... }:

{
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  security.acme = {
    email = "mkj@opsplaza.com";
    acceptTerms = true;
  };
}
