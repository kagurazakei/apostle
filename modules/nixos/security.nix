{
  modules.nixos.security =
    { pkgs, run0-sudo-shim, ... }:
    let
      run0-no-bg = pkgs.writeShellScriptBin "run0" /* sh */ ''
        exec ${pkgs.systemd}/bin/run0 --background= "$@"
      '';

      run0-sudo-shim' =
        run0-sudo-shim.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
          (old: {
            env = (old.env or { }) // {
              RUN0 = "${run0-no-bg}/bin/run0";
            };
          });
    in
    {
      environment.systemPackages = [
        run0-sudo-shim'
      ];
      environment.shellAliases.sudo = "${run0-sudo-shim'}/bin/sudo";
      environment.shellAliases.sudoedit = "${run0-sudo-shim'}/bin/sudo -e";
      security = {
        polkit.enable = true;
        sudo = {
          wheelNeedsPassword = false;
          extraConfig = ''
            Defaults pwfeedback
            Defaults env_keep += "EDITOR PATH DISPLAY"
          '';
        };
        pki.certificateFiles = [
          "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        ];
        polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (!subject.isInGroup("wheel")) return polkit.Result.NOT_HANDLED;
            if (action.id == "org.freedesktop.policykit.exec"
                || action.id.indexOf("org.freedesktop.systemd1.") == 0) {
              return polkit.Result.AUTH_SELF_KEEP;
            }
            return polkit.Result.NOT_HANDLED;
          });
        '';
      };
    };
}
