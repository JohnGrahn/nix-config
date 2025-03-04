# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page.

{ config, pkgs, inputs, username, hostname, ... }:

{
  imports = [
    # Include the results of the hardware scan if you have one
    # ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your hostname
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;
  # Disable potentially conflicting services
  networking.useDHCP = false; # Let NetworkManager handle DHCP
  # Disable systemd-networkd if it might be enabled by default
  systemd.services.systemd-networkd.enable = false;

  # Set your time zone
  time.timeZone = "America/New_York"; # Change to your timezone

  # Configure console keymap if needed
  # console.keyMap = "us";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure X11 and fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Enable the X11 windowing system for compatibility
  services.xserver.enable = true;

  # Enable SDDM display manager (login screen)
  services.displayManager.sddm = {
    enable = true;
    # Optional: Configure theme
    # theme = "breeze";
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable sound with PipeWire
  sound.enable = true;
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;

  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # PulseAudio compatibility
    jack.enable = true; # JACK compatibility
    wireplumber.enable = true; # Session manager
  };

  # Required for certain apps that check for these groups
  security.rtkit.enable = true; # Realtime scheduling for audio

  # Enable touchpad support (for laptops)
  services.xserver.libinput.enable = true;

  # XDG Portal (for screen sharing, file dialogs, etc.)
  xdg.portal = {
    enable = true;
    extraPortals =
      [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = { default = "*"; };
      # Ensure PipeWire is used for screencast 
      screencast = {
        enable = true;
        implementation = "pw"; # pw = PipeWire
      };
    };
  };

  # Enable proper cursor theme support
  environment.variables = { XCURSOR_SIZE = "24"; };

  # Set electron apps to use wayland
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  # Define a user account
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    # Set an initial password (change this after first login)
    initialPassword = "changeMe";
    # The default shell
    shell = pkgs.fish;
  };

  # Enable Fish shell
  programs.fish.enable = true;

  # Install system-wide packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    wget
    curl
    unzip
    tree
    htop
    git
    vim
    neovim

    # Wayland utilities
    wl-clipboard
    grim # Screenshot utility
    slurp # Screen area selection

    # PipeWire utilities
    pavucontrol # PulseAudio volume control (works with PipeWire)
    easyeffects # Audio effects for PipeWire
    helvum # PipeWire patchbay
    qpwgraph # Another GUI for PipeWire connections
  ];

  # Enable OpenSSH
  services.openssh.enable = true;

  # Hyprland config - added in flake.nix via the hyprland module

  # System version, do not change unless you know what you are doing
  system.stateVersion = "23.11"; # Did you read the comment?

  # PipeWire daemon optimization for low latency
  environment.etc = {
    "pipewire/pipewire.conf.d/90-low-latency.conf".text = ''
      context.properties = {
        default.clock.rate = 48000
        default.clock.quantum = 32
        default.clock.min-quantum = 32
        default.clock.max-quantum = 32
      }
    '';
  };

  # Bluetooth support for audio devices
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };

  # Enable blueman for Bluetooth management
  services.blueman.enable = true;
}
