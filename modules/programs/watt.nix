{
  inputs,
  ...
}:
{
  modules.programs.watt = {
    imports = [
      inputs.watt.nixosModules.default
    ];
    services.watt = {
      enable = true;
    };
  };
}
