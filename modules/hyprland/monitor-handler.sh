#!/usr/bin/env bash

# Path where the monitor config will be saved
CONFIG_FILE="$HOME/.config/hypr/monitors.conf"

# Function to generate monitor configs
generate_monitor_config() {
  # Clean the previous config
  echo "# Auto-generated monitor configuration" > "$CONFIG_FILE"
  
  # Get connected monitors using hyprctl
  MONITORS=$(hyprctl monitors -j | jq -r '.[] | "\(.name)|\(.width)x\(.height)@\(.refreshRate)|\(.x)|\(.y)"')
  
  # If no monitors detected via hyprctl (might be first boot), try wlr-randr
  if [ -z "$MONITORS" ]; then
    echo "No monitors detected with hyprctl, trying wlr-randr..."
    MONITORS=$(wlr-randr --json | jq -r '.[] | select(.active == true) | "\(.name)|\(.width)x\(.height)@\(.refresh / 1000)|\(.x)|\(.y)"')
  fi

  # If still no monitors, default to basic config
  if [ -z "$MONITORS" ]; then
    echo "# No monitors detected, using default configuration" >> "$CONFIG_FILE"
    echo "monitor=,preferred,auto,1" >> "$CONFIG_FILE"
    return
  fi

  # Variables to track if we have a primary monitor
  PRIMARY_SET=false
  FIRST_MONITOR=""
  
  # Process each monitor
  while IFS= read -r monitor_info; do
    NAME=$(echo "$monitor_info" | cut -d'|' -f1)
    RESOLUTION=$(echo "$monitor_info" | cut -d'|' -f2)
    POSITION_X=$(echo "$monitor_info" | cut -d'|' -f3)
    POSITION_Y=$(echo "$monitor_info" | cut -d'|' -f4)
    
    # Save first monitor name
    if [ -z "$FIRST_MONITOR" ]; then
      FIRST_MONITOR="$NAME"
    fi
    
    # Check if this monitor should be primary based on position (0,0) or naming conventions
    if [ "$POSITION_X" == "0" ] && [ "$POSITION_Y" == "0" ] || [[ "$NAME" == *"eDP"* ]] || [[ "$NAME" == *"LVDS"* ]]; then
      # This is likely a primary monitor (laptop display or at 0,0 position)
      echo "monitor=$NAME,$RESOLUTION,$POSITION_X,$POSITION_Y,1" >> "$CONFIG_FILE"
      PRIMARY_SET=true
      
      # Set workspace assignments for primary monitor (workspaces 1-5)
      for i in {1..5}; do
        echo "workspace=$i,monitor:$NAME" >> "$CONFIG_FILE"
      done
    else
      # Secondary monitor
      echo "monitor=$NAME,$RESOLUTION,$POSITION_X,$POSITION_Y,1" >> "$CONFIG_FILE"
      
      # If this is the first secondary monitor, assign workspaces 6-10 to it
      if [ "$PRIMARY_SET" == "true" ]; then
        for i in {6..10}; do
          echo "workspace=$i,monitor:$NAME" >> "$CONFIG_FILE"
        done
        PRIMARY_SET=false  # Only assign workspaces to one secondary monitor
      fi
    fi
  done <<< "$MONITORS"
  
  # If no primary was set but we have monitors, use the first one as primary
  if [ "$PRIMARY_SET" == "false" ] && [ ! -z "$FIRST_MONITOR" ]; then
    # Set workspace assignments for this monitor (all workspaces)
    for i in {1..10}; do
      echo "workspace=$i,monitor:$FIRST_MONITOR" >> "$CONFIG_FILE"
    done
  fi
  
  echo "# Monitor configuration generated at $(date)" >> "$CONFIG_FILE"
}

# Ensure hypr config directory exists
mkdir -p "$HOME/.config/hypr"

# Generate initial configuration
generate_monitor_config

# Watch for monitor changes and update config
if command -v inotifywait >/dev/null 2>&1; then
  while true; do
    # Wait for changes on the Hyprland socket
    if [ -e "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
      inotifywait -e modify "$HYPRLAND_INSTANCE_SIGNATURE" >/dev/null 2>&1
      sleep 1  # Small delay to let things settle
      generate_monitor_config
      
      # Reload Hyprland configuration
      hyprctl reload
    else
      # If not running under Hyprland, exit
      break
    fi
  done
fi 