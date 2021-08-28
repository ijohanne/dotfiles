{ secrets, config, pkgs, lib, ... }:
let
  geolite2UpdaterConfig = rec {
    databaseDir = "/var/lib/geoip-databases";
    interval = "weekly";
    geoip-updater = pkgs.writeScriptBin "geoip-updater" ''
      #!${pkgs.runtimeShell}
      skipExisting=0
      for arg in "$@"; do
        case "$arg" in
          --skip-existing)
            skipExisting=1
            echo "Option --skip-existing is set: not updating existing databases"
            ;;
          *)
            echo "Unknown argument: $arg";;
        esac
      done
      cd ${databaseDir}
      for dbName in "GeoLite2-City" "GeoLite2-Country" "GeoLite2-ASN"; do
        dbBaseUrl="https://download.maxmind.com/app/geoip_download?edition_id=$dbName&license_key=${secrets.maxmind.apiKey}&suffix=tar.gz";
        if [ "$skipExisting" -eq 1 -a -f $dbName.mmdb ]; then
          echo "Skipping existing file: $dbName.mmdb"
          continue
        fi
        ${pkgs.curl}/bin/curl -o $dbName.tar.gz $dbBaseUrl
        ${pkgs.gzip}/bin/gzip -cd $dbName.tar.gz | ${pkgs.gnutar}/bin/tar xvf -
        mv $dbName\_*/$dbName.mmdb .
        rm -rfv $dbName\_*/ $dbName.tar.gz
      done
    '';
  };
in
{

  users.users.geoip = {
    isSystemUser = true;
    group = "srv";
    description = "GeoIP database updater";
  };

  systemd.timers.geoip-updater =
    {
      description = "GeoIP Updater Timer";
      partOf = [ "geoip-updater.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = geolite2UpdaterConfig.interval;
      timerConfig.Persistent = "true";
      timerConfig.RandomizedDelaySec = "3600";
    };

  systemd.services.geoip-updater = {
    description = "GeoIP Updater";
    after = [ "network-online.target" "nss-lookup.target" ];
    wants = [ "network-online.target" ];
    preStart = with geolite2UpdaterConfig; ''
      mkdir -p "${databaseDir}"
      chmod 755 "${databaseDir}"
      chown geoip:srv "${databaseDir}"
    '';
    serviceConfig = {
      ExecStart = "${geolite2UpdaterConfig.geoip-updater}/bin/geoip-updater";
      User = "geoip";
      PermissionsStartOnly = true;
    };
  };

  systemd.services.geoip-updater-setup = {
    description = "GeoIP Updater Setup";
    after = [ "network-online.target" "nss-lookup.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    conflicts = [ "geoip-updater.service" ];
    preStart = with geolite2UpdaterConfig; ''
      mkdir -p "${databaseDir}"
      chmod 755 "${databaseDir}"
      chown geoip:srv "${databaseDir}"
    '';
    serviceConfig = {
      ExecStart = "${geolite2UpdaterConfig.geoip-updater}/bin/geoip-updater --skip-existing";
      User = "geoip";
      PermissionsStartOnly = true;
      # So it won't be (needlessly) restarted:
      RemainAfterExit = true;
    };
  };
}
