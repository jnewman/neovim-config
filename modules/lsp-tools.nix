# Language servers and formatters used by the Neovim config.
#
# On a nix host the editor runs these binaries directly off PATH (no Docker);
# install this package into your profile / home-manager, or enter `nix develop`.
# The binary names here must match what lua/config/lsp.lua and lua/config/format.lua
# invoke in native (non-Docker) mode.
{ pkgs }:
pkgs.buildEnv {
  name = "nvim-lsp-tools";
  paths = with pkgs; [
    # ── Language servers ──────────────────────────────────────────────────────
    lua-language-server
    yaml-language-server
    vscode-langservers-extracted # vscode-{json,html,css,eslint}-language-server
    pyright
    rust-analyzer
    typescript-language-server
    gopls
    metals
    haskell-language-server # haskell-language-server-wrapper
    ruby-lsp
    clang-tools # clangd + clang-format
    bash-language-server
    lemminx
    terraform-ls
    marksman

    # ── Formatters ────────────────────────────────────────────────────────────
    stylua
    yq-go # yq
    ruff
    rustfmt
    go # gofmt
    shfmt
    libxml2.bin # xmllint
    terraform
    prettier
    scalafmt
    ormolu
    rubocop

    # ── Editor preview tools ──────────────────────────────────────────────────
    # Used by lua/config/mermaid.lua: mmdc renders mermaid to a PNG, image.nvim
    # draws it inline via ImageMagick's CLI processor.
    mermaid-cli # mmdc
    imagemagick # magick / convert

    # ── Treesitter parser build tools ─────────────────────────────────────────
    # nvim-treesitter (main branch) compiles parsers on install. Grammars that
    # don't ship a prebuilt parser.c (e.g. haskell) need the `tree-sitter` CLI to
    # run `tree-sitter generate`; all parsers need a C compiler to build.
    tree-sitter
    gcc # cc
  ];
}
