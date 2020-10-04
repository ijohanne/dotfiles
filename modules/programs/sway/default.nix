{ pkgs,  ... }:

{

  imports = [
    ./waybar.nix
  ];
    home.file.".wallpapers".source = ../../../backgrounds;

    wayland.windowManager.sway = let
      wallpaperCommand = "find ~/.wallpapers/* | shuf -n 1";
      modifier = "Mod4";
    in {
      enable = true;
      package = pkgs.sway;
      wrapperFeatures.gtk = true;


      extraConfig = ''
        default_border pixel 0
      '';

      config = {
        output = {
          "*" = {
            bg = "\`${wallpaperCommand}\` fill";
          };

          "DP-2" = { 
            resolution = "3840x2160 position 0,0 scale 1.0";
          };
          "DP-3" = {
            resolution = "3840x2160 position 3840,0 scale 1.0";
          };
        };

        input."*" = {
        };

        bars = [];

        fonts = [ "DejaVu Sans 11" ];
        terminal = "alacritty";
        menu = "wofi --show drun";

        startup = [
          { command = "systemctl --user restart mako"; always = true; }
          { command = "systemctl --user restart waybar"; always = true; }
        ];

        keybindings = {
          "${modifier}+Return" = "exec ${pkgs.alacritty}";

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

          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";

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

          "${modifier}+d" = "exec ${pkgs.wofi} --show drun";
          "${modifier}+l" = "exec sudo ${pkgs.physlock}";

           "${modifier}+b" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exit";

          "${modifier}+r" = "mode resize";

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute $(pacmd list-sinks |awk '/* index:/{print $3}') toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute $(pacmd list-sources |awk '/* index:/{print $3}') toggle";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +2%";
          "${modifier}+g" = "exec ${pkgs.grim} $(xdg-user-dir DOWNLOAD)/$(date +'%Y-%m-%d-%H%M%S_grim.png')";
          "${modifier}+Shift+g" = "exec ${pkgs.slurp} | ${pkgs.grim} -g - $(xdg-user-dir DOWNLOAD)/$(date +'%Y-%m-%d-%H%M%S_grim.png')";
        };

      };
    };
  services.waybar = {
    enable = true;
    config = {
      battery = {
        format = "{icon} {capacity}% {time}";
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
      modules-center = [ "clock" ];
      modules-left = [ "sway/workspaces" "sway/mode" "tray" ];
      modules-right = [ "temperature" "battery" ];
      pulseaudio = {
        format = "{icon} {volume}%";
        format-icons = [ "" "" ];
        format-muted = "";
      };
      "sway/workspaces" = {
        all-outputs = true;
        disable-scroll = true;
      };
      temperature = {
        critical-threshold = 90;
        format = "{icon} {temperatureC}°C";
        format-icons = [ "" "" "" "" "" ];
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        interval = 1;
      };
    };
  };

}

