#!/usr/bin/env bash
set -euo pipefail

CONTAINER="nvim-lsp"
IMAGE="nvim-lsp"

# On a nix host the editor runs language servers natively; no container is needed.
if command -v nix &>/dev/null; then
  exit 0
fi

if ! docker info &>/dev/null; then
  echo "nvim-lsp: Docker is not running" >&2
  exit 1
fi

if docker inspect --type container "$CONTAINER" &>/dev/null; then
  STATUS=$(docker inspect --type container --format='{{.State.Status}}' "$CONTAINER")
  if [ "$STATUS" = "running" ]; then
    exit 0
  else
    docker start "$CONTAINER" &>/dev/null
    echo "nvim-lsp: started"
  fi
else
  docker run -d --name "$CONTAINER" "$IMAGE" &>/dev/null
  echo "nvim-lsp: created and started"
fi
