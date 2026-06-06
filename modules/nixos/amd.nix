{
  modules.nixos.amd =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.radeontop ];
      hardware.graphics = {
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
          libvdpau-va-gl
          libvdpau-va-gl
        ];
      };
      services.xserver.videoDrivers = [ "amdgpu" ];
      finit.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
}
