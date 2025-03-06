# Brave browser extensions configuration
{ config, lib, pkgs, ... }:

{
  # Configure Brave through Home Manager's Chromium module - extensions section
  programs.chromium = {
    enable = true;
    # Use Brave as the package instead of Chromium
    package = pkgs.brave;

    # Extensions to install
    extensions = [
      # uBlock Origin
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"

      # Dark Reader
      "eimadpbcbfnmbkopoojfekhnkhdbieeh"

      # Bitwarden
      "nngceckbapebfimnlniiiahkandclblb"

      # Catppuccin for all web apps
      "bannabikokecfpeikmgecflljpaaijdb"

      # Privacy Badger
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"

      # HTTPS Everywhere
      "gcbommkclmclpchllfjekcdonpmejbdp"

      # Vimium
      "dbepggeogbaibhgnhhndojpepiihcmeb"

      # JSON Formatter
      "bcjindcccaagfpapjjmafapmmgkkhgoa"

    ];
  };
}
