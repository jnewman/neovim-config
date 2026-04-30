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
