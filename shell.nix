let
  src = import ./.tack;
  pkgs = import src.nixpkgs { };
in
pkgs.mkShell {
  IMPURE = "true";

  buildInputs = [
    (pkgs.writeShellScriptBin "opt" ''
      npins --lock-file ./dots/neovim/opt-plugins.json "$@"
    '')
    (pkgs.writeShellScriptBin "start" ''
      npins --lock-file ./dots/neovim/start-plugins.json "$@"
    '')
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${src.nixpkgs}"
    echo "Dev shell ready. Available: opt, start, npins"
  '';
}
