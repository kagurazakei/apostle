{
  modules.nixos.networking = {
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
