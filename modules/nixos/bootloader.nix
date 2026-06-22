{ inputs, ... }:
{
  modules.nixos.bootloader =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        (pkgs.callPackage (inputs.shizuruPkgs + "/pkgs/default.nix") { }).kureiji-ollie-cursors
      ];
      programs.limine = {
        enable = lib.mkForce true;
        settings.editor_enabled = true; # Disable on systems that need security
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
      programs.plymouth = {
        enable = true;
        # theme = (pkgs.callPackage "${inputs.shizuruPkgs}/pkgs/default.nix" { }).cat-plymouth;
      };

      boot = {
        loader.efi = {
          canTouchEfiVariables = true;
        };
      };
    };
}
