{
  modules.nixos.kernel =
    {
      pkgs,
      config,
      ...
    }:
    {
      boot = {
        kernelPackages =
          if config.networking.hostName == "hana" then
            pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4
          else
            pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;
        kernel.enable = true;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "loglevel=0"
          "nowatchdog"
          "nohibernate"
          "nvidia-drm.modeset=1"
          "nvidia-drm.fbdev=1"
        ];
        kernelModules = [
          "drm"
          "i2c-dev"
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
      };
    };
}
