{
  self,
  inputs,
  utils,
  zpkgs,
  ...
}:
let
  username = "antonio";
  dots = "${self.paths.dots}";
in
{
  modules.hjem.${username} =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        self.modules.hjem.theming
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "${username}" ])
        (lib.mkAliasOptionModule [ "impure-dots" ] [ "hjem" "users" "${username}" "impure" "dotsDir" ])
      ];
      theming = {
        inherit username;
        enable = true;
        qt = {
          colorScheme = self.paths.dots + "/theme/rose-pine.colors";
          iconTheme = "oomox-tokyodark-terminal";
        };
        gtk = {
          name = "oomox-snazzy";
        };
        cursor = {
          name = "Yuurei-Angel";
          size = 32;
        };
      };
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "input"
          "wheel"
          "video"
          "render"
          "libvrtd"
        ];
        shell = pkgs.master.fish;
      };
      programs.fish = {
        enable = true;
        package = lib.mkForce pkgs.master.fish;
      };
      # Hjem dotfiles
      hjem.users.${username} = {
        clobberFiles = true;
        user = username;
        directory = config.users.users.${username}.home;
        impure = {
          enable = true;
          dotsDir = dots;
          dotsDirImpure = "/home/antonio/Apostle/dots";
          parseAttrs = [
            config.hjem.users.${username}.xdg.config.files
            config.hjem.users.${username}.xdg.state.files
          ];
        };
        packages = import ./_packages.nix {
          inherit
            inputs
            pkgs
            self
            zpkgs
            ;
        };
        files = {
          ".face.icon".source = self.paths.dots + "/profile.png";
        };
        xdg.config.files = {
          "htop".source = utils.mkStoreSymlink self.paths.dots + "/htop";
          "booru".source = utils.mkStoreSymlink self.paths.dots + "/booru";
          "uwsm".source = utils.mkStoreSymlink self.paths.dots + "/uwsm";
          "yazi/theme.toml".text = lib.mkForce ''
            [icon]
            prepend_dirs = [
              { name = "desktop", text = "" },
              { name = "dev", text = "" },
              { name = "documents", text = "" },
              { name = "downloads", text = "" },
              { name = "music", text = "" },
              { name = "games", text = "󰊴" },
              { name = "pictures", text = "" },
              { name = "videos", text = "" },
            ]
            [flavor]
            dark = "oxocarbon"
          '';
        };
      };
    };
  modules.programs.dots_impure = utils.mkDotsModule username {
    "nixpkgs" = "/nixpkgs";
    "fastfetch" = "/fastfetch";
    "swappy/config" = "/swappy/config";
    "lazygit" = "/lazygit";
    "bottom" = "/bottom";
    "btop" = "/btop";
    "kitty/kitty.conf" = d: d.dotsDir + "/kitty/${d.lib.toLower d.config.networking.hostName}.conf";
    "kitty/themes/rose-pine.conf" = { ... }: inputs.rosep-kitty + "/dist/rose-pine.conf";
    "kitty/themes/oxocarbon.conf" = "/kitty/themes/oxocarbon.conf";
    "carapace/carapace.toml" = "/carapace/carapace.toml";
    "equibop/settings.json" = "/equibop/settings.json";
    "equibop/themes" = "/equibop/themes";
    "fuzzel/fuzzel.ini" = "/fuzzel/fuzzel.ini";
    "fuzzel/noctalia" = "/fuzzel/noctalia";
    "foot/foot.ini" = "/foot/foot.ini";
    "foot/rose-pine.ini" = { ... }: inputs.rosep-foot + "/rose-pine";
    # "wallpapers/nix-logo.png" = { ... }: sources.walls + "/nix-logo.png";
    ".face.icon" = "/profile.png";
    "zathura/binds" = "/zathura/binds";
    "zathura/options" = "/zathura/options";
    "zathura/theme" = "/zathura/theme";
    "zathura/zathurarc" = "/zathura/zathurarc";
  };
}
