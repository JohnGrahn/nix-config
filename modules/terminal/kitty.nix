# Kitty terminal configuration with Catppuccin Mocha theming
{ config, lib, pkgs, ... }:

{
  # Enable Kitty terminal
  programs.kitty = {
    enable = true;

    # Catppuccin Mocha theme settings for Kitty terminal
    theme = "Catppuccin-Mocha";

    # Keyboard shortcuts
    keybindings = {
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
    };

    # Basic settings
    settings = {
      # Font configuration
      font_family = "JetBrainsMono Nerd Font";
      bold_font = "JetBrainsMono Nerd Font Bold";
      italic_font = "JetBrainsMono Nerd Font Italic";
      bold_italic_font = "JetBrainsMono Nerd Font Bold Italic";
      font_size = "12.0";

      # Window settings
      window_padding_width = "8";
      hide_window_decorations = "yes";
      confirm_os_window_close = "0";
      background_opacity = "0.95";

      # Cursor settings
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";

      # Tab settings
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template =
        "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Keep working directory when creating new windows
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";

      # Enable terminal bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";

      # URL handling
      url_style = "curly";
      open_url_with = "default";
      url_prefixes = "http https file ftp gemini irc gopher mailto news git";
      detect_urls = "yes";

      # Performance settings
      repaint_delay = "10";
      sync_to_monitor = "yes";

      # Terminal bell
      window_alert_on_bell = "yes";
      bell_on_tab = "yes";

      # Shell integration
      shell_integration = "enabled";
    };

    # Additional Catppuccin Mocha theme colors that may not be in the built-in theme
    extraConfig = ''
      # Catppuccin Mocha additional colors
      # Colors extracted directly from https://github.com/catppuccin/kitty/blob/main/themes/mocha.conf

      # The basic colors
      foreground              #CDD6F4
      background              #1E1E2E
      selection_foreground    #1E1E2E
      selection_background    #F5E0DC

      # Cursor colors
      cursor                  #F5E0DC
      cursor_text_color       #1E1E2E

      # URL underline color when hovering with mouse
      url_color               #F5E0DC

      # Kitty window border colors
      active_border_color     #B4BEFE
      inactive_border_color   #6C7086
      bell_border_color       #F9E2AF

      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system

      # Tab bar colors
      active_tab_foreground   #11111B
      active_tab_background   #CBA6F7
      inactive_tab_foreground #CDD6F4
      inactive_tab_background #181825
      tab_bar_background      #11111B

      # Colors for marks (marked text in the terminal)
      mark1_foreground #1E1E2E
      mark1_background #B4BEFE
      mark2_foreground #1E1E2E
      mark2_background #CBA6F7
      mark3_foreground #1E1E2E
      mark3_background #74C7EC

      # The 16 terminal colors
      # black
      color0 #45475A
      color8 #585B70

      # red
      color1 #F38BA8
      color9 #F38BA8

      # green
      color2  #A6E3A1
      color10 #A6E3A1

      # yellow
      color3  #F9E2AF
      color11 #F9E2AF

      # blue
      color4  #89B4FA
      color12 #89B4FA

      # magenta
      color5  #F5C2E7
      color13 #F5C2E7

      # cyan
      color6  #94E2D5
      color14 #94E2D5

      # white
      color7  #BAC2DE
      color15 #A6ADC8
    '';
  };
}
