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
        settings = {
          backdrop = "#1e1e2e";
          wallpapers = [ "${inputs.walls}/nix-logo.png" ];
          wallpaper_style = "centered";
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
