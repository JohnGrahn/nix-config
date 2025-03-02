# Hyprland configuration
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Import Hyprland config
    ./config.nix
  ];

  # Enable the Hyprland Window Manager in Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Use the Hyprland package from our inputs (flake)
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    
    # Enable XWayland for compatibility with X11 applications
    xwayland.enable = true;
    
    # Enable systemd integration
    systemd.variables = ["--all"];
  };

  # Install necessary Hyprland-related packages
  home.packages = with pkgs; [
    # Core wayland utilities
    wl-clipboard
    wlr-randr
    
    # Monitor management tools
    inotify-tools # For monitoring file changes
    jq            # For JSON processing in scripts
    
    # Hyprland utils
    hyprpicker # Color picker
    hypridle # Idle management
    hyprcursor # Custom cursor theme support
    
    # Notification for volume/brightness control
    libnotify
    
    # Screenshot and recording tools
    grim # Screenshot utility
    slurp # Screen area selection
    swappy # Screenshot editor
    wf-recorder # Screen recording
    
    # Login utilities
    polkit-kde-agent
    
    # Audio/Media control 
    pamixer # Pulse Audio command line mixer
    playerctl # Control media players
    
    # Extra tools
    xdg-utils # For xdg-open, etc.
    xdg-desktop-portal-hyprland
    qt5.qtwayland
    qt6.qtwayland
  ];

  # Automatically start Hyprland on login
  xdg.configFile."hypr/hyprland.conf".source = config.wayland.windowManager.hyprland.finalPackage;
  
  # Create a script for manually handling monitor setup
  home.file.".local/bin/hypr-mon-ctl" = {
    text = ''
      #!/usr/bin/env bash
      
      # hypr-mon-ctl - A script to manage Hyprland monitors
      
      # Function to show usage
      show_usage() {
        cat <<EOF
      hypr-mon-ctl - A utility for managing Hyprland monitors
      
      Usage:
        hypr-mon-ctl [command]
      
      Commands:
        refresh    Refresh monitor configuration
        list       List connected monitors
        mirror     Mirror all displays
        extend     Extend displays (auto-position)
        laptop     Laptop only mode (disable external monitors)
        external   External only mode (disable laptop monitor)
        help       Show this help message
      
      Examples:
        hypr-mon-ctl refresh   # Refresh monitor configuration
        hypr-mon-ctl mirror    # Mirror all displays
        hypr-mon-ctl external  # Use external monitors only
      EOF
      }
      
      # Get the first laptop display (likely eDP-1 or similar)
      get_laptop_display() {
        hyprctl monitors -j | jq -r '.[] | select(.name | test("eDP|LVDS")) | .name' | head -n1
      }
      
      # Get all external displays
      get_external_displays() {
        hyprctl monitors -j | jq -r '.[] | select(.name | test("eDP|LVDS") | not) | .name'
      }
      
      # Function to refresh monitor configuration
      refresh_monitors() {
        # Run monitor handler script 
        ~/.config/hypr/monitor-handler.sh
        
        # Notify the user
        notify-send "Monitor Configuration" "Monitor configuration refreshed" --icon=display
      }
      
      # Function to mirror displays
      mirror_displays() {
        laptop=$(get_laptop_display)
        
        if [ -z "$laptop" ]; then
          notify-send "Monitor Configuration" "No laptop display found" --icon=dialog-error
          exit 1
        fi
        
        # Get preferred resolution of laptop display
        laptop_res=$(hyprctl monitors -j | jq -r --arg name "$laptop" '.[] | select(.name == $name) | "\(.width)x\(.height)"')
        
        # Set all monitors to mirror the laptop display
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
          if [ "$monitor" != "$laptop" ]; then
            hyprctl keyword monitor "$monitor,$laptop_res,0x0,1,mirror,$laptop"
          fi
        done
        
        # Notify the user
        notify-send "Monitor Configuration" "Displays mirrored" --icon=display
      }
      
      # Function to extend displays
      extend_displays() {
        # Run the monitor handler script to auto-position
        ~/.config/hypr/monitor-handler.sh
        
        # Notify the user
        notify-send "Monitor Configuration" "Displays extended" --icon=display
      }
      
      # Function to use laptop display only
      laptop_only() {
        laptop=$(get_laptop_display)
        
        if [ -z "$laptop" ]; then
          notify-send "Monitor Configuration" "No laptop display found" --icon=dialog-error
          exit 1
        fi
        
        # Enable laptop display
        hyprctl keyword monitor "$laptop,preferred,auto,1"
        
        # Disable all other displays
        for monitor in $(get_external_displays); do
          hyprctl keyword monitor "$monitor,disable"
        done
        
        # Notify the user
        notify-send "Monitor Configuration" "Laptop display only" --icon=display
      }
      
      # Function to use external displays only
      external_only() {
        laptop=$(get_laptop_display)
        externals=$(get_external_displays)
        
        if [ -z "$externals" ]; then
          notify-send "Monitor Configuration" "No external displays found" --icon=dialog-error
          exit 1
        fi
        
        # Disable laptop display if it exists
        if [ ! -z "$laptop" ]; then
          hyprctl keyword monitor "$laptop,disable"
        fi
        
        # Run monitor handler to configure external displays
        ~/.config/hypr/monitor-handler.sh
        
        # Notify the user
        notify-send "Monitor Configuration" "External displays only" --icon=display
      }
      
      # Process command
      case "$1" in
        refresh)
          refresh_monitors
          ;;
        list)
          hyprctl monitors
          ;;
        mirror)
          mirror_displays
          ;;
        extend)
          extend_displays
          ;;
        laptop)
          laptop_only
          ;;
        external)
          external_only
          ;;
        help|--help|-h)
          show_usage
          ;;
        *)
          show_usage
          ;;
      esac
    '';
    executable = true;
  };
} 