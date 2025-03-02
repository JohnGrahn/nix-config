# Brave browser theming configuration
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
  # Configuration for Catppuccin Mocha theme
  xdg.configFile."brave-catppuccin-config.json" = {
    text = ''
      {
        "colorScheme": "mocha",
        "accentColor": "mauve",
        "enableAccentColor": true
      }
    '';
  };
  
  # Additional theming - for New Tab page and startup settings
  programs.chromium.extraOpts = {
    # New Tab settings
    HomepageLocation = "brave://newtab";
    NewTabPageLocation = "brave://newtab";
    
    # Theme settings - as much as we can set via Home Manager
    # Note: This doesn't fully implement Catppuccin Mocha, which is why we also use the extension
    BrowserThemeColor = colors.base;
    
    # Restore session
    RestoreOnStartup = 1; # Restore the previous session
  };
} 