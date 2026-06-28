{
  modules.programs.zed =
    { pkgs, ... }:
    let
      zed-rpc = pkgs.buildEnv {
        name = "zed-editor";
        paths = [
          pkgs.zed-editor
          pkgs.zed-discord-presence
          pkgs.lua-language-server
          pkgs.fish-lsp
          pkgs.tombi
          pkgs.nixd
          pkgs.nil
        ];
      };
    in
    {
      hj = {
        packages = [ zed-rpc ];
      };
    };
}
