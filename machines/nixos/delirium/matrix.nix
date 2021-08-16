{ secrets, config, pkgs, lib, ... }:
let
  domain = "unixpimps.net";
  emailConfig = {
    smtpHost = "delirium.unixpimps.net";
    smtpUser = secrets.matrix.smtpUser;
    smtpPass = secrets.matrix.smtpPass;
    smtpPort = 25;
    notifFrom = "Your Friendly %(app)s homeserver <no-reply@unixpimps.net>";
  };
  federationPort = { public = 8448; private = 11338; };
  clientPort = { public = 443; private = 11339; };
in
{
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.matrix-synapse = {
    enable = true;
    server_name = "unixpimps.net";
    public_baseurl = "https://matrix.${domain}";

    registration_shared_secret = secrets.matrix.registration_shared_secret;

    listeners = [
      # Federation
      {
        bind_address = "::1";
        port = federationPort.private;
        tls = false; # Terminated by nginx.
        x_forwarded = true;
        resources = [{ names = [ "federation" ]; compress = false; }];
      }

      # Client
      {
        bind_address = "::1";
        port = clientPort.private;
        tls = false; # Terminated by nginx.
        x_forwarded = true;
        resources = [{ names = [ "client" ]; compress = false; }];
      }
    ];

    account_threepid_delegates.msisdn = "https://vector.im";

    extraConfig = ''
      experimental_features: { spaces_enabled: true }
      use_presence: false
      email:
        # The hostname of the outgoing SMTP server to use. Defaults to 'localhost'.
        #
        smtp_host: "${emailConfig.smtpHost}"
        # The port on the mail server for outgoing SMTP. Defaults to 25.
        #
        smtp_port: ${toString emailConfig.smtpPort}
        # Username/password for authentication to the SMTP server. By default, no
        # authentication is attempted.
        #
        smtp_user: "${emailConfig.smtpUser}"
        smtp_pass: "${emailConfig.smtpPass}"
        # Uncomment the following to require TLS transport security for SMTP.
        # By default, Synapse will connect over plain text, and will then switch to
        # TLS via STARTTLS *if the SMTP server supports it*. If this option is set,
        # Synapse will refuse to connect unless the server supports STARTTLS.
        #
        require_transport_security: False
        # notif_from defines the "From" address to use when sending emails.
        # It must be set if email sending is enabled.
        #
        # The placeholder '%(app)s' will be replaced by the application name,
        # which is normally 'app_name' (below), but may be overridden by the
        # Matrix client application.
        #
        # Note that the placeholder must be written '%(app)s', including the
        # trailing 's'.
        #
        notif_from: "${emailConfig.notifFrom}"
    '';

    logConfig = ''
      version: 1
      # In systemd's journal, loglevel is implicitly stored, so let's omit it
      # from the message text.
      formatters:
          journal_fmt:
              format: '%(name)s: [%(request)s] %(message)s'
      filters:
          context:
              (): synapse.util.logcontext.LoggingContextFilter
              request: ""
      handlers:
          journal:
              class: systemd.journal.JournalHandler
              formatter: journal_fmt
              filters: [context]
              SYSLOG_IDENTIFIER: synapse
      root:
          level: WARN
          handlers: [journal]
      disable_existing_loggers: False
    '';
  };

  services.nginx = {
    virtualHosts = {
      "matrix.${domain}" = {
        onlySSL = true;
        enableACME = true;

        locations =
          let
            proxyToClientPort = {
              proxyPass = "http://[::1]:${toString clientPort.private}";
            };
          in
          {
            # Or do a redirect instead of the 404, or whatever is appropriate
            # for you. But do not put a Matrix Web client here! See the
            # Element web section below.
            "/".return = "404";

            "/_matrix" = proxyToClientPort;
            "/_synapse/client" = proxyToClientPort;
          };

        listen = [
          { addr = "0.0.0.0"; port = clientPort.public; ssl = true; }
          { addr = "[::]"; port = clientPort.public; ssl = true; }
        ];

      };

      # same as above, but listening on the federation port
      "matrix.${domain}_federation" = rec {
        onlySSL = true;
        serverName = "matrix.${domain}";
        enableACME = true;

        locations."/".return = "404";

        locations."/_matrix" = {
          proxyPass = "http://[::1]:${toString federationPort.private}";
        };

        listen = [
          { addr = "0.0.0.0"; port = federationPort.public; ssl = true; }
          { addr = "[::]"; port = federationPort.public; ssl = true; }
        ];

      };

      "${domain}" = {
        forceSSL = true;
        enableACME = true;

        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "matrix.${domain}:${toString federationPort.public}"; };
          in
          ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" = { "base_url" = "https://matrix.${domain}"; };
              "m.identity_server" = { "base_url" = "https://vector.im"; };
            };
            # ACAO required to allow element-web on any URL to request this json file
          in
          ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
      };

      # Element Web app deployment
      #
      "chat.${domain}" = {
        enableACME = true;
        forceSSL = true;

        root = pkgs.element-web.override {
          conf = {
            default_server_config = {
              "m.homeserver" = {
                "base_url" = "https://matrix.${domain}";
                "server_name" = "${domain}";
              };
              "m.identity_server" = {
                "base_url" = "https://vector.im";
              };
            };
            showLabsSettings = true;
            defaultCountryCode = "UK"; # cocorico
            roomDirectory = {
              "servers" = [
                "matrix.org"
                "mozilla.org"
                "prologin.org"
              ];
            };
          };
        };
      };
    };
  };

  environment.systemPackages = [ pkgs.matrix-synapse ];

  networking.firewall.allowedTCPPorts = [
    clientPort.public
    federationPort.public
  ];
}
