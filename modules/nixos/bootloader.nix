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
      };
      programs.plymouth = {
        enable = false;
        theme = (pkgs.callPackage "${inputs.shizuruPkgs}/pkgs/default.nix" { }).cat-plymouth;
      };

      boot = {
        loader.efi = {
          canTouchEfiVariables = true;
        };
      };
    };
}
