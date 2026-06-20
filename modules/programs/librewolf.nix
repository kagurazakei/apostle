{ pkgs, ... }:
let
  librewolf = pkgs.librewolf-bin.override {
    extraPolicies = {
      SearchSuggestEnabled = false;
      SearchEngines = {
        PreventInstalls = true;
        Add = [
          { Name = "Google"; }
        ];
        Remove = [
          "DuckDuckGo"
          "Bing"
          "Perplexity"
        ];
        Default = "Google";
      };
    };
  };
in
{
  modules.programs.librewolf = {
    nixpkgs.overlays = [
      (_: prev: {
        librewolf-bin-unwrapped = prev.librewolf-bin-unwrapped.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            echo 'pref("general.config.sandbox_enabled", false);' \
              >> "$out/lib/librewolf-bin-${prev.librewolf-bin-unwrapped.version}/defaults/pref/local-settings.js"
          '';
        });
      })
    ];
    hj.packages = [ librewolf ];
    nixpkgs.config.permittedInsecurePackages = with librewolf; [
      "${pname}-${version}"
      "${pname}-unwrapped-${version}"
    ];

    environment.sessionVariables = {
      MOZ_DISABLE_RDD_SANDBOX = 1;
    };
    xdg.mime.defaultApplications = {
      "application/xhtml+xml" = "librewolf.desktop";
      "text/html" = "librewolf.desktop";
      "text/xml" = "librewolf.desktop";
      "x-scheme-handler/ftp" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
    };
  };
}
