# AGENTS.md

General working agreement for all repositories. Repo-specific `AGENTS.md` files
add detail and win on conflict.

## Working Agreement

- **Plan before non-trivial work.** Outline the approach and wait for approval.
  Small, obvious fixes don't need a plan.
- **Once a plan is approved, run it to completion autonomously** — implement,
  iterate against the mechanical feedback loop (types, lint, tests), commit,
  push, open the PR. Don't check in between mechanical steps.
- **Scope discipline.** If something adjacent is broken and blocking, fix the
  minimum needed to get unblocked. Everything else you noticed goes in a list at
  the end for a human to decide on. Don't fold unrelated cleanups into a PR.
- **Report faithfully.** If tests fail, say so and show the output. If a step
  was skipped, say that. Never describe unverified work as done.
- Language is **English everywhere** — code, comments, commits, docs, PR
  descriptions, and conversation.

## Git and GitHub

The following applies to every git repository always!

- NEVER commit or push directly to the default branch. Check which one it is —
  it is `main` in most repos but `master` in some.
- Create a dedicated branch for your work named according to repo standards.
- When you want to make your work available on GitHub, push the branch and open
  a pull request targeting the default branch.
- NEVER approve, merge, or enable auto-merge for a pull request.
- Approving and merging to the default branch is always exclusively for humans.

Commits:

- **Conventional Commits** (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`,
  `test:`), with a scope where it clarifies: `feat(digests): ...`.
- No AI attribution — no `Co-Authored-By` trailer on commits, no "Generated
  with" footer in PR bodies.
- Commit in logical units. Don't bundle a refactor and a feature into one
  commit.

## Definition of Done

Before pushing or opening a PR, all three of these must be green:

1. **Type check**
2. **Lint**
3. **Tests** — the full suite, not just the affected tests

Always invoke them through the repo's own scripts, using the repo's package
manager. Never run a tool directly when a script wraps it — a bare `tsc`, for
example, writes compiled output into the working tree instead of just checking
types.

If something fails and you cannot fix it within the scope of the task, **stop
and report** rather than pushing. A red PR is worse than no PR.

## Testing

- Write tests alongside the change for **logic**: parsers, services, business
  rules, edge cases, error paths.
- Don't write tests proactively for React components, layout, or thin glue
  code. Ask first if you think they're warranted.
- Never weaken or delete an existing test to make a change pass. If a test is
  genuinely wrong, say so explicitly and explain why.

## Code Conventions

Defaults across all projects — a repo's own config always wins.

- **TypeScript strict.** Use `unknown` over `any`. Explicit return types on
  exported functions.
- **Validate all external input with Zod** — HTTP bodies, webhooks, env vars,
  third-party API responses.
- **Formatting is Prettier's job**: `semi: false`, single quotes,
  `arrowParens: "avoid"`. Never hand-format; never reformat untouched lines.
- **Naming**: `verbNoun` for functions, `camelCase` for variables,
  `UPPER_SNAKE_CASE` for constants, `kebab-case.ts` for files.
- Prefer structured logging with context over `console.log`.
- Match the surrounding code's idiom, comment density, and naming. Comments
  explain *why*, not *what*.
- Don't add dependencies for things the standard library or an existing
  dependency already does. Flag new dependencies in the PR description.

## Documentation

If a change makes existing documentation stale, update it in the same change.
Don't leave completed work listed as open or as "next focus". Don't create new
documentation files unless asked.

## Safety

- Never commit secrets, tokens, real email addresses, or machine-specific
  private values. Public-safe repos rely on local override files
  (`*.local`) — keep it that way.
- Never run destructive git operations (`push --force`, `reset --hard`,
  branch deletion) on work you didn't create without asking.
- Don't touch production data or run migrations against non-local databases.
