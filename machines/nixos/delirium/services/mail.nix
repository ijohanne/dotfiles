{ secrets, config, pkgs, lib, ... }:

{
  imports =
    [
      (builtins.fetchTarball {
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.05/nixos-mailserver-nixos-21.05.tar.gz";
        sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
      })
    ];

  services.roundcube = {
    enable = true;
    hostName = "webmail.unixpimps.net";
    plugins = [ "managesieve" "markasjunk" "identity_select" "additional_message_headers" "show_additional_headers" ];
    extraConfig = ''
      $config['smtp_server'] = 'tls://delirium.unixpimps.net';
    '';
  };

  mailserver = {
    enable = true;
    enablePop3 = true;
    enablePop3Ssl = true;
    enableManageSieve = true;
    fqdn = "delirium.unixpimps.net";
    domains = [ "shouldidrink.today" "perlpimp.net" "unixpimps.net" "nordic-t.me" "lujer.dk" "allporn.dk" "brugervenlig.dk" "coredump.dk" "depri.dk" "koffein.dk" "outerspace.dk" "perlpimp.dk" "syslogic.dk" "unixpimp.dk" "ddfrbr.com" "martin8412.dk" ];
    virusScanning = true;
    loginAccounts = {
      "ij@perlpimp.net" = {
        hashedPassword = secrets.mail.ij;
        aliases = [
          "ij@shouldidrink.today"
          "ij@unixpimps.net"
          "ij@syslogic.dk"
          "ij@coredump.dk"
          "ij@lujer.dk"
          "ij@perlpimp.dk"
          "ij@koffein.dk"
          "ij@outerspace.dk"
          "ij@ddfrbr.com"
          "sniffy@ddfrbr.com"
        ];
      };
      "martin@martin8412.dk" = {
        hashedPassword = secrets.mail.mj;
        aliases = [ "mj@nordic-t.me" "mj@unixpimps.net" ];
        catchAll = [ "martin8412.dk" ];
      };
      "ij@nordic-t.me" = {
        hashedPassword = secrets.mail.ij;
      };
      "mj@nordic-t.me" = {
        hashedPassword = secrets.mail.mj;
      };
      "matek@coredump.dk" = {
        hashedPassword = secrets.mail.mt;
        aliases = [
          "g@coredump.dk"
          "matek@lujer.dk"
          "matek@koffein.dk"
        ];
      };
      "no-reply@unixpimps.net" = {
        hashedPassword = secrets.mail.no-reply;
      };
      "themailer@unixpimps.net" = {
        hashedPassword = secrets.mail.themailer;
      };
      "alertmanager@unixpimps.net" = {
        hashedPassword = secrets.mail.alertmanager;
      };
    };
    forwards = {
      "hello@ddfrbr.com" = [ "ij@ddfrbr.com" ];
      "sysops@lujer.dk" = [ "ij@unixpimps.net" "mj@unixpimps.net" ];
      "hostmaster@lujer.dk" = [ "ij@unixpimps.net" "mj@unixpimps.net" ];
      "sysops@unixpimps.net" = [ "ij@unixpimps.net" "mj@unixpimps.net" ];
      "hostmaster@unixpimps.net" = [ "ij@unixpimps.net" "mj@unixpimps.net" ];
      "tech@nordic-t.me" = [ "ij@nordic-t.me" "mj@nordic-t.me" ];
      "admin@nordic-t.me" = [ "ij@nordic-t.me" "mj@nordic-t.me" ];
      "sysops@nordic-t.me" = [ "ij@nordic-t.me" "mj@nordic-t.me" ];
      "hostmaster@nordic-t.me" = [ "ij@nordic-t.me" "mj@nordic-t.me" ];
      "donation@nordic-t.me" = [ "ij@nordic-t.me" ];
      "paypal@nordic-t.me" = [ "ij@nordic-t.me" ];
    };
    certificateScheme = 3;
    borgbackup = {
      enable = true;
      repoLocation = "/var/borgbackup/mail";
    };
  };
}
