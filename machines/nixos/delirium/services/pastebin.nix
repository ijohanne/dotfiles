{ config, pkgs, lib, ... }:
let
  pastebin-src = builtins.fetchTarball {
    name = "fincham-paste";
    url = "https://api.github.com/repos/fincham/paste/tarball/master";
    sha256 = "1dgp5aynw9g9dghma6if7fwp61g0m73g2h4rb1741vj194h7sq2d";
  };
  appEnv = pkgs.python3.withPackages (p: with p; [ waitress pastebin ]);

  apparmor_profile = pkgs.writeText "paste.apparmor" ''
    #include <tunables/global>
      
    ${appEnv}/bin/waitress-serve {
        #include <abstractions/base>
        ${appEnv}/bin/waitress-serve r,
    }
  '';
  pastebin = with pkgs.python3Packages; buildPythonPackage {
    name = "paste";
    src = "${pastebin-src}/paste";

    propagatedBuildInputs = [ flask ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/${python.sitePackages}
      cp -r . $out/${python.sitePackages}/paste
      runHook postInstall
    '';

    shellHook = "export FLASK_APP=paste";

    format = "other";
  };

in
{
  users.users.paste = {
    isSystemUser = true;
    group = "paste";
    description = "Paste daemon user";
  };

  systemd.tmpfiles.rules =
    [
      "d /var/www/paste.unixpimps.net 0700 paste paste"
    ];

  users.groups.paste.gid = null;
  services.nginx.virtualHosts = {
    "paste.unixpimps.net" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/paste.unixpimps.net";
      locations."/" = {
        proxyPass = "http://localhost:4000";
      };
    };
  };

  systemd.services.paste = {
    wantedBy = [ "multi-user.target" ];
    description = "Encrypted pastebin server";
    unitConfig.Documentation = "https://github.com/fincham/paste";
    environment = {
      PASTE_PATH = "/var/www/paste.unixpimps.net";
      PASTE_ID_LENGTH = "16";
      PASTE_KEY_LENGTH = "32";
    };
    serviceConfig = {
      ExecStart = "${appEnv}/bin/waitress-serve --listen=127.0.0.1:4000 paste:app";
      User = "paste";
      Group = "paste";
      StandardOutput = "syslog";
      StandardError = "syslog";
      SyslogIdentifier = "paste";
    };
  };
}
