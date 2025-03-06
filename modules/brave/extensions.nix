# Brave browser extensions configuration
{ config, lib, pkgs, ... }:

{
  # Configure Brave through Chromium module
  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    # Extensions to install
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "bannabikokecfpeikmgecflljpaaijdb"; } # Catppuccin for all web apps
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
      { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } # HTTPS Everywhere
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "bcjindcccaagfpapjjmafapmmgkkhgoa"; } # JSON Formatter
    ];

    # Command line arguments
    commandLineArgs = [ "--disable-features=WebRtcAllowInputVolumeAdjustment" ];
  };
}
