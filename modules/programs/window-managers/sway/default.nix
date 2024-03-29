{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.window-managers.sway;
in
{
  imports = [ ./waybar.nix ];

  config = mkIf (cfg.enable) {
    home.file.".wallpapers".source = ../../../../images/backgrounds;

    home.packages = with pkgs; [
      bemenu
      mako
      grim
      slurp
      xdg-user-dirs
      wl-clipboard
      wofi
      dmenu
      xwayland
      swayidle
      swaylock
      libappindicator-gtk3
    ];

    wayland.windowManager.sway =
      let
        wallpaperCommand = "find ~/.wallpapers/* | shuf -n 1";
        modifier = "Mod4";
      in
      {
        enable = true;
        package = pkgs.sway;
        wrapperFeatures.gtk = true;

        extraConfig = ''
          default_border normal 1
          exec ${pkgs.swayidle}/bin/swayidle \
              timeout 300 '${pkgs.swaylock}/bin/swaylock -f -c 000000' \
              timeout 3600 'swaymsg "output * dpms off"' \
                   resume 'swaymsg "output * dpms on"' \
              before-sleep '${pkgs.swaylock}/bin/swaylock -f -c 000000'
          workspace 1
          for_window [title="Firefox — Sharing Indicator"] floating enable
          for_window [title="Firefox — Sharing Indicator"] no_focus
        '';

        config = {
          output = {
            "*" = { bg = "`${wallpaperCommand}` fill"; };

            "DP-2" = { resolution = "3840x2160 position 0,0 scale 1.0"; };
            "DP-3" = { resolution = "3840x2160 position 3840,0 scale 1.0"; };
          };

          input."*" = { };

          bars = [ ];

          fonts = [ "Inconsolata 10" ];
          terminal = "alacritty";
          menu = "${pkgs.wofi}/bin/wofi --show drun";

          startup = [
            {
              command = "systemctl --user restart mako";
              always = true;
            }
            {
              command = "systemctl --user restart waybar";
              always = true;
            }
          ] ++ optionals (config.dotfiles.x11.office.seafile-client.enable) [
            {
              command = "${pkgs.seafile-client}/bin/seafile-applet";
              always = true;
            }
          ];

          keybindings = {
            "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";

            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            "${modifier}+Shift+space" = "floating toggle";
            "${modifier}+space" = "focus mode_toggle";

            "${modifier}+2" = "workspace 2";
            "${modifier}+3" = "workspace 3";
            "${modifier}+4" = "workspace 4";
            "${modifier}+5" = "workspace 5";
            "${modifier}+6" = "workspace 6";
            "${modifier}+7" = "workspace 7";
            "${modifier}+8" = "workspace 8";
            "${modifier}+9" = "workspace 9";
            "${modifier}+0" = "workspace 10";
            "${modifier}+1" = "workspace 1";

            "${modifier}+Shift+1" = "move container to workspace 1";
            "${modifier}+Shift+2" = "move container to workspace 2";
            "${modifier}+Shift+3" = "move container to workspace 3";
            "${modifier}+Shift+4" = "move container to workspace 4";
            "${modifier}+Shift+5" = "move container to workspace 5";
            "${modifier}+Shift+6" = "move container to workspace 6";
            "${modifier}+Shift+7" = "move container to workspace 7";
            "${modifier}+Shift+8" = "move container to workspace 8";
            "${modifier}+Shift+9" = "move container to workspace 9";
            "${modifier}+Shift+0" = "move container to workspace 10";

            "${modifier}+Shift+q" = "kill";

            "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show drun";
            "${modifier}+l" = "exec '${pkgs.swaylock}/bin/swaylock -f -c 000000'";

            "${modifier}+b" = "split h";
            "${modifier}+v" = "split v";
            "${modifier}+f" = "fullscreen toggle";

            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+e" = "exit";

            "${modifier}+r" = "mode resize";

            "XF86AudioRaiseVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessDown" =
              "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
            "XF86MonBrightnessUp" =
              "exec ${pkgs.brightnessctl}/bin/brightnessctl set +2%";
            "${modifier}+g" =
              "exec ${pkgs.grim}/bin/grim $(xdg-user-dir DOWNLOAD)/$(date +'%Y-%m-%d-%H%M%S_screenshot.png')";
            "${modifier}+Shift+g" =
              "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - $(xdg-user-dir DOWNLOAD)/$(date +'%Y-%m-%d-%H%M%S_screenshot.png')";
          };

        };
      };
    services.waybar =
      let
        waybar-yubikey-scripts = pkgs.writeShellScriptBin "yubikey-touch-detect" ''
          socket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/yubikey-touch-detector.socket"

          while true; do
              touch_reasons=()

              if [ ! -e "$socket" ]; then
                  printf '{"text": "Waiting for YubiKey socket"}\n'
                  while [ ! -e "$socket" ]; do ${pkgs.coreutils}/bin/sleep 1; done
              fi
              printf '{"text": ""}\n'

              ${pkgs.libressl.nc}/bin/nc -U "$socket" | while read -n5 cmd; do
                  reason="''${cmd:0:3}"

                  if [ "''${cmd:4:1}" = "1" ]; then
                      touch_reasons+=("$reason")
                  else
                      for i in "''${!touch_reasons[@]}"; do
                          if [ "''${touch_reasons[i]}" = "$reason" ]; then
                              unset 'touch_reasons[i]'
                              break
                          fi
                      done
                  fi

                  if [ "''${#touch_reasons[@]}" -eq 0 ]; then
                      printf '{"text": ""}\n'
                  else
                      tooltip="YubiKey is waiting for a touch, reasons: ''${touch_reasons[@]}"
                      printf '{"text": "   ", "tooltip": "%s"}\n' "$tooltip"
                  fi
              done

              ${pkgs.coreutils}/bin/sleep 1
              done
        '';
      in
      {
        enable = true;
        config = {
          battery = {
            format = "{icon}  {capacity}% {time}";
            format-charging = "{icon}  {capacity}%";
            format-icons = [ "" "" "" "" "" ];
            interval = 10;
            states = {
              critical = 20;
              warning = 30;
            };
          };
          clock = {
            format = "{:%a %Y-%m-%d %H:%M:%S}";
            interval = 1;
          };
          cpu = { format = " {}%"; };
          memory = { format = " {}%"; };
          modules-center = [ "clock" "custom/yktouch" ];
          modules-left = [ "sway/workspaces" "sway/mode" "tray" ];
          modules-right = [ "battery" "cpu" "memory" "pulseaudio" ];
          pulseaudio = {
            format = "{icon} {volume}%";
            format-icons = [ "" "" ];
            format-muted = "";
          };
          "sway/workspaces" = {
            all-outputs = false;
            disable-scroll = true;
            format = "{name}";
          };
          "sway/window" = {
            format = "{}";
            max-length = 50;
          };
          "custom/yktouch" = {
            format = "{}";
            return-type = "json";
            tooltip = true;
            exec = "${waybar-yubikey-scripts}/bin/yubikey-touch-detect";
          };
        };
      };
  };

}
