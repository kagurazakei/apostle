{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  hostname = "hana";
in
{
  modules.hosts.${hostname} = {
    imports = [
      self.modules.programs.dots_fish
      self.modules.programs.dots_hyprland
      self.modules.programs.dots_niri
      self.modules.programs.dots_mango
      self.modules.programs.dots_impure
      self.modules.programs.dots_yazi
      self.modules.nixos.packages
      self.modules.nixos.environments
      self.modules.wm._
      self.modules.wm.hyprland
      self.modules.wm.niri
      self.modules.hjem._
      self.modules.hjem.antonio
      ./+hardware.nix
    ];
    finit.runlevel = 3;
    hardware.firmware = with pkgs; [
      linux-firmware
      sof-firmware
    ];
    programs.gnome-keyring.enable = true;
    programs.xwayland-satellite.enable = true;

    services.earlyoom.enable = lib.mkDefault true;
    services.earlyoom.extraArgs = [
      "-r"
      "3600"
    ];
    services.nix-daemon = {
      enable = true;
      package = pkgs.lixPackageSets.git.lix;
      settings = {
        deprecated-features = [ "broken-string-escape" ];
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operator"
        ];
        auto-optimise-store = true;
        require-sigs = true;
        sandbox = true;
        sandbox-fallback = false;
        download-attempts = 3;
        show-trace = true;
        trusted-users = [
          "root"
          "antonio"
          "@wheel"
        ];
        allowed-users = [
          "@wheel"
          "antonio"
          "root"
        ];
        substituters = [
          "https://kagurazakei.cachix.org"
          "https://nix-community.cachix.org"
          "https://heitor.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://hyprland.cachix.org"
          "https://niri-nix.cachix.org"
        ];
        trusted-public-keys = [
          "kagurazakei.cachix.org-1:L150C/szoC/r6LOupCWQRU5IqdWIBl926O1HpiBVEkw="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "heitor.cachix.org-1:IZ1ydLh73kFtdv+KfcsR4WGPkn+/I926nTGhk9O9AxI="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
        ];
      };
    };
    programs = {
      sudo.enable = true;
      mangowc.enable = true;
      niri.enable = true;
      bash.enable = true;
    };

    services = {
      autologin = {
        enable = true;
        user = "antonio";
        command = "${pkgs.dbus}/bin/dbus-run-session mango";
      };
      polkit.enable = true;
      sysklogd.enable = true;
      dbus.enable = true;
      fcron.enable = true;
      fwupd.enable = true;
      rtkit.enable = true;
      udisks2.enable = true;
      udev.enable = true;
      dhcpcd.enable = true;
      networkmanager.enable = true;
      elogind.enable = true;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet";
          };
        };
      };
    };
    fonts = {
      fontconfig.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };
    xdg.autostart.enable = lib.mkDefault true;
    xdg.icons.enable = lib.mkDefault true;
    xdg.mime.enable = lib.mkDefault true;
    xdg.portal.enable = lib.mkDefault true;
    networking.hostName = "${hostname}"; # Define your hostname.
    time.timeZone = "Asia/Yangon";
  };
}
