{
  self,
  inputs,
  utils,
  ...
}:
let
  username = "antonio";
  dots = "${self.paths.dots}";
  iconSource = dots + "/images/profile.png"; # Define once
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
      nixpkgs.overlays = [
        inputs.neovim-nightly.overlays.default
      ];
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
        hashedPasswordFile = config.age.secrets.antonioPass.path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaNh2GVxWz2zLxDa8cMnPtfYQPk1A3xlKKVuKOTNrp2 antonio@hana"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjywfRHVDeBQBFYZym/c3JDVRwni//tSy5FPKmTgLyN antonio@hana"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDT989Rm6vSVS4cSP2NevoXVS7UnFVYHgfsE6dbM2+s6 hana@antonio"
        ];
      };
      programs.fish = {
        enable = true;
        package = lib.mkForce pkgs.master.fish;
      };
      programs.gpu-screen-recorder.enable = true;

      # Hjem dotfiles
      hj.files = {
        ".face.icon".source = iconSource;
      };

      # AccountsService configuration - FIXED: use iconSource directly
      systemd.tmpfiles.rules = [
        # AccountsService user file
        "f+ /var/lib/AccountsService/users/${username} 0600 root root - \
[User]\nIcon=/var/lib/AccountsService/icons/${username}\n"

        # Symlink icon - use iconSource directly, not config.hj
        "L+ /var/lib/AccountsService/icons/${username} - - - - ${iconSource}"
      ];

      hjem.users.${username} = {
        clobberFiles = true;
        user = username;
        directory = config.users.users.${username}.home;
        impure = {
          enable = true;
          dotsDir = dots;
          dotsDirImpure = "/home/antonio/Greenhouse/dots";
          parseAttrs = [
            config.hjem.users.${username}.xdg.config.files
            config.hjem.users.${username}.xdg.state.files
          ];
        };
        packages = import ./_packages.nix { inherit inputs pkgs self; };
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
    "applications.menu" = "/menus/applications.menu";
    "fuzzel/fuzzel.ini" = "/fuzzel/fuzzel.ini";
    "fuzzel/noctalia" = "/fuzzel/noctalia";
    "foot/foot.ini" = "/foot/foot.ini";
    "foot/rose-pine.ini" = { ... }: inputs.rosep-foot + "/rose-pine";
    "wallpapers/nix-logo.png" = { ... }: inputs.walls + "/nix-logo.png";
    ".face.icon" = "/profile.png";
  };
}
