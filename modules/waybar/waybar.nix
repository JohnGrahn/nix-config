# Waybar configuration
{ config, lib, pkgs, ... }:

{
  # Enable Waybar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;

      modules-left =
        [ "hyprland/workspaces" "hyprland/mode" "hyprland/window" ];

      modules-center = [ "clock" ];

      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "tray"
      ];

      # Module configuration
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";
        };
        on-click = "activate";
        all-outputs = true;
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };

      clock = {
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
        format-alt = "{:%Y-%m-%d}";
        format = "{:%H:%M}";
        interval = 1;
      };

      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };

      memory = { format = "{}% "; };

      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [ "" "" "" "" "" ];
      };

      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "Connected  ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        on-click = "nm-connection-editor";
      };

      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
    }];
  };

  # Create Waybar style.css with Catppuccin Mocha theming
  xdg.configFile."waybar/style.css".text = ''
    /* Catppuccin Mocha Theme for Waybar */

    /* Import Catppuccin colors */
    @define-color base   #1e1e2e;
    @define-color mantle #181825;
    @define-color crust  #11111b;

    @define-color text     #cdd6f4;
    @define-color subtext0 #a6adc8;
    @define-color subtext1 #bac2de;

    @define-color surface0 #313244;
    @define-color surface1 #45475a;
    @define-color surface2 #585b70;

    @define-color overlay0 #6c7086;
    @define-color overlay1 #7f849c;
    @define-color overlay2 #9399b2;

    @define-color blue      #89b4fa;
    @define-color lavender  #b4befe;
    @define-color sapphire  #74c7ec;
    @define-color sky       #89dceb;
    @define-color teal      #94e2d5;
    @define-color green     #a6e3a1;
    @define-color yellow    #f9e2af;
    @define-color peach     #fab387;
    @define-color maroon    #eba0ac;
    @define-color red       #f38ba8;
    @define-color mauve     #cba6f7;
    @define-color pink      #f5c2e7;
    @define-color flamingo  #f2cdcd;
    @define-color rosewater #f5e0dc;

    * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: JetBrains Mono Nerd Font, Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
        border-radius: 8px;
    }

    window#waybar {
        background-color: rgba(30, 30, 46, 0.9);  /* base with transparency */
        border-bottom: 3px solid @surface0;
        color: @text;
        transition-property: background-color;
        transition-duration: .5s;
    }

    window#waybar.hidden {
        opacity: 0.2;
    }

    /*
    window#waybar.empty {
        background-color: transparent;
    }
    window#waybar.solo {
        background-color: #FFFFFF;
    }
    */

    button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 8px;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    button:hover {
        background: inherit;
        box-shadow: inset 0 -3px @blue;
    }

    #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: @text;
        margin: 3px;
    }

    #workspaces button:hover {
        background: @surface0;
    }

    #workspaces button.active {
        background-color: @surface1;
        box-shadow: inset 0 -3px @mauve;
    }

    #workspaces button.urgent {
        background-color: @red;
    }

    #mode {
        background-color: @surface0;
        border-bottom: 3px solid @text;
    }

    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #mpd {
        padding: 0 10px;
        color: @text;
        margin: 3px 0;
    }

    #window,
    #workspaces {
        margin: 0 4px;
    }

    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }

    #clock {
        background-color: @surface1;
        color: @mauve;
    }

    #battery {
        background-color: @surface1;
        color: @green;
    }

    #battery.charging, #battery.plugged {
        color: @green;
        background-color: @surface1;
    }

    @keyframes blink {
        to {
            background-color: @text;
            color: @base;
        }
    }

    #battery.critical:not(.charging) {
        background-color: @red;
        color: @text;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    label:focus {
        background-color: @base;
    }

    #cpu {
        background-color: @surface1;
        color: @blue;
    }

    #memory {
        background-color: @surface1;
        color: @peach;
    }

    #disk {
        background-color: @surface1;
        color: @sapphire;
    }

    #backlight {
        background-color: @surface1;
        color: @teal;
    }

    #network {
        background-color: @surface1;
        color: @flamingo;
    }

    #network.disconnected {
        background-color: @red;
    }

    #pulseaudio {
        background-color: @surface1;
        color: @yellow;
    }

    #pulseaudio.muted {
        background-color: @surface0;
        color: @overlay1;
    }

    #custom-media {
        background-color: @surface1;
        color: @lavender;
        min-width: 100px;
    }

    #custom-media.custom-spotify {
        background-color: @green;
    }

    #custom-media.custom-vlc {
        background-color: @yellow;
    }

    #temperature {
        background-color: @surface1;
        color: @teal;
    }

    #temperature.critical {
        background-color: @red;
    }

    #tray {
        background-color: @surface0;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: @red;
    }

    #idle_inhibitor {
        background-color: @surface0;
    }

    #idle_inhibitor.activated {
        background-color: @text;
        color: @base;
    }

    #mpd {
        background-color: @surface1;
        color: @lavender;
    }

    #mpd.disconnected {
        background-color: @red;
    }

    #mpd.stopped {
        background-color: @surface0;
    }

    #mpd.paused {
        background-color: @surface0;
    }

    #language {
        background-color: @surface1;
        color: @text;
        padding: 0 5px;
        margin: 0 5px;
        min-width: 16px;
    }

    #keyboard-state {
        background-color: @surface1;
        color: @flamingo;
        padding: 0 5px;
        margin: 0 5px;
        min-width: 16px;
    }

    #keyboard-state > label {
        padding: 0 5px;
    }

    #keyboard-state > label.locked {
        background-color: @red;
    }
  '';
}
