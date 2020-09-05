{ pkgs, ... }:

{
  services.gpg-agent.enable = true;
  services.lorri.enable = true;
}
