{
  description = "NixOS configuration with Hyprland and Home Manager";

  inputs = {
    # Official NixOS package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland Wayland compositor
    # Using the stable version
    hyprland.url = "github:hyprwm/Hyprland";

    # Uncomment to use the development version instead
    # hyprland = {
    #   url = "github:hyprwm/Hyprland/";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Catppuccin theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, catppuccin, ... }@inputs:
    let
      system = "x86_64-linux";
      hostname = "nixos";
      username = "jack"; # Change to your desired username
      
      # Create specialized pkgs with overlays
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [];
        };
      };

      # Library functions from nixpkgs
      lib = nixpkgs.lib;

    in {
      # NixOS system configuration
      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          inherit system;
          modules = [
            # Include the system configuration
            ./hosts/configuration.nix

            # Include Home Manager as a NixOS module
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit username;
                inherit hostname;
              };
              home-manager.users.${username} = {
                imports = [ ./home.nix ];
              };
            }

            # Make Hyprland available to NixOS configuration
            hyprland.nixosModules.default
            {
              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };
            }
          ];
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit hostname;
          };
        };
      };

      # Home Manager standalone configuration 
      # (for use with standalone home-manager, not with NixOS)
      homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit username;
          inherit hostname;
        };
        modules = [
          ./home.nix
          hyprland.homeManagerModules.default
        ];
      };
    };
} 