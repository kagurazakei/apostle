# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    consoleLogLevel = 0;
    loader.efi = {
      canTouchEfiVariables = true;
    };
    loader.timeout = 0;
    loader.systemd-boot = {
      enable = true;
      consoleMode = "max";
      configurationLimit = 8;
      editor = false;
    };
  };
  networking.hostName = "hana"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Yangon";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.antonio = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      git
      vim
    ];
  };

  #programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    komikku
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  system.copySystemConfiguration = true;
  system.stateVersion = "26.11"; # Did you read the comment?
  nix = {
    settings = {
      warn-dirty = false;
      accept-flake-config = true; # allow using substituters from flake.nix
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      commit-lockfile-summary = "chore(deps): update flake";
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://kagurazakei.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://loneros.cachix.org"
        "https://heitor.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];
      trusted-public-keys = [
        "kagurazakei.cachix.org-1:L150C/szoC/r6LOupCWQRU5IqdWIBl926O1HpiBVEkw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "loneros.cachix.org-1:dVCECfW25sOY3PBHGBUwmQYrhRRK2+p37fVtycnedDU="
        "heitor.cachix.org-1:IZ1ydLh73kFtdv+KfcsR4WGPkn+/I926nTGhk9O9AxI="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };
  };
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
      extraConfig = ''
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH DISPLAY"
        Defaults passprompt = "[sudo 󱅞 ]: "
      '';
    };
  };
}
