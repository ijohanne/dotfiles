{ pkgs, ... }:

{
  programs.starship = {
    enableFishIntegration = true;
    enable = true;
    settings = {
      add_newline = false;
      prompt_order = [
        "username"
        "hostname"
        "kubernetes"
        "directory"
        "git_branch"
        "git_commit"
        "git_state"
        "git_status"
        "hg_branch"
        "docker_context"
        "package"
        "dotnet"
        "elixir"
        "elm"
        "erlang"
        "golang"
        "java"
        "julia"
        "nim"
        "nodejs"
        "ocaml"
        "php"
        "purescript"
        "python"
        "ruby"
        "rust"
        "terraform"
        "zig"
        "nix_shell"
        "conda"
        "memory_usage"
        "aws"
        "env_var"
        "crystal"
        "cmd_duration"
        "custom"
        "line_break"
        "jobs"
        "battery"
        "time"
        "character"
      ];
      scan_timeout = 10;
      character.symbol = "➜";
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "🔋";
        display = [
          {
            threshold = 10;
            style = "red";
          }
          {
            threshold = 30;
            style = "yellow";
          }
          {
            threshold = 100;
            style = "green";
          }
        ];
      };

      username = {
        show_always = true;
        style_user = "blue";
      };

      hostname = {
        ssh_only = false;
        style = "cyan";
        prefix = "⟪";
        suffix = "⟫";
      };
    };
  };

}

