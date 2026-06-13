{
  modules.services.openssh = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      startWhenNeeded = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "antonio" ];
      };
      knownHosts = {
        hana = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0lIiKvQGtuJjjub0DnaLVP+qZjmt2ABkfrhXSXXPjk nixos@hana";
        };
        kagura = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaNh2GVxWz2zLxDa8cMnPtfYQPk1A3xlKKVuKOTNrp2 nixos@kagura";
        };
      };
    };
  };
}
