{ zpkgs, ... }:
{
  modules.nixos.misc =
    {
      pkgs,
      self,
      ...
    }:
    {
      qt.enable = true;

      environment.systemPackages = with pkgs; [
        wlsunset
        libqalculate
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        kdePackages.qqc2-desktop-style
        adwaita-qt6
        qt6.qtwayland
        qt6.qtsvg
        qt6Packages.qtstyleplugin-kvantum
        kdePackages.kdialog
        kdePackages.qtpositioning
        kdePackages.qtshadertools
        kdePackages.syntax-highlighting
        kdePackages.qtbase
        kdePackages.qtdeclarative
        kdePackages.qtmultimedia
        kdePackages.qt5compat
        kdePackages.sonnet
        kdePackages.kirigami
        kdePackages.kirigami-addons
        kdePackages.breeze
        qt5.qtgraphicaleffects
        qt5.qtbase
        qt5.qtdeclarative
        qt5.qtgraphicaleffects
        qt5.qtdeclarative
        zpkgs.qt6ct
        (catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "red";
        })
      ];
      environment.variables = {
        QML2_IMPORT_PATH = "${pkgs.kdePackages.kirigami}/${pkgs.kdePackages.qtbase.qtQmlPrefix}";
      };
    };
}
