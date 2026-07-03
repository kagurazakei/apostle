{ self, ... }:
{
  gpuModules = [
    "nvidia"
    "amd"
  ];
}
|> (
  ctx:
  self
  |> (x: {
    modules.profiles.desktop = {
      imports = ctx.gpuModules |> (map (m: x.modules.nixos.${m}));
    };
  })
)
