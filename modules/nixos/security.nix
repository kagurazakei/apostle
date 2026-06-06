{
  modules.nixos.security =
    { ... }:
    {
      programs = {
        sudo = {
          enable = true;
        };
      };
    };
}
