# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->


## Build & Test

_Add your build and test commands here_

```bash
# Example:
# npm install
# npm test
```

## Architecture Overview

_Add a brief overview of your project architecture_

## Conventions & Patterns

### Keep docs in sync with config

`docs/` is the usage reference: one page per plugin under `docs/plugins/`, core
(non-plugin) keymaps in `docs/editor.md`, all indexed from `docs/README.md`.
Keybindings live in `lua/config/keymaps.lua` and each `lua/config/*.lua`.

When you add or change a keybinding, plugin, or config option, update the matching
doc page **in the same change** — and add it to `docs/README.md` if it's a new page.
Before wrapping up, skim the docs for the areas you touched and confirm they still
match the code (e.g. a plugin doc claiming "no keymaps configured" when keymaps now
exist).

### Compress local Claude settings

`.claude/settings.local.json` accumulates ad-hoc `permissions.allow` entries as you
approve commands during sessions. Periodically clean it up:

- Merge specific commands into broad glob patterns (e.g. many `bd ...` entries →
  `Bash(bd *)`, granular `nix ...` entries → `Bash(nix *)`).
- Drop one-off entries that won't recur (throwaway `python3 -c`/`node -e` checks,
  debugging invocations).
- Remove `Read(...)` rules already covered by `.claude/settings.json` (`Read(**)`).

Keep the list short and pattern-based rather than a long log of exact commands.
