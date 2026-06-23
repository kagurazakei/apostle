{
  modules.hosts.hana = { pkgs, ... }: {
    nixos.packages.npins.buildFromSrc = true;
    environment.systemPackages = [
      (pkgs.mpv.override {
        scripts = [
          pkgs.mpvScripts.mpris
        ];
      })

    ];
  };
}
