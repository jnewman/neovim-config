# Product Guide: neovim-config

## Vision

A full-featured, IDE-like Neovim configuration managed declaratively via Nix and home-manager.
The config targets professional software development across multiple ecosystems, prioritizing
capability and reliability over minimalism.

## Target User

A developer who wants the power of a modern IDE inside Neovim, with the reproducibility and
portability of a Nix-managed environment.

## Primary Languages & Ecosystems

- Python
- JavaScript / TypeScript
- Go
- Rust
- Scala

## Core Features

- **LSP Integration** — Language servers for all target languages; completions, diagnostics,
  go-to-definition, hover, rename, and code actions via nvim-lspconfig or equivalent
- **Debugging (DAP)** — Integrated debugger via nvim-dap with per-language adapter config
- **File Explorer** — Project tree navigation
- **Fuzzy Finding** — File, grep, symbol, and buffer search

## Configuration Approach

Managed entirely by Nix home-manager. Neovim, plugins, language servers, and formatters are
all declared as Nix packages — no manual plugin installation.

## Stability & Reproducibility

Semi-stable: Nix flake inputs are pinned and committed (flake.lock), ensuring reproducibility
across machines. Inputs are periodically updated (`nix flake update`) to pull in improvements,
but not on every build.
