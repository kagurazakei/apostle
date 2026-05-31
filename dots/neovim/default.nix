{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  fs = lib.fileset;
in
{
  aliases = [ "vim" ];
  initLua = ''
    require("keymaps")
    require("options")
    require("autocmds")
    require("diagnostic")
    require("lsp")
    require("lz.n").load("plugins")
    vim.cmd.colorscheme("base16-tokyodark-terminal")
  '';
  extraBinPath = [
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
  ]
  ++ [
    pkgs.alejandra
    pkgs.nixd
    pkgs.nixfmt
    pkgs.stylua
    pkgs.lua-language-server
    pkgs.shfmt
    pkgs.inotify-tools
    pkgs.kdePackages.qtdeclarative
    pkgs.llvmPackages.clang-tools
    pkgs.neocmakelsp
    pkgs.kdlfmt
    pkgs.tombi
  ];
  enable = true;
  plugins = {
    dev.myConfig = {
      pure = fs.toSource {
        root = ./nvim;
        fileset = fs.fromSource (lib.sources.cleanSource ./nvim);
      };

      impure = "/home/antonio/apostle/dots/neovim/nvim";
    };
    #todo: no idea what this is
    startAttrs = inputs.mnw.lib.npinsToPluginsAttrs pkgs ./start-plugins.json;
    optAttrs = inputs.mnw.lib.npinsToPluginsAttrs pkgs ./opt-plugins.json;
    start =
      builtins.attrValues {
        # inherit (pkgs.vimPlugins) lze lzextras;
        inherit (pkgs.vimPlugins)
          nvim-web-devicons
          plenary-nvim
          snacks-nvim
          statuscol-nvim
          ;
      }
      ++ [
        {
          name = "zen.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "nendix";
            repo = "zen.nvim";
            rev = inputs.zenNvim.revision;
            hash = inputs.zenNvim.hash;
          };
        }
      ];
    opt =
      builtins.attrValues {
        inherit (pkgs.vimPlugins) conform-nvim;
        inherit (pkgs.vimPlugins) lspkind-nvim;
        inherit (pkgs.vimPlugins) nvim-ufo;
        inherit (pkgs.master.vimPlugins) blink-pairs;
        inherit (pkgs.vimPlugins)
          nvim-cokeline
          mini-animate
          fzf-lua
          flash-nvim
          nvim-surround
          bufjump-nvim
          blink-cmp
          base16-nvim
          cord-nvim
          ;
      }
      ++ [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        pkgs.vimPlugins.nvim-treesitter-context

      ];
  };
}
