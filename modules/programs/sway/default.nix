{ pkgs, ... }: {

  imports = [ ./waybar.nix ];
  home.file.".wallpapers".source = ../../../backgrounds;

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

  wayland.windowManager.sway = let
    wallpaperCommand = "find ~/.wallpapers/* | shuf -n 1";
    modifier = "Mod4";
  in {
    enable = true;
    package = pkgs.sway;
    wrapperFeatures.gtk = true;

    extraConfig = ''
      default_border pixel 0
      exec ${pkgs.swayidle}/bin/swayidle \
          timeout 300 '${pkgs.swaylock}/bin/swaylock -f -c 000000' \
          timeout 3600 'swaymsg "output * dpms off"' \
               resume 'swaymsg "output * dpms on"' \
          before-sleep '${pkgs.swaylock}/bin/swaylock -f -c 000000'
    '';

    config = {
      output = {
        "*" = { bg = "`${wallpaperCommand}` fill"; };

        "DP-2" = { resolution = "3840x2160 position 0,0 scale 1.0"; };
        "DP-3" = { resolution = "3840x2160 position 3840,0 scale 1.0"; };
      };

      input."*" = { };

      bars = [ ];

      fonts = [ "DejaVu Sans 11" ];
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

        "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show drun";
        "${modifier}+l" = "exec 'swaylock -f -c 000000'";

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
          "exec ${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" =
          "exec ${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" =
          "exec ${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" =
          "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
        "XF86MonBrightnessUp" =
          "exec ${pkgs.brightnessctl}/bin/brightnessctl set +2%";
        "${modifier}+g" =
          "exec ${pkgs.grim} $(xdg-user-dir DOWNLOAD)/$(date +'%Y-%m-%d-%H%M%S_grim.png')";
        "${modifier}+Shift+g" =
          "exec ${pkgs.slurp} | ${pkgs.grim} -g - $(xdg-user-dir DOWNLOAD)/$(date +'%Y-%m-%d-%H%M%S_grim.png')";
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
    };
  };

}

