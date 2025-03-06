# NixOS Configuration

A NixOS configuration using flakes, Home Manager, and Hyprland with Catppuccin Mocha theming.

## Fresh Installation Guide

### 1. Initial Setup
First, modify your fresh NixOS installation to include git:

```bash
# Edit the system configuration
sudo nano /etc/nixos/configuration.nix
```

Add git to your system packages:
```nix
environment.systemPackages = with pkgs; [
  git
];
```

Apply the change:
```bash
sudo nixos-rebuild switch
```

### 2. Enable Flakes
Enable flakes by editing `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Apply the change:
```bash
sudo nixos-rebuild switch
```

### 3. Clone and Install
```bash
# Create development directory
mkdir -p ~/Development
cd ~/Development

# Clone the repository
git clone https://github.com/yourusername/NixOS.git
cd NixOS

# Update username in flake.nix to match your system
# Edit flake.nix and change:
# username = "jack"; # to your actual username
```

### 4. Apply Configuration
```bash
# Apply the system configuration
sudo nixos-rebuild switch --flake .#nixos

# Apply the home-manager configuration
home-manager switch --flake .#username@nixos
```

### 5. Post-Installation
After installation:
1. Log out and select Hyprland from your session manager
2. If no display manager is installed, start Hyprland by running:
   ```bash
   Hyprland
   ```

## Configuration Details

A complete NixOS configuration using flakes, Home Manager, and Hyprland with the Catppuccin Mocha theme.

![Catppuccin Mocha](https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/community/mocha.png)

## Features

- **Hyprland Wayland compositor**
  - Configured with Catppuccin Mocha theme
  - Polished animation and window management
  - Proper systemd integration for environment variables
  - Configured with sensible defaults and keybindings

- **Home Manager**
  - Modular organization with separate modules for each component
  - Consistent Catppuccin Mocha theming across all applications

- **Included Applications**
  - **Waybar**: Status bar with Catppuccin Mocha theme
  - **Kitty**: Terminal emulator with Catppuccin Mocha theme
  - **Rofi**: Application launcher with Catppuccin Mocha theme
  - **Dunst**: Notification daemon with Catppuccin Mocha theme
  - **Fish**: Shell with plugins and Catppuccin Mocha theming
  - **Cliphist**: Clipboard manager
  - **Brave**: Browser with script for extension management

## Getting Started

### Prerequisites

- NixOS installed
- Flakes enabled in your Nix configuration

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/nixos-config.git
   cd nixos-config
   ```

2. Edit the configuration to match your system:
   - Update the hostname and username in `flake.nix`
   - Generate and include your hardware configuration
   - Adjust display settings in `modules/hyprland/config.nix`

3. Apply the NixOS configuration:
   ```
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

4. Apply the Home Manager configuration:
   ```
   home-manager switch --flake .#<username>@<hostname>
   ```

### Using Your New Environment

- Log in and select Hyprland from your display manager
- Press `Super + Return` to open a terminal
- Press `Super + Space` to launch applications with Rofi
- Press `Super + C` to access clipboard history
- Press `Super + S` to take a screenshot

## Customization

This configuration is designed to be modular and easily customizable:

- Each component has its own directory in the `modules/` folder
- The Catppuccin Mocha theme can be adjusted or replaced in each module
- Keybindings can be modified in `modules/hyprland/config.nix`
- Additional packages can be added in `modules/packages/default.nix`

## File Structure

```
.
├── flake.nix                      # Main flake configuration
├── home.nix                       # Home Manager entry point
├── hosts
│   └── configuration.nix          # NixOS system configuration
├── modules
│   ├── brave                      # Brave browser configuration
│   ├── cliphist                   # Clipboard manager
│   ├── dunst                      # Notification daemon
│   ├── hyprland                   # Hyprland window manager
│   ├── packages                   # User packages
│   ├── rofi                       # Application launcher
│   ├── shell                      # Fish shell configuration
│   ├── terminal                   # Kitty terminal configuration
│   └── waybar                     # Status bar configuration
├── PROGRESS.md                    # Project progress tracking
└── README.md                      # This file
```

## Credits

- [Catppuccin](https://github.com/catppuccin/catppuccin) for the beautiful color scheme
- [Hyprland](https://hyprland.org/) for the window manager
- [NixOS](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)
- All the maintainers of the various NixOS packages 