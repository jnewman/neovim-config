# Nix Style Guide

## Formatter

Use **nixfmt** (nixfmt-rfc-style) for all `.nix` files. Run via `nix fmt`.

## Flake Structure

```
flake.nix         -- inputs, outputs, nixosConfigurations / homeConfigurations
modules/          -- reusable NixOS/home-manager modules
overlays/         -- package overrides
```

## Attribute Naming

- Use `camelCase` for local bindings inside `let … in`
- Use `kebab-case` for derivation names and package attributes (nixpkgs convention)
- Use `snake_case` only where upstream nixpkgs does (rare)

## Imports & Inputs

Pin all flake inputs via `flake.lock`. Reference inputs explicitly in `outputs` arguments — do not use `with inputs;`.

```nix
# good
outputs = { self, nixpkgs, home-manager, ... }:

# avoid
outputs = inputs: with inputs;
```

## home-manager Neovim Modules

Declare plugins, LSP servers, and formatters as `programs.neovim.plugins` or via `home.packages`. Do not mix manual plugin installation with Nix-managed plugins.

## Let Bindings

Use `let … in` for any value referenced more than once:

```nix
let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  ...
}
```

## Comments

Comment non-obvious `nixpkgs` workarounds, overlay reasons, or version pins with a brief `why`.
