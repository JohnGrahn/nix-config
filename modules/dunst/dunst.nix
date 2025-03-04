# Dunst notification daemon configuration with Catppuccin Mocha theming
{ config, lib, pkgs, ... }:

let
  # Catppuccin Mocha colors
  colors = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };

in {
  # Enable Dunst notification daemon
  services.dunst = {
    enable = true;

    # Global settings
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 20;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Appearance
        indicate_hidden = true;
        shrink = false;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = colors.mauve;
        separator_color = "frame";
        sort = true;
        idle_threshold = 120;

        # Text
        font = "JetBrainsMono Nerd Font 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;

        # History
        sticky_history = true;
        history_length = 20;

        # Misc/Advanced
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "${pkgs.brave}/bin/brave -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;

        # Wayland
        layer = "top";
        force_xwayland = false;

        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      # Theming based on Catppuccin Mocha
      urgency_low = {
        background = colors.base;
        foreground = colors.text;
        frame_color = colors.lavender;
        timeout = 10;
      };

      urgency_normal = {
        background = colors.base;
        foreground = colors.text;
        frame_color = colors.mauve;
        timeout = 10;
      };

      urgency_critical = {
        background = colors.base;
        foreground = colors.text;
        frame_color = colors.red;
        timeout = 0;
      };
    };
  };

  # Add custom scripts for notifications

  # Volume notification
  home.file.".local/bin/volume-notification" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Get volume level and mute status
      volume=$(pamixer --get-volume)
      mute=$(pamixer --get-mute)

      # Define icons
      if [[ "$mute" == "true" ]]; then
          icon="notification-audio-volume-muted"
          summary="Volume Muted"
      else
          if [ "$volume" -lt 30 ]; then
              icon="notification-audio-volume-low"
          elif [ "$volume" -lt 70 ]; then
              icon="notification-audio-volume-medium"
          else
              icon="notification-audio-volume-high"
          fi
          summary="Volume: $volume%"
      fi

      # Send notification
      dunstify -a "Volume" -u low -i "$icon" -h string:x-dunst-stack-tag:volume -h int:value:"$volume" "$summary"
    '';
  };

  # Brightness notification
  home.file.".local/bin/brightness-notification" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Get brightness percentage
      brightness=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')

      # Define icon
      if [ "$brightness" -lt 30 ]; then
          icon="notification-display-brightness-low"
      elif [ "$brightness" -lt 70 ]; then
          icon="notification-display-brightness-medium"
      else
          icon="notification-display-brightness-high"
      fi

      # Send notification
      dunstify -a "Brightness" -u low -i "$icon" -h string:x-dunst-stack-tag:brightness -h int:value:"$brightness" "Brightness: $brightness%"
    '';
  };

  # Notification for when a screenshot is taken
  home.file.".local/bin/screenshot-notification" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Requires one argument - the path to the screenshot
      if [ -z "$1" ]; then
          exit 1
      fi

      # Get the path and shrink it if needed
      path="$1"
      filename=$(basename "$path")

      # Send notification
      dunstify -a "Screenshot" -i "accessories-screenshot" -u normal "Screenshot Captured" "$filename"
    '';
  };
}
