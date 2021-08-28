{ config, pkgs, lib, ... }:
let
  ngx_http_geoip2_module = pkgs.stdenv.mkDerivation rec {
    name = "ngx_http_geoip2_module-a28ceff";
    src = pkgs.fetchzip {
      url = "https://github.com/leev/ngx_http_geoip2_module/archive/a28ceffdeffb2b8ec2896bd1192a87f4f2c7a12a.zip";
      sha256 = "0ba1bjnkskd241ix7ax27n3d9klpymigm0wdjgd4yhlsgbxsxvdx";
    };
    installPhase = ''
      mkdir $out
      cp *.c config $out/
    '';
    fixupPhase = "";
  };
in
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    statusPage = true;
    package = pkgs.nginxMainline.overrideAttrs (oldAttrs: rec {
      configureFlags = oldAttrs.configureFlags ++ [ "--add-module=${ngx_http_geoip2_module}" ];
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.libmaxminddb ];
    });
    appendHttpConfig = ''
      geoip2 /var/lib/geoip-databases/GeoLite2-Country.mmdb {
        auto_reload 5m;
        $geoip2_metadata_country_build metadata build_epoch;
        $geoip2_data_country_code country iso_code;
        $geoip2_data_country_name country names en;
        $geoip2_data_continent_code continent code;
        $geoip2_data_continent_name continent names en;
      }

      geoip2 /var/lib/geoip-databases/GeoLite2-City.mmdb {
          auto_reload 5m;
          $geoip2_data_city_name city names en;
          $geoip2_data_lat location latitude;
          $geoip2_data_lon location longitude;
      }

      geoip2 /var/lib/geoip-databases/GeoLite2-ASN.mmdb {
          auto_reload 5m;
          $geoip2_data_asn autonomous_system_number;
          $geoip2_data_asorg autonomous_system_organization;
      }
      fastcgi_param MM_CONTINENT_CODE $geoip2_data_continent_code;
      fastcgi_param MM_CONTINENT_NAME $geoip2_data_continent_name;
      fastcgi_param MM_COUNTRY_CODE $geoip2_data_country_code;
      fastcgi_param MM_COUNTRY_NAME $geoip2_data_country_name;
      fastcgi_param MM_CITY_NAME    $geoip2_data_city_name;
      fastcgi_param MM_LATITUDE $geoip2_data_lat;
      fastcgi_param MM_LONGITUDE $geoip2_data_lon;
      fastcgi_param MM_ISP $geoip2_data_asorg;
    '';
  };

  networking.firewall =
    {
      allowedTCPPorts = [
        80
        443
      ];
    };
}
