{ secrets, pkgs, ... }:
let
  cfdyndns = pkgs.cfdyndns.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "ijohanne";
      repo = "cfdyndns";
      rev = "bf191062269fc25632a841837c32e81c01f5462f";
      sha256 = "0bqpmzm4iac36c0s5pvvz0hlzgvxwda4ik6jsnizw7ygxn2qnb44";
    };
  });
in
{
  services.cfdyndns = {
    enable = true;
    email = "ops@opsplaza.com";
    records = [
      "r0.est.unixpimps.net"
    ];
  };

  systemd.services.cfdyndns = {
    environment.CLOUDFLARE_APITOKEN = secrets.cloudflare.apiToken;
    startAt = pkgs.lib.mkForce "*:0/5";
    script = pkgs.lib.mkForce ''
      ${cfdyndns}/bin/cfdyndns
    '';
  };
}
