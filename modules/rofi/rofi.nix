# Rofi configuration with Catppuccin Mocha theming
{ config, lib, pkgs, ... }:

{
  # Enable rofi
  programs.rofi = {
    enable = true;

    # Use the wayland version
    package = pkgs.rofi-wayland;

    # Extra configuration
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-ssh = "   SSH ";
      sidebar-mode = true;
    };

    # Catppuccin Mocha theme - use the generated config file
    theme = "${config.xdg.configHome}/rofi/theme.rasi";
  };

  # Create the Catppuccin Mocha theme file for Rofi
  xdg.configFile."rofi/theme.rasi" = {
    text = ''
      /*
       * Catppuccin Mocha theme for Rofi
       */

      * {
          bg-col:  #1e1e2e;
          bg-col-light: #313244;
          border-col: #cba6f7;
          selected-col: #313244;
          blue: #89b4fa;
          fg-col: #cdd6f4;
          fg-col2: #f38ba8;
          grey: #6c7086;

          width: 800;
          font: "JetBrainsMono Nerd Font 12";
      }

      element-text, element-icon , mode-switcher {
          background-color: inherit;
          text-color:       inherit;
      }

      window {
          height: 500px;
          border: 3px;
          border-color: @border-col;
          background-color: @bg-col;
          border-radius: 12px;
      }

      mainbox {
          background-color: @bg-col;
      }

      inputbar {
          children: [prompt,entry];
          background-color: @bg-col;
          border-radius: 5px;
          padding: 2px;
      }

      prompt {
          background-color: @blue;
          padding: 6px;
          text-color: @bg-col;
          border-radius: 3px;
          margin: 20px 0px 0px 20px;
      }

      textbox-prompt-colon {
          expand: false;
          str: ":";
      }

      entry {
          padding: 6px;
          margin: 20px 0px 0px 10px;
          text-color: @fg-col;
          background-color: @bg-col;
      }

      listview {
          border: 0px 0px 0px;
          padding: 6px 0px 0px;
          margin: 10px 0px 0px 20px;
          columns: 2;
          lines: 10;
          background-color: @bg-col;
      }

      element {
          padding: 5px;
          background-color: @bg-col;
          text-color: @fg-col;
          border-radius: 5px;
      }

      element-icon {
          size: 25px;
      }

      element selected {
          background-color:  @selected-col;
          text-color: @fg-col2;
      }

      mode-switcher {
          spacing: 0;
      }

      button {
          padding: 10px;
          background-color: @bg-col-light;
          text-color: @grey;
          vertical-align: 0.5; 
          horizontal-align: 0.5;
      }

      button selected {
          background-color: @bg-col;
          text-color: @blue;
      }

      message {
          background-color: @bg-col-light;
          margin: 2px;
          padding: 2px;
          border-radius: 5px;
      }

      textbox {
          padding: 6px;
          margin: 20px 0px 0px 20px;
          text-color: @blue;
          background-color: @bg-col-light;
      }
    '';
  };

  # Create additional Rofi scripts for convenience

  # Power menu script
  home.file.".local/bin/rofi-power-menu" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Power menu options
      shutdown="Shutdown"
      reboot="Reboot"
      lock="Lock"
      suspend="Suspend"
      logout="Logout"

      # Get selection from rofi
      selected=$(echo -e "$shutdown\n$reboot\n$lock\n$suspend\n$logout" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/power-menu.rasi)

      # Execute the selected option
      if [[ $selected = $shutdown ]]; then
          systemctl poweroff
      elif [[ $selected = $reboot ]]; then
          systemctl reboot
      elif [[ $selected = $lock ]]; then
          if command -v swaylock >/dev/null 2>&1; then
              swaylock -f
          elif command -v waylock >/dev/null 2>&1; then
              waylock
          else
              hyprctl dispatch exit
          fi
      elif [[ $selected = $suspend ]]; then
          systemctl suspend
      elif [[ $selected = $logout ]]; then
          hyprctl dispatch exit
      fi
    '';
  };

  # Power menu theme
  xdg.configFile."rofi/power-menu.rasi" = {
    text = ''
      /*
       * Catppuccin Mocha theme for Rofi Power Menu
       */

      * {
          bg-col:  #1e1e2e;
          bg-col-light: #313244;
          border-col: #f38ba8;
          selected-col: #313244;
          red: #f38ba8;
          blue: #89b4fa;
          fg-col: #cdd6f4;
          fg-col2: #f38ba8;
          grey: #6c7086;

          width: 400px;
          font: "JetBrainsMono Nerd Font 12";
      }

      element-text, element-icon , mode-switcher {
          background-color: inherit;
          text-color:       inherit;
      }

      window {
          height: 300px;
          border: 3px;
          border-color: @border-col;
          background-color: @bg-col;
          border-radius: 12px;
      }

      mainbox {
          background-color: @bg-col;
      }

      inputbar {
          children: [prompt,entry];
          background-color: @bg-col;
          border-radius: 5px;
          padding: 2px;
      }

      prompt {
          background-color: @red;
          padding: 6px;
          text-color: @bg-col;
          border-radius: 3px;
          margin: 20px 0px 0px 20px;
      }

      textbox-prompt-colon {
          expand: false;
          str: ":";
      }

      entry {
          padding: 6px;
          margin: 20px 0px 0px 10px;
          text-color: @fg-col;
          background-color: @bg-col;
      }

      listview {
          border: 0px 0px 0px;
          padding: 6px 0px 0px;
          margin: 10px 0px 0px 20px;
          columns: 1;
          lines: 5;
          background-color: @bg-col;
      }

      element {
          padding: 15px;
          background-color: @bg-col;
          text-color: @fg-col;
          border-radius: 5px;
      }

      element selected {
          background-color:  @selected-col;
          text-color: @fg-col2;
      }

      button {
          padding: 10px;
          background-color: @bg-col-light;
          text-color: @grey;
          vertical-align: 0.5; 
          horizontal-align: 0.5;
      }

      button selected {
          background-color: @bg-col;
          text-color: @red;
      }

      message {
          background-color: @bg-col-light;
          margin: 2px;
          padding: 2px;
          border-radius: 5px;
      }

      textbox {
          padding: 6px;
          margin: 20px 0px 0px 20px;
          text-color: @red;
          background-color: @bg-col-light;
      }
    '';
  };
}
