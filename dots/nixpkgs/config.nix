{
  allowUnfree = true;
  permittedInsecurePackages = [
    "librewolf-151.0.2-1"
    "librewolf-unwrapped-151.0.2-1"
    "librewolf-bin-151.0.1-2"
    "librewolf-bin-unwrapped-151.0.1-2"
  ];
  problems.handlers = {
    zfs.broken = "warn"; # or "ignore"
  };
}
