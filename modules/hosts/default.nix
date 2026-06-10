{
  self,
  inputs,
  lib,
  ...
}:
let
  nixosSystem = inputs.finix.lib.finixSystem;
  mkHost =
    hostname:
    let
      system = self.modules.hosts.${hostname}.system or "x86_64-linux";
      channelOverlay = final: prev: {
        inherit stable master;
        inherit (prev.stdenv.hostPlatform) system;
      };
      stable = import inputs.stable {
        inherit system;
        config.allowUnfree = true;
      };

      master = import inputs.master {
        inherit system;
        config.allowUnfree = true;
      };
      basepkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.niri-nix.overlays.niri-nix
          inputs.nix-cachyos-kernel.overlays.pinned
          inputs.neovim-nightly.overlays.default
          channelOverlay
        ];
      };
      pkgs = basepkgs // {
        stable = stable;
        master = master;
      };
      finix-modules = with inputs.finix.nixosModules; [
        nix-daemon
        openssh
        sysklogd
        limine
        sudo
        polkit
        getty
        bash
        dhcpcd
        iwd
        niri
        mango
        hyprland
      ];
    in
    nixosSystem {
      inherit lib;
      modules = with inputs.finix.nixosModules; [
        {
          nixpkgs.pkgs = inputs.nixpkgs.lib.mkDefault pkgs;
        }
        {
          disabledModules = [ "modules/nixos/appmenu-gtk3-module.nix" ];
        }
        self.modules.hosts.${hostname}
        inputs.community-modules.nixosModules.pipewire
        anacron
        dhcpcd
        iwd
        atd
        bash
        bluetooth
        brightnessctl
        chronyd
        ddccontrol
        dma
        networkmanager
        dropbear
        earlyoom
        fcron
        fish
        flatpak
        fprintd
        fstrim
        fwupd
        getty
        gnome-keyring
        greetd
        gvfs
        hyprland
        hyprlock
        illum
        incus
        labwc
        xserver
        lemurs
        limine
        mangowc
        mariadb
        nftables
        niri
        nix-daemon
        nzbget
        openssh
        pmount
        polkit
        power-profiles-daemon
        regreet
        rtkit
        seahorse
        sudo
        sway
        sysklogd
        system76-scheduler
        thermald
        tzupdate
        udisks2
        upower
        uptime-kuma
        virtualbox
        xwayland-satellite
        zerotierone
        zfs
        zzz
      ];

      specialArgs = {
        inherit self inputs system;
        modulesPath = toString inputs.nixpkgs + "/nixos/modules";
      }
      // inputs;
    };

  hosts = builtins.attrNames self.modules.hosts;
in
{
  nC = lib.genAttrs hosts mkHost;
}
