let
  hana = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0lIiKvQGtuJjjub0DnaLVP+qZjmt2ABkfrhXSXXPjk nixos@hana"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0ziYD0mB2r6UgxR0F+sAMnjQXDqNKnlcmSNUdLutBZ sops-nix-user@hana"
  ];
  kagura = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaNh2GVxWz2zLxDa8cMnPtfYQPk1A3xlKKVuKOTNrp2 nixos@kagura"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPWjEDWkrz5r7pzJCjOPmrseoYeoRCZegA3yI3QIrnz sops-nix-user@kagura"
  ];
in
{
  "kagura-user.age".publicKeys = kagura ++ hana;
  "kagura-access-token.age".publicKeys = kagura ++ hana;
  "kagura-ssh.age".publicKeys = kagura ++ hana;
  "anilist.age".publicKeys = kagura ++ hana;
  "recovery.age".publicKeys = kagura ++ hana;
  "hana-user.age".publicKeys = kagura ++ hana;
  "hana-access-token.age".publicKeys = kagura ++ hana;
  "ssh-hana.age".publicKeys = kagura ++ hana;
  "tailscale.age".publicKeys = kagura ++ hana;
  "maxitone.age".publicKeys = kagura ++ hana;
  "cachix-token.age".publicKeys = kagura ++ hana;
}
