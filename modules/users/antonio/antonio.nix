{
  self,
  username,
  ...
}:
{
  modules.hjem.${username} =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.modules.hjem.theming
      ];
      theming = {
        inherit username;
        enable = true;
        qt = {
          colorScheme = self.paths.dots + "/theme/rose-pine.colors";
          iconTheme = "oomox-tokyodark-terminal";
        };
        gtk = {
          name = "oomox-snazzy";
        };
        cursor = {
          name = "Yuurei-Angel";
          size = 32;
        };
      };
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "input"
          "wheel"
          "video"
          "render"
          "libvrtd"
          config.hardware.i2c.group
          config.services.seatd.group
        ];
        shell = pkgs.master.fish;
        hashedPasswordFile = config.age.secrets.antonioPass.path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0lIiKvQGtuJjjub0DnaLVP+qZjmt2ABkfrhXSXXPjk nixos@hana"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0ziYD0mB2r6UgxR0F+sAMnjQXDqNKnlcmSNUdLutBZ sops-nix-user@hana"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaNh2GVxWz2zLxDa8cMnPtfYQPk1A3xlKKVuKOTNrp2 nixos@kagura"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPWjEDWkrz5r7pzJCjOPmrseoYeoRCZegA3yI3QIrnz sops-nix-user@kagura"
        ];
      };
      programs.fish = {
        enable = true;
      };
      programs.gpu-screen-recorder.enable = true;
    };
}
