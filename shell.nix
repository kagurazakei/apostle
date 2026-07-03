{
  pkgs,
  inputs,
  config ? null,
  scripts ? [ ],
}:

pkgs.mkShell {
  IMPURE = "true";

  buildInputs =
    with pkgs;
    [
      git
      npins
    ]
    ++ scripts;

  shellHook = ''
    export NIX_PATH="nixpkgs=${inputs.nixpkgs}"

    echo "Welcome to the NixOS configuration dev shell!"
    echo "Run 'tack update' to update pinned inputs"

    ${
      if config != null && config ? nC then
        ''
          echo "Available hosts: ${builtins.toString (builtins.attrNames config.nC)}"
        ''
      else
        ""
    }
  '';
}
