#!/usr/bin/env bash
# Verify the yq_yaml formatter (lua/config/format.lua) end to end: runs the real
# config through conform.nvim in headless nvim against sample YAML buffers.
#
# Usage: scripts/yaml-fmt-smoke.sh
set -euo pipefail
cd "$(dirname "$0")/.."

nixexpr='let f = builtins.getFlake (toString ./.); pkgs = f.inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; in'
build() { nix build --impure --no-link --print-out-paths --extra-experimental-features 'nix-command flakes' --expr "$nixexpr $1"; }

echo "Building neovim + conform.nvim + yq..."
NVIM=$(build pkgs.neovim)
CONFORM=$(build pkgs.vimPlugins.conform-nvim)
YQ=$(build pkgs.yq-go)
AWK=$(build pkgs.gawk.out)

# Minimal PATH: the formatter pipeline needs sh (/bin), yq, and awk.
env -i HOME=/tmp/yaml-fmt-smoke-home PATH="$NVIM/bin:$YQ/bin:$AWK/bin:/bin" \
  "$NVIM/bin/nvim" --headless -u NONE --cmd "set rtp^=$CONFORM" --cmd "set rtp^=$PWD" \
  -l scripts/yaml-fmt-smoke.lua
