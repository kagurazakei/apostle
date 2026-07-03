{
  self,
  username,
  ...
}:
let
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0lIiKvQGtuJjjub0DnaLVP+qZjmt2ABkfrhXSXXPjk nixos@hana"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0ziYD0mB2r6UgxR0F+sAMnjQXDqNKnlcmSNUdLutBZ sops-nix-user@hana"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaNh2GVxWz2zLxDa8cMnPtfYQPk1A3xlKKVuKOTNrp2 nixos@kagura"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPWjEDWkrz5r7pzJCjOPmrseoYeoRCZegA3yI3QIrnz sops-nix-user@kagura"
  ];
  groups = [
    "networkmanager"
    "input"
    "wheel"
    "video"
    "render"
    "libvrtd"
  ];

  themingConfig = {
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
in
{
  modules.hjem.${username} =
    { pkgs, config, ... }:
    null
    |> (_: { imports = [ self.modules.hjem.theming ]; })
    |> (attrs: attrs // { theming = themingConfig; })
    |> (
      attrs:
      attrs
      // {
        users.users.${username} = {
          isNormalUser = true;
          extraGroups = groups;
          shell = pkgs.master.fish;
          hashedPasswordFile = config.age.secrets.antonioPass.path;
          openssh.authorizedKeys.keys = sshKeys;
        };
      }
    )
    |> (attrs: attrs // { programs.fish.enable = true; });
}
