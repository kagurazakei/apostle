{
  ...
}:
{
  modules.services.scheduler = {
    # imports = [ inputs.chaotic.nixosModules.default ];
    # chaotic.nyx.overlay.enable = true;
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
  };
}
