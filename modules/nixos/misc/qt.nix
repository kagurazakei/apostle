{ username, zpkgs, ... }:
{
  modules.nixos.misc =
    {
      pkgs,
      config,
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
      ];
      environment.variables = {
        QML2_IMPORT_PATH = "${pkgs.kdePackages.kirigami}/${pkgs.kdePackages.qtbase.qtQmlPrefix}";
      };
      hjem.users.${username}.packages = with pkgs; [
        quickshell
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
        (catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "red";
        })
      ];
      hj = {
        xdg.config.files = {
          "qt6ct/qt6ct.conf".source = config.impure-dots + "/qt6ct/qt6ct.conf";
          "qt6ct/colors".source = config.impure-dots + "/qt6ct/colors";
          "qt5ct/qt5ct.conf".source = config.impure-dots + "/qt5ct/qt5ct.conf";
          "qt5ct/colors".source = config.impure-dots + "/qt5ct/colors";
          "Kvantum/kvantum.kvconfig".source = config.impure-dots + "/Kvantum/kvantum.kvconfig";
          "Kvantum/rose-pine-iris".source = config.impure-dots + "/Kvantum/rose-pine-iris";
          "Kvantum/rose-pine-love".source = config.impure-dots + "/Kvantum/rose-pine-love";
        };
      };
    };
}
