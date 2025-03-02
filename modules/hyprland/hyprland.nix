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
  };

  # Install necessary Hyprland-related packages
  home.packages = with pkgs; [
    # Core wayland utilities
    wl-clipboard
    wlr-randr
    
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
} 