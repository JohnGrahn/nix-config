# User packages module
{ config, lib, pkgs, ... }:

{
  # User packages to install
  home.packages = with pkgs; [
    # Text editors
    emacs # For installing doom-emacs on top later
    neovim

    # Terminal and tools
    kitty
    fish
    starship # Shell prompt
    fastfetch # Fast system info

    # Development tools
    git
    gh # GitHub CLI
    gnumake
    gcc
    rustup # Rust toolchain installer
    nodejs
    go
    python3
    nixfmt # Nix formatter
    nil # Nix language server

    # System tools
    htop
    btop # Advanced system monitor
    fd # Alternative to find
    ripgrep # Better grep
    fzf # Fuzzy finder
    jq # JSON processor
    bat # Better cat
    eza # Better ls (formerly exa)
    zoxide # Directory jumper (z command)

    # Clipboard manager
    cliphist

    # Application launcher
    rofi-wayland

    # File manager
    (pkgs.writeShellScriptBin "fm" ''
      # Use available terminal-based file manager
      if command -v ranger &>/dev/null; then
        ranger "$@"
      elif command -v nnn &>/dev/null; then
        nnn "$@"
      else
        echo "No terminal file manager found!"
        exit 1
      fi
    '')
    ranger # Terminal file manager

    # Image related
    imv # Image viewer
    gimp # Image editor

    # Audio/Video
    mpv # Media player
    pavucontrol # PulseAudio volume control

    # Documents
    libreoffice-qt # Office suite
    zathura # PDF viewer

    # Compression
    unzip
    zip
    p7zip

    # Network tools
    wget
    curl

    # Fonts
    # nerdfonts # Includes JetBrains Mono, Fira Code, etc.
    # Note: nerdfonts has been separated into individual packages
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    # Theme
    catppuccin-gtk
    papirus-icon-theme

    # Wayland specific
    grim # Screenshot utility
    slurp # Region selector
    wl-clipboard # Clipboard utility
    wf-recorder # Screen recording

    # Other useful tools
    xdg-utils # For xdg-open, etc.
    brightnessctl # Brightness control
  ];
}
