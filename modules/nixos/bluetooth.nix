{
  modules.nixos.bluetooth = {
    services.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = false;
          KernelExperimental = true;
        };
        Policy = {
          AutoEnable = false;
        };
      };
    };
  };
}
