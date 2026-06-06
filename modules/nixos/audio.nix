{
  modules.nixos.audio =
    { inputs, ... }:
    {
      programs = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
          };
        };
      };
    };
}
