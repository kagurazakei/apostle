{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  # imports = [
  #   (modulesPath + "/installer/scan/not-detected.nix")
  # ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/13c28169-df8c-4d54-8d84-44b7eb5794a8";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/872edc56-b023-4b4c-a107-7d8b96e9518f";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ]; # Add these
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/13c28169-df8c-4d54-8d84-44b7eb5794a8";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0494-42A2";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/9eb2259b-6399-4bfd-af3e-c0d9a71dadfe"; }
  ];

}
