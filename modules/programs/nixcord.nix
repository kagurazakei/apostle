{ self, ... }:
{
  modules.programs.nixcord = { nixcord, ... }: {
    imports = [ nixcord.nixosModule.default ];
    programs.nixcord = {
      enable = true;
      discord = {
        enable = false;
        equicord.enable = false;
      };
      equibop = {
        enable = true;
        useSystemEquibop = true;
        autoScroll = false;
        settings = {
          discordBranch = "canary";
          minimizeToTray = true;
          arRPC = true;
          splashColor = "rgb(205, 214, 244)";
          splashBackground = "rgb(10, 10, 19)";
          hardwareVideoAcceleration = true;
          clickTrayToShowHide = true;
          splashPixelated = true;
          tray = true;
        };
      };
      config = {
        themeLink = [
          "${self.paths.dots}/equibop/themes/system24-oxo-mocha-theme.css"
          "${self.paths.dots}/equibop/themes/midnight.css"
        ];
        enabledThemes = [
          "midnight.css"
          "system24-oxo-mocha-theme.css"
        ];
        plugins = {
          alwaysAnimated.enable = true;
          crashHandler = {
            enable = true;
            attemptToPreventCrashes = true;
          };
          richPresence.enable = true;
          webRichPresence.enable = true;
          toastNotifications = {
            enable = true;
            friendServerNotifications = true;
            maxNotifications = 3.0;
            directMessages = true;
            groupMessages = true;
          };
          equicordToolbox.enable = true;
          ghosted = {
            enable = true;
            showDmIcons = true;
          };
          alwaysTrust = {
            enable = true;
            domain = true;
            file = true;
            noDeleteSafety = true;
          };
          betterSettings = {
            enable = true;
            disableFade = true;
            eagerLoad = true;
            organizeMenu = true;
          };
          ClearURLs.enable = true;
          consoleJanitor = {
            enable = true;
            disableSpotifyLogger = true;
            whitelistedLoggers = "GatewaySocket; Routing/Utils";
          };
          webpackTarball = {
            enable = true;
            patched = true;
          };
          equicordHelper = {
            enable = true;
          };
          disableDeepLinks.enable = true;
          webContextMenus.enable = true;
          SaveFavoriteGIFs.enable = true;
          betterCommands = {
            enable = true;
            autoFillArguments = true;
            allowNewlinesInCommands = true;
          };
          webKeybinds.enable = true;
          webScreenShareFixes.enable = true;
          silentTyping.enable = true;
          messageLogger.enable = true;
        };
      };
    };
  };
}
