{ id, enable, datadir, ... }: { pkgs, config, ... }:
let
  bash = "/run/current-system/sw/bin/bash";
  chmod = "/run/current-system/sw/bin/chmod";
  peerPort = 40000 + id;
  floodPort = 42000 + id;
  controlPort = 43000 + id;
  rpcSocket = "${datadir}/rtorrent.sock";
  session = "${datadir}/rtorrent.dtach";
  pidFile = "${datadir}/rtorrent.pid";
  rtorrentRC = pkgs.writeText "rtorrent.rc" ''
    directory.default.set                 = ${datadir}/Downloads
    session.path.set                      = ${datadir}/sessions
    network.scgi.open_port                = 127.0.0.1:${toString controlPort}
    network.port_range.set                = ${toString peerPort}-${toString peerPort}
    network.port_random.set               = no
    protocol.encryption.set               = allow_incoming,try_outgoing,enable_retry
    protocol.pex.set                      = no
    dht.mode.set                          = off
    throttle.max_uploads.set = 10000
    execute.nothrow = ${bash}, -c, (cat, "echo -n > ${pidFile} ", (system.pid))
  '';
in
{
  users.extraUsers.rtorrent = {
    isNormalUser = true;
    group = "nogroup";
  };
  networking.firewall = {
    allowedTCPPorts = [ peerPort ];
    allowedUDPPorts = [ peerPort ];
  };
  systemd.tmpfiles.rules = [
    "d /var/data/torrent 0775 rtorrent nogroup"
    "d ${datadir} 0775 rtorrent nogroup"
  ];
  systemd.services = {
    "rtorrent-${toString id}" =
      let
        kill = "/run/current-system/sw/bin/kill";
        dtach = "${pkgs.dtach}/bin/dtach";
        rtorrent = "${pkgs.rtorrent}/bin/rtorrent";
      in
      {
        enable = enable;
        preStart = ''
          mkdir -m 0700 -p ${datadir}
          chown rtorrent ${datadir}
          if [ -f ${session} ]; then
            rm ${session}
          fi
        '';
        serviceConfig = {
          User = "rtorrent";
          Group = "nogroup";
          Type = "forking";
          KillMode = "none";
          ExecStartPre = [
            ("+" + pkgs.writeShellScript "rtorrent" ''
              mkdir -p ${datadir}/sessions
              chown -R rtorrent:nogroup ${datadir}/sessions
              mkdir -p ${datadir}/Downloads
              chown -R rtorrent:nogroup ${datadir}/Downloads
            '')
          ];
          ExecStop = "${bash} -c '${kill} -s 15 `cat ${pidFile}` || true'";
          ExecStart = "${dtach} -n ${session} -E -z ${rtorrent} -n -o import=${rtorrentRC}";
          Restart = "on-failure";
        };
        environment = {
          TERM = "xterm";
        };
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "local-fs.target" ];
      };
    "flood-${toString id}" = {
      enable = enable;
      serviceConfig = {
        User = "rtorrent";
        WorkingDirectory = "${datadir}";
        ExecStart = "${pkgs.flood}/bin/flood --rthost 127.0.0.1 --rtport ${toString controlPort} -p ${toString floodPort} --auth none";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "rtorrent-${toString id}.service" ];
    };
  };
}
