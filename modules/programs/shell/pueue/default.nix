{ pkgs, lib, config, ... }:
with lib;
let
  start-pueued = pkgs.writeShellScriptBin "start-pueued" ''
    echo "Generating random session secret"
    SECRET=$(head -80 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo Creating directories
    mkdir -p $HOME/.config/pueue
    echo Creating configuration
    cat > $HOME/.config/pueue/pueue.yml <<EOF
    shared:
      pueue_directory: $HOME/.local/share/pueue
      use_unix_socket: true
      unix_sockets_path: $HOME/.local/share/pueue/pueue.socket
      secret: "$SECRET"
    client:
      read_local_logs: true
      show_confirmation_questions: false
    daemon:
      default_parallel_tasks: 1
      pause_on_failure: false
      callback: "Task {{ id }}\nCommand: {{ command }}\nPath: {{ path }}\nFinished with status '{{ result }}'"
      groups:
        cpu: 1
    EOF
    echo Spawning service
    ${pkgs.pueue}/bin/pueued
  '';
in
{
  config = mkIf (config.dotfiles.shell.pueue.enable) {
    home.packages = with pkgs; [ pueue ];

    systemd.user.services.pueued = {
      Unit = {
        Description = "Pueue Daemon (user) - CLI process scheduler and manager";
      };
      Install.WantedBy = [ "default.target" ];
      Service = {
        ExecStart = "${start-pueued}/bin/start-pueued";
        ExecReload = "${start-pueued}/bin/start-pueued";
      };
    };
  };
}
