# Conductor Workflow

## Test Coverage

- Minimum **80% code coverage** required before a task is marked complete.
- Coverage must be measured and verified, not estimated.

## Commit Cadence

- Commit after **each completed task**.
- Commit message format: `<type>(<track-id>): <short description>`
- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## Task Summaries

- Use **Git Notes** to attach a brief summary to each task commit.
- Summary should capture: what was done, any non-obvious decisions, and any follow-up needed.
- Format: `git notes add -m "<summary>" HEAD`

## Task Completion Protocol

Before marking any task complete:
1. All acceptance criteria from `plan.md` are met
2. Tests written and passing
3. Coverage at or above 80%
4. Code formatted (stylua for Lua, nixfmt for Nix)
5. Commit made with Git Note attached

## Manual Verification Tasks

Each phase ends with a `Conductor - User Manual Verification` task. This requires the user to:
- Confirm the phase output meets expectations
- Approve before proceeding to the next phase

## Track Completion Protocol

When a track is fully implemented and all phases pass verification:

1. Push the branch: `git push -u origin <branch>`
2. File a Pull Request:
   ```bash
   gh pr create --title "<track title>" --body "<summary of changes>"
   ```
3. Open the PR in Octo for review:
   - In Neovim: `<leader>gpo` to open the current branch's PR, or
   - `:Octo pr list` (`<leader>gpl`) to pick from open PRs
4. Review changes with `:Octo review start` (`<leader>grs`), leave comments, then submit with `<leader>grS`
5. Merge via Octo or `gh pr merge` once approved
