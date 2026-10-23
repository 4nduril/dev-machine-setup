# AGENTS.md

## General

Do not start work prematurely. Follow the user's instructions closely: When they ask a question, answer the question. When they use words like "create" or "implement" or "do" (list not exhausitve), then start actual work. "Can we do this …?" or "Would it be possible to …?" are not instructions to start any implementation but genuine questions.

Once work hast started execute it until user input is really needed. Do not stop in between to ask if the next obvious step should also be done. Just do after the initial instruction.

Resist scope creep. If something adjacent is broken and blocking, fix the minimum needed to get unblocked. Everything else you noticed goes in a list at the end for the user to decide on.

Verify results. Code should always be tested according to best practices. Unverified work is not done.

Never run destructive git operations (`push --force`, `reset --hard`, branch deletion) on work you didn't create without asking.

Don't touch production data or run migrations against non-local databases.

## Git and GitHub

When changing code ALWAYS work on a branch separate to the default branch in a worktree. NEVER change the default checkout, it belongs to the user and you should treat it read-only.

Branch naming should follow repo standards. 

Merging to the default branch, no matter if locally or via a pull request, is by default exclusively for humans. The user may allow otherwise but they must do explicitly in the active thread. In doubt treat as denied.

Commits should follow conventional commits with optional scope where it clarifies. Consider exisiting repo standards, they win.

One commit per logical unit of work.

No attribution of Agent authors. Neither in PR descriptions nor in commit messages. No `Co-Authored-By` or `Generated with` or similar.

## Coding Standards

Strict Typescript. Prefer `type` over `interface` but follow existing convention in the same file. No `any`, use `unknown` instead. Use implicit types where possible. Don't over-annotate. Explicit return types on exports.

Prefer functional style. For list processing e.g. use `map`, `reduce`, `filter` etc. No imperative loops unless there is a clear benefit. Prefer immutable values.

Validate all external input with Zod. HTTP bodies, webhooks, env vars, third-party API responses.

Naming: `verbNoun` for functions, `camelCase` for variables, `UPPER_SNAKE_CASE` for constants, `kebab-case.ts` for files.

Prefer structured logging with context over `console.log`.

Match the surrounding code's idiom, comment density, and naming. Comments  explain *why*, not *what*.

Don't add dependencies for things the standard library or an existing dependency already does. Flag new dependencies in the PR description.

Write tests alongside the change for **logic**: parsers, services, business rules, edge cases, error paths.

Never weaken or delete an existing test to make a change pass. If a test is genuinely wrong, say so explicitly and explain why.

## Definition of Done

Before pushing or opening a PR, all three of these must be green:

1. **Type check**
2. **Lint**
3. **Tests** — the full suite, not just the affected tests

## Documentation

If a change makes existing documentation stale, update it in the same change. Don't leave completed work listed as open or as "next focus". Don't create new documentation files unless asked.

