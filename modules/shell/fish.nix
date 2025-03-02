# Fish shell configuration
{ config, lib, pkgs, ... }:

{
  # Enable Fish shell
  programs.fish = {
    enable = true;
    
    # Fish shell plugins
    plugins = [
      # Syntax highlighting with Catppuccin Mocha theme
      {
        name = "catppuccin-fish";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "8d0b07ad927f976708a432735d23c869559d0205"; # Replace with the latest commit
          sha256 = "sha256-Dc/zdxfzAUM5RDdSu0w6SlEpQ0XvwRl7PTt+aGCPHZI=";
        };
      }
      # Fish plugin for directory history navigation
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      # Adds fzf functionality to fish
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "v9.3";
          sha256 = "sha256-wmECbxGe3fpNhKdXnQOrQxPnZCggbQJrYkdMvdEeNW4=";
        };
      }
      # Fish plugin that adds git abbreviations
      {
        name = "fish-git-abbr";
        src = pkgs.fetchFromGitHub {
          owner = "lewisacidic";
          repo = "fish-git-abbr";
          rev = "2ce4a365138f6f6b1a2c2a7c79dbfcb81a5fbc61";
          sha256 = "sha256-LYPS6SifIp68c9c9o4y9AhGD9jLMlTuCTQZ1inpqF0A=";
        };
      }
    ];
    
    # Shell aliases
    shellAliases = {
      # General aliases
      ll = "ls -la";
      la = "ls -la";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "bat --paging=never";
      
      # Git aliases
      g = "git";
      ga = "git add";
      gc = "git commit";
      gs = "git status";
      gd = "git diff";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      
      # System aliases
      sc = "systemctl";
      jc = "journalctl";
      
      # NixOS specific aliases
      nixs = "sudo nixos-rebuild switch";
      nixb = "sudo nixos-rebuild boot";
      nixu = "sudo nix-channel --update";
      nix-gc = "sudo nix-collect-garbage -d";
      nix-clean = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch";
      hmswitch = "home-manager switch";
      hmbuild = "home-manager build";
      hmgc = "home-manager expire-generations \"-7 days\"";
      
      # Editor aliases
      vim = "nvim";
      vi = "nvim";
      
      # Misc aliases
      weather = "curl wttr.in";
      myip = "curl ifconfig.me";
      fetch = "fastfetch";  # Alias for fastfetch
      
      # Confirm before overwriting
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
    };
    
    # Fish shell functions
    functions = {
      # Fish greeting
      fish_greeting = ''
        # Run fastfetch for a nice system information display
        if type -q fastfetch
          fastfetch --config $HOME/.config/fastfetch/config.jsonc
        else
          echo (set_color cyan)"Welcome to NixOS!"(set_color normal)
          echo "Today is "(set_color yellow)(date +"%A, %B %d, %Y")(set_color normal)
          echo "The time is "(set_color yellow)(date +"%I:%M %p")(set_color normal)
        end
        echo ""
      '';
      
      # Create and enter directory
      mkcd = ''
        mkdir -p $argv && cd $argv
      '';
      
      # Extract archives
      extract = ''
        set -l file $argv[1]
        if test -f $file
          switch $file
            case "*.tar.bz2"
              tar xjf $file
            case "*.tar.gz"
              tar xzf $file
            case "*.bz2"
              bunzip2 $file
            case "*.rar"
              unrar x $file
            case "*.gz"
              gunzip $file
            case "*.tar"
              tar xf $file
            case "*.tbz2"
              tar xjf $file
            case "*.tgz"
              tar xzf $file
            case "*.zip"
              unzip $file
            case "*.Z"
              uncompress $file
            case "*.7z"
              7z x $file
            case "*"
              echo "Don't know how to extract '$file'"
              return 1
          end
        else
          echo "'$file' is not a valid file"
          return 1
        end
      '';
    };
    
    # Custom fish shell initialization
    interactiveShellInit = ''
      # Set Catppuccin Mocha theme
      fish_config theme choose "Catppuccin Mocha"
      
      # Enable vi mode
      fish_vi_key_bindings
      
      # Use terminal colors
      set -g fish_term24bit 1
      
      # Disable fish default greeting
      set -g fish_greeting
      
      # Enable starship prompt if installed
      if type -q starship
        starship init fish | source
      end
      
      # Load direnv if installed
      if type -q direnv
        direnv hook fish | source
      end
      
      # Load zoxide if installed
      if type -q zoxide
        zoxide init fish | source
      end
    '';
  };
  
  # Configure Starship prompt with Catppuccin Mocha theming
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    
    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vicmd_symbol = "[V](bold green)";
      };
      
      # Catppuccin Mocha colors
      palette = "catppuccin_mocha";
      
      palettes.catppuccin_mocha = {
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
    };
  };
  
  # Configuration for fzf (fuzzy finder)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    
    # Use Catppuccin Mocha colors for fzf
    colors = {
      "bg+" = "#313244";
      "bg" = "#1e1e2e";
      "spinner" = "#f5c2e7";
      "hl" = "#f38ba8";
      "fg" = "#cdd6f4";
      "header" = "#f38ba8";
      "info" = "#cba6f7";
      "pointer" = "#f5c2e7";
      "marker" = "#f5c2e7";
      "fg+" = "#cdd6f4";
      "prompt" = "#cba6f7";
      "hl+" = "#f38ba8";
    };
    
    # FZF default options
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
      "--margin=1"
      "--padding=1"
    ];
  };
  
  # Add fastfetch configuration with Catppuccin Mocha colors
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch-config.jsonc;
} 