{
  modules.hosts.kagura = {
    misc.steam.enable = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];
  };
}
