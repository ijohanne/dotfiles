{ pkgs, ... }:

{

  programs.light.enable = true;

  hardware.pulseaudio = {
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    };
    systemWide = true;
  };

  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 224 ];
        events = [ "key" ];
        command = "${pkgs.light}/bin/light -U 10";
      }
      {
        keys = [ 225 ];
        events = [ "key" ];
        command = "${pkgs.light}/bin/light -A 10";
      }
      {
        keys = [ 113 143 ];
        events = [ "key" ];
        command =
          "${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-sink-mute @DEFAULT_SINK@ toggle";
      }
      {
        keys = [ 114 143 ];
        events = [ "key" "rep" ];
        command =
          "${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-sink-volume @DEFAULT_SINK@ -5%";
      }
      {
        keys = [ 115 143 ];
        events = [ "key" "rep" ];
        command =
          "${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-sink-volume @DEFAULT_SINK@ +5%";
      }
      {
        keys = [ 190 ];
        events = [ "key" ];
        command =
          "${pkgs.pulseaudio}/bin/pactl -s 127.0.0.1 set-source-mute @DEFAULT_SOURCE@ toggle";
      }
    ];
  };
}
