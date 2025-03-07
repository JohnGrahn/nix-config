# Home configuration with Home Manager
{ config, pkgs, inputs, username, hostname, ... }:

{
  # Explicitly declare the config is compatible with Home Manager
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Allow unfree packages (like Brave browser)
  nixpkgs.config.allowUnfree = true;

  # Import all the modules with descriptive filenames
  imports = [
    ./modules/hyprland/hyprland.nix
    ./modules/waybar/waybar.nix
    ./modules/terminal/kitty.nix
    ./modules/packages/packages.nix
    ./modules/shell/fish.nix
    ./modules/brave/brave.nix
    ./modules/rofi/rofi.nix
    ./modules/cliphist/cliphist.nix
    ./modules/dunst/dunst.nix
  ];

  # Ensure Hyprland's systemd integration for proper environment variables
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  # Configure cursor theme for both X11 and Wayland
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # GTK Theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # QT theme configuration to match GTK
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "kvantum";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  # XDG directories configuration
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Additional Home Manager options
  home.sessionVariables = {
    # Prefer wayland with electron apps
    NIXOS_OZONE_WL = "1";
    # Set default terminal
    TERMINAL = "kitty";
    # Set default editor
    EDITOR = "nvim";
    # Ensure qt apps use wayland
    QT_QPA_PLATFORM = "wayland";
    # Force firefox to use wayland
    MOZ_ENABLE_WAYLAND = "1";
  };
}
