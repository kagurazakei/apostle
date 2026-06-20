{
  username,
  self,
  myLibs,
  inputs,
  config,
  ...
}:
let
  dots = "${self.paths.dots}";
in
{
  modules.hjem.hjem-impure = { config, ... }: {
    hjem.users.${username} = {
      impure = {
        enable = true;
        dotsDir = dots;
        dotsDirImpure = "/home/antonio/Apostle/dots";
        parseAttrs = [
          config.hjem.users.${username}.xdg.config.files
          config.hjem.users.${username}.xdg.state.files
        ];
      };
    };
  };
  modules.programs.dots_impure = myLibs.mkDotsModule username {
    "nixpkgs" = "/nixpkgs";
    "fastfetch" = "/fastfetch";
    "swappy/config" = "/swappy/config";
    "lazygit" = "/lazygit";
    "bottom" = "/bottom";
    "btop" = "/btop";
    "kitty/kitty.conf" = d: d.dotsDir + "/kitty/${d.lib.toLower d.config.networking.hostName}.conf";
    "kitty/themes/rose-pine.conf" = { ... }: inputs.rosep-kitty + "/dist/rose-pine.conf";
    "kitty/themes/oxocarbon.conf" = "/kitty/themes/oxocarbon.conf";
    "kitty/scroll_mark.py" = "/kitty/scroll_mark.py";
    "kitty/pass_keys.py" = "/kitty/pass_keys.py";
    "kitty/relative_resize.py" = "/kitty/relative_resize.py";
    "kitty/neighboring_window.py" = "/kitty/neighboring_window.py";
    "kitty/kitty-open-helper.sh" = "/kitty/kitty-open-helper.sh";
    "carapace/carapace.toml" = "/carapace/carapace.toml";
    "equibop/themes" = "/equibop/themes";
    "fuzzel/fuzzel.ini" = "/fuzzel/fuzzel.ini";
    "fuzzel/noctalia" = "/fuzzel/noctalia";
    "foot/foot.ini" = "/foot/foot.ini";
    "foot/rose-pine.ini" = { ... }: inputs.rosep-foot + "/rose-pine";
    ".face.icon" = "/profile.png";
    "zathura/binds" = "/zathura/binds";
    "zathura/options" = "/zathura/options";
    "zathura/theme" = "/zathura/theme";
    "zathura/zathurarc" = "/zathura/zathurarc";
  };
}
