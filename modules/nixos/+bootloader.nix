{ inputs, ... }:
{
  modules.nixos.bootloader =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.callPackage (inputs.shizuruPkgs + "/pkgs/default.nix") { }).kureiji-ollie-cursors
      ];
      boot = {
        consoleLogLevel = 0;
        loader = {
          efi.canTouchEfiVariables = true;
          limine = {
            enable = true;
            maxGenerations = 8;
            style = {
              wallpaperStyle = "centered";
              wallpapers = [
                "${inputs.walls}/nix-logo.png"
              ];
              interface = {
                resolution = "max";
                helpHidden = true;
                branding = "Limine Bootloader";
              };
              graphicalTerminal = {
                font.scale = "2x2";
                margin = -1;
                marginGradient = -1;
                background = "33080808";
                foreground = "B9C1D6";
              };
            };
          };
        };
        tmp = {
          useTmpfs = false;
          tmpfsSize = "30%";
        };
        binfmt.registrations.appimage = {
          wrapInterpreterInShell = true;
          interpreter = "${pkgs.appimage-run}/bin/appimage-run";
          recognitionType = "magic";
          offset = 0;
          mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
          magicOrExtension = ''\x7fELF....AI\x02'';
        };
        plymouth = {
          enable = true;
          themePackages = [
            (pkgs.callPackage "${inputs.shizuruPkgs}/pkgs/default.nix" { }).cat-plymouth
          ];
          theme = "catppuccin-mocha-mod";
        };
      };
    };
}
