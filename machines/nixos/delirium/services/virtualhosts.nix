{ pkgs, config, lib, ... }:
with lib;
let
  genericWebsites = [ "unixpimps.net" "shouldidrink.today" "beevpn.com" ];
in
{
  services.nginx.virtualHosts = lib.genAttrs genericWebsites (site:
    (mkMerge [
      {
        serverAliases = [ "www.${site}" ];
        http2 = true;
        forceSSL = true;
        enableACME = true;
        root = "/var/www/${site}/html";
        extraConfig = ''
          if ($http_host != "${site}") {
            rewrite ^ https://${site}$request_uri permanent;
          }
        '';
      }
      (mkIf (site == "unixpimps.net") {
        default = true;
      })
    ])
  );

  systemd.tmpfiles.rules = forEach genericWebsites
    (site:
      "d /var/www/${site} 0755 nginx nginx"
    ) ++ forEach genericWebsites (site:
    "d /var/www/${site}/html 0755 nginx nginx"
  );

  services.borgbackup.jobs.services = {
    paths = forEach genericWebsites (site: "/var/www/${site}/html");
  };
}
