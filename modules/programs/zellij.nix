{
  modules.programs.zellij =
    { pkgs, self, ... }:
    let
      sesh = pkgs.writeScriptBin "sesh" ''
        #! /usr/bin/env bash

        # Get directory (from args or zoxide interactive)
        DIR="$1"
        if [[ -z "$DIR" ]]; then
          DIR=$(zoxide query --interactive) || exit 0
        fi

        # Session name from directory name
        NAME=$(basename "$DIR")

        # Check if session exists
        if zellij list-sessions -n 2>/dev/null | grep -q "^$NAME$"; then
          # Attach to existing session
          zellij attach "$NAME"
        else
          # Choose layout
          LAYOUT=$(gum choose "default" "dev" "dev-simple" --header "Layout for $NAME:")

          # Create and attach new session
          cd "$DIR"
          zellij --layout "$LAYOUT" attach -c "$NAME"
        fi
      '';
    in
    {
      hj = {
        packages = [
          pkgs.zellij
          pkgs.tmate
          pkgs.gum
          sesh
        ];
        xdg.config.files = {
          "zellij/config.kdl".source = self.paths.dots + "/zellij/config.kdl";
          "zellij/themes/catppuccin.kdl".source = self.paths.dots + "/zellij/themes/catppuccin.kdl";
          "zellij/themes/tokyonight_night.kdl".source =
            self.paths.dots + "/zellij/themes/tokyonight_night.kdl";
          "zellij/layouts/default.kdl".source = self.paths.dots + "/zellij/layouts/default.kdl";
          "zellij/layouts/nodejs.kdl".source = self.paths.dots + "/zellij/layouts/nodejs.kdl";
        };
      };
    };
}
