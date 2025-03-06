# Brave browser configuration module
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

    # Browser settings
    extraOpts = {
      # Privacy settings
      DefaultBrowserSettingEnabled = true;
      PasswordManagerEnabled = false;
      SpellcheckEnabled = true;
      SpellcheckLanguage = [ "en-US" ];

      # Features to enable/disable
      HardwareAccelerationModeEnabled = true;
      BookmarkBarEnabled = true;

      # Default search engine - Set to Brave Search
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Brave Search";
      DefaultSearchProviderSearchURL =
        "https://search.brave.com/search?q={searchTerms}";
      DefaultSearchProviderSuggestURL =
        "https://search.brave.com/api/suggest?q={searchTerms}";

      # Additional privacy settings
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BuiltInDnsClientEnabled = false;
      MetricsReportingEnabled = false;
      SearchSuggestEnabled = true;

      # Security settings
      SafeBrowsingEnabled = true;
      SafeBrowsingExtendedReportingEnabled = false;

      # Performance settings
      PrefetchingEnabled = true;
    };
  };

  # Create a README file with setup instructions
  home.file.".local/share/brave/README.md" = {
    text = ''
      # Brave Browser Setup

      ## Extensions
      Extensions are managed through Home Manager and should be automatically installed.
      If any extension is missing, you can reinstall by updating your configuration and running:
      ```
      home-manager switch
      ```

      ## Theming with Catppuccin Mocha
      1. The "Catppuccin for Chrome" extension should be automatically installed
      2. Go to the extension options
      3. Import the configuration from `~/.config/brave-catppuccin-config.json`
      4. Or manually select:
         - Color scheme: Mocha
         - Accent color: Mauve
         - Enable accent color: Yes

      ## Performance Flags
      Check `~/.config/brave-flags.conf` for recommended flags.
      Enter `brave://flags` in the URL bar and search for each flag to enable it.

      ## Default Search Engine
      The default search engine is set to Brave Search. If this doesn't apply automatically,
      you can manually set it in Settings > Search engine > Search engine used in the address bar.
    '';
  };
}
