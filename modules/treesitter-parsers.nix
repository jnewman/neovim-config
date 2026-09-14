# Prebuilt tree-sitter parsers + queries, assembled as a Neovim plugin dir.
#
# nixpkgs ships the `main`-branch rewrite of nvim-treesitter, whose classic
# `withPlugins`/`withAllGrammars` helpers are a no-op (they return the plugin
# unchanged). To ship parsers without a runtime `:TSInstall` (and without a C
# compiler / tree-sitter CLI at runtime) we build the install layout ourselves:
#
#   $out/parser/<lang>.so       compiled grammar (from builtGrammars.<lang>/parser)
#   $out/queries/<lang>/*.scm   nvim-treesitter's curated queries (NOT the
#                               grammars' own upstream queries, which differ)
#
# Placed on the runtimepath, Neovim core finds `parser/<lang>.so` and the
# matching `queries/<lang>/` for both highlighting (`vim.treesitter.start`) and
# nvim-treesitter's `indentexpr()`. Keep the nvim-treesitter plugin itself on the
# runtimepath alongside this pack — it supplies the indent Lua and healthcheck.
{
  pkgs,
  # The nvim-treesitter plugin derivation (source of builtGrammars + queries).
  nvim-treesitter,
  # Parser language names to bundle. Must match the config's ensure_installed set
  # in lua/config/treesitter.lua.
  languages,
}:
let
  grammars = nvim-treesitter.builtGrammars;
  copyLang = lang: ''
    cp ${grammars.${lang}}/parser $out/parser/${lang}.so
    cp -r ${nvim-treesitter}/runtime/queries/${lang} $out/queries/${lang}
  '';
in
pkgs.runCommand "nvim-treesitter-parsers"
  {
    passthru = { inherit languages; };
  }
  ''
    mkdir -p $out/parser $out/queries
    ${pkgs.lib.concatMapStrings copyLang languages}
    chmod -R u+w $out
  ''
