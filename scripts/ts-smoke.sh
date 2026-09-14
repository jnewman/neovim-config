#!/usr/bin/env bash
# Verify the prebuilt tree-sitter parser pack + the main-branch treesitter.lua
# port: parsers load and highlighting activates with NO compiler / tree-sitter
# CLI on PATH. Builds the pack from the flake, then runs two headless checks
# against a minimal PATH (only the neovim binary).
#
# Usage: scripts/ts-smoke.sh
set -euo pipefail
cd "$(dirname "$0")/.."

nixexpr='let f = builtins.getFlake (toString ./.); pkgs = f.inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; in'

echo "Building parser pack + neovim + nvim-treesitter..."
PACK=$(nix build --impure --no-link --print-out-paths --extra-experimental-features 'nix-command flakes' \
  --expr "$nixexpr import ./modules/treesitter-parsers.nix {
    inherit pkgs;
    nvim-treesitter = pkgs.vimPlugins.nvim-treesitter;
    languages = [ \"bash\" \"c\" \"go\" \"gomod\" \"gowork\" \"haskell\" \"hcl\" \"html\" \"json\" \"markdown\" \"markdown_inline\" \"python\" \"ruby\" \"rust\" \"scala\" \"tsx\" \"typescript\" \"xml\" \"yaml\" ];
  }")
NVIM=$(nix build --impure --no-link --print-out-paths --extra-experimental-features 'nix-command flakes' \
  --expr "$nixexpr pkgs.neovim")
TSPLUGIN=$(nix build --impure --no-link --print-out-paths --extra-experimental-features 'nix-command flakes' \
  --expr "$nixexpr pkgs.vimPlugins.nvim-treesitter")

# Minimal PATH: only nvim. Proves no gcc/tree-sitter is needed at runtime.
run() { env -i HOME=/tmp/ts-smoke-home PATH="$NVIM/bin" "$NVIM/bin/nvim" "$@"; }

echo "[1/2] parser pack smoke (no compiler on PATH)..."
run --headless -u NONE --cmd "set rtp^=$PACK" -l scripts/ts-parser-smoke.lua

echo "[2/2] config integration smoke (real lua/config/treesitter.lua)..."
run --headless -u NONE \
  --cmd "set rtp^=$PACK" --cmd "set rtp^=$TSPLUGIN" --cmd "set rtp^=$PWD" \
  -l scripts/ts-config-smoke.lua

echo "OK: tree-sitter parser pack + config port verified."
