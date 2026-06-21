{
  modules.programs.helium-browser = { helium-browser, ... }: {
    imports = [ helium-browser.nixosModules.default ];
    programs.helium = {
      enable = true;
      flags = [
        "--disable-gpu"
        "--ozone-platform-hint=auto"
      ];
      policies = {
        "BrowserSignin" = 0;
        "PasswordManagerEnabled" = false;
        "SyncDisabled" = true;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [ "en-US" ];
      };
    };
  };
}
