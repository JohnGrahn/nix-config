# Cliphist clipboard manager configuration
{ config, lib, pkgs, ... }:

{
  # Install cliphist package
  home.packages = with pkgs; [
    cliphist
    wl-clipboard
  ];
  
  # Create a directory for cliphist history
  home.file.".local/share/cliphist/.keep".text = "";
  
  # Setup autostart for cliphist
  # This is also in the Hyprland config but adding here for redundancy
  xdg.configFile."hypr/cliphist.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      # Ensure we have a directory to store cliphist data
      mkdir -p "$HOME/.local/share/cliphist"
      
      # Start wl-paste tracking for text items
      wl-paste --type text --watch cliphist store &
      
      # Start wl-paste tracking for image items
      wl-paste --type image --watch cliphist store &
      
      # Start wl-paste tracking for all items (optional)
      # wl-paste --watch cliphist store &
    '';
  };
  
  # Create a script to show cliphist in rofi with Catppuccin Mocha theming
  home.file.".local/bin/rofi-cliphist" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      # A script to integrate cliphist with rofi
      
      case $1 in
        "copy")
          cliphist list | rofi -dmenu -theme ~/.config/rofi/cliphist.rasi -p "Copy:" | cliphist decode | wl-copy
          ;;
        "delete")
          cliphist list | rofi -dmenu -theme ~/.config/rofi/cliphist.rasi -p "Delete:" | cliphist delete
          ;;
        "delete-all")
          cliphist wipe
          ;;
        *)
          echo "Usage: $0 [copy|delete|delete-all]"
          exit 1
          ;;
      esac
    '';
  };
  
  # Rofi theme specifically for cliphist
  xdg.configFile."rofi/cliphist.rasi" = {
    text = ''
      /*
       * Catppuccin Mocha theme for Rofi Cliphist
       */

      * {
          bg-col:  #1e1e2e;
          bg-col-light: #313244;
          border-col: #74c7ec;
          selected-col: #313244;
          blue: #89b4fa;
          fg-col: #cdd6f4;
          fg-col2: #89b4fa;
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
          columns: 1;
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
    '';
  };
  
  # Add to systemd user services to ensure it starts reliably
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history service";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    
    Service = {
      ExecStart = "${pkgs.bash}/bin/bash ${config.xdg.configHome}/hypr/cliphist.sh";
      Restart = "always";
      RestartSec = 5;
    };
    
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
} 