#!/usr/bin/env bash
set -euo pipefail

# Run a Nix invocation for this repo. On a nix host (the `nix` executable is on
# PATH) run it directly; otherwise run it inside the nixos/nix Docker container
# against the repo. The same command string works in both modes.
#
# Usage: nix-run.sh '<command that uses nix>'

CMD="$1"

if command -v nix &>/dev/null; then
  eval "$CMD"
else
  docker run --rm \
    -v "$PWD:/repo" \
    -w /repo \
    nixos/nix \
    sh -c "printf '[safe]\n\tdirectory = *\n' > /etc/gitconfig && $CMD"
fi
