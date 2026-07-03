{ self, ... }:
{
  categories = [
    {
      target = "nixos";
      modules = [ "misc_steam" ];
    }
    {
      target = "programs";
      modules = [
        "dots_fish"
        "dots_hyprland"
        "dots_niri"
        "dots_mango"
        "dots_impure"
        "dots_yazi"
        "agenix"
        "dolphin"
        "fish"
        "git"
        "impermanence"
        "librewolf"
        "noctalia"
        "nixcord"
        "spicetify"
        "watt"
        "walker"
        "yazi"
        "zellij"
        "zed"
      ];
    }
    {
      target = "services";
      modules = [
        "_sysc-greet"
        "_greetd"
        "noctalia-greeter"
      ];
    }
    {
      target = "wm";
      modules = [
        "_"
        "hyprland"
        "niri"
        "mango"
      ];
    }
  ];
}
|> (
  ctx:
  self
  |> (x: {
    modules.profiles.graphical = {
      imports =
        ctx.categories
        |> (map (c: map (name: x.modules.${c.target}.${name}) c.modules))
        |> builtins.concatLists;
    };
  })
)
