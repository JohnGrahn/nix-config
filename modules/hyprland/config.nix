# Hyprland configuration with Catppuccin Mocha theming
{ config, lib, pkgs, inputs, ... }:

let
  # Catppuccin Mocha color palette
  palette = {
    rosewater = "f5e0dc";
    flamingo = "f2cdcd";
    pink = "f5c2e7";
    mauve = "cba6f7";
    red = "f38ba8";
    maroon = "eba0ac";
    peach = "fab387";
    yellow = "f9e2af";
    green = "a6e3a1";
    teal = "94e2d5";
    sky = "89dceb";
    sapphire = "74c7ec";
    blue = "89b4fa";
    lavender = "b4befe";
    text = "cdd6f4";
    subtext1 = "bac2de";
    subtext0 = "a6adc8";
    overlay2 = "9399b2";
    overlay1 = "7f849c";
    overlay0 = "6c7086";
    surface2 = "585b70";
    surface1 = "45475a";
    surface0 = "313244";
    base = "1e1e2e";
    mantle = "181825";
    crust = "11111b";
  };

  # Define terminal and browser variables for easy reference
  terminal = "kitty";
  browser = "brave";
  fileManager = "dolphin";
  menu = "rofi -show drun";
  
  # Define modifier key for keybindings
  mod = "SUPER"; # Windows key / Command key

in {
  # Add the actual configuration to Hyprland
  wayland.windowManager.hyprland.extraConfig = ''
    # Catppuccin Mocha color scheme
    $rosewater = 0xff${palette.rosewater}
    $flamingo = 0xff${palette.flamingo}
    $pink = 0xff${palette.pink}
    $mauve = 0xff${palette.mauve}
    $red = 0xff${palette.red}
    $maroon = 0xff${palette.maroon}
    $peach = 0xff${palette.peach}
    $yellow = 0xff${palette.yellow}
    $green = 0xff${palette.green}
    $teal = 0xff${palette.teal}
    $sky = 0xff${palette.sky}
    $sapphire = 0xff${palette.sapphire}
    $blue = 0xff${palette.blue}
    $lavender = 0xff${palette.lavender}
    $text = 0xff${palette.text}
    $subtext1 = 0xff${palette.subtext1}
    $subtext0 = 0xff${palette.subtext0}
    $overlay2 = 0xff${palette.overlay2}
    $overlay1 = 0xff${palette.overlay1}
    $overlay0 = 0xff${palette.overlay0}
    $surface2 = 0xff${palette.surface2}
    $surface1 = 0xff${palette.surface1}
    $surface0 = 0xff${palette.surface0}
    $base = 0xff${palette.base}
    $mantle = 0xff${palette.mantle}
    $crust = 0xff${palette.crust}

    # See https://wiki.hyprland.org/Configuring/Monitors/
    # Import dynamically generated monitor configuration
    source = ~/.config/hypr/monitors.conf
    
    # Fallback monitor config if the dynamic config fails
    # This will be overridden by monitors.conf if it exists
    monitor=,preferred,auto,1

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options = caps:escape
        kb_rules =

        follow_mouse = 1

        touchpad {
            natural_scroll = true
            tap-to-click = true
            drag_lock = true
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5
        gaps_out = 10
        border_size = 2
        
        # Catppuccin Mocha border colors
        col.active_border = $mauve $blue 45deg
        col.inactive_border = $surface0
        
        layout = dwindle

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false
    }

    decoration {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10
        
        blur {
            enabled = true
            size = 3
            passes = 1
            new_optimizations = true
        }

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = true

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # you probably want this
    }

    master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true
    }

    misc {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = 0 # Set to 0 to disable the anime mascot wallpapers
    }

    # Example windowrule v1
    # windowrule = float, ^(kitty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    windowrulev2 = opacity 0.90 0.90,class:^(kitty)$
    windowrulev2 = float,class:^(pavucontrol)$
    windowrulev2 = float,class:^(file-roller)$
    windowrulev2 = float,class:^(nwg-look)$
    windowrulev2 = float,class:^(blueman-manager)$

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more
    $mainMod = ${mod}

    # Example keybinds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = $mainMod, RETURN, exec, ${terminal}
    bind = $mainMod, Q, killactive, 
    bind = $mainMod SHIFT, Q, exit, 
    bind = $mainMod, E, exec, ${fileManager}
    bind = $mainMod, V, togglefloating, 
    bind = $mainMod, SPACE, exec, ${menu}
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle
    bind = $mainMod, B, exec, ${browser}
    
    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d
    
    # Move windows with mainMod + SHIFT + arrow keys
    bind = $mainMod SHIFT, left, movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up, movewindow, u
    bind = $mainMod SHIFT, down, movewindow, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    
    # Volume control
    bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
    bind = , XF86AudioLowerVolume, exec, pamixer -d 5
    bind = , XF86AudioMute, exec, pamixer -t
    
    # Brightness control
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
    
    # Take a screenshot with the specified area and copy to clipboard and save to ~/Pictures/Screenshots
    bind = $mainMod, S, exec, slurp | grim -g - ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    bind = $mainMod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy
    
    # Toggle Waybar
    bind = $mainMod, W, exec, killall -SIGUSR1 waybar
    
    # Clipboard manager keybindings
    bind = $mainMod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy
    
    # Start notification daemon if not started
    exec-once = dunst

    # Start polkit daemon
    exec-once = /usr/lib/polkit-kde-authentication-agent-1

    # Start Waybar
    exec-once = waybar

    # Start wallpaper daemon
    exec-once = hyprpaper

    # Start clipboard daemon
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store

    # Add monitor handling keybinds
    bind = $mainMod SHIFT, M, exec, ~/.config/hypr/monitor-handler.sh
    
    # Execute the monitor handler script on startup
    exec-once = ~/.config/hypr/monitor-handler.sh
    
    # Handle monitor hotplug events
    exec-once = ~/.config/hypr/monitor-hotplug.sh
  '';
  
  # Install monitor handling scripts
  xdg.configFile."hypr/monitor-handler.sh" = {
    source = ./monitor-handler.sh;
    executable = true;
  };
  
  # Create a script to handle monitor hotplug events
  xdg.configFile."hypr/monitor-hotplug.sh" = {
    text = ''
      #!/usr/bin/env bash
      
      # This script handles monitor hotplug events
      
      # Install inotify-tools if needed
      if ! command -v inotifywait &> /dev/null; then
        echo "inotify-tools not found, installing..."
        nix-env -iA nixos.inotify-tools || exit 1
      fi
      
      # Watch for monitor changes using udevadm
      while true; do
        # Monitor drm (direct rendering manager) events
        udevadm monitor --subsystem-match=drm | grep -i "changed" --line-buffered | while read -r line; do
          echo "Detected monitor change: $line"
          sleep 2  # Give the system time to recognize the monitor
          
          # Run the monitor handler script
          ~/.config/hypr/monitor-handler.sh
        done
        
        # If udevadm exits, wait and restart
        sleep 5
      done
    '';
    executable = true;
  };
} 