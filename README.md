# dev-machine-setup

Personal Linux development machine setup.

The setup script has two profiles: **desktop** (the default) covers a
graphical machine including Kitty, fonts, and the coc-based Vim IDE setup.
**remote** (`--remote`) covers headless boxes such as servers and cloud
workspaces; see [Remote boxes](#remote-boxes).

This repo manages:

- Vim
- Zsh
- minimal Bash compatibility
- Kitty
- Git defaults
- EditorConfig, ESLint, and TypeScript home defaults
- shared coding-agent rules for Claude Code and Codex
- a `push-claude-config` script that syncs the local `~/.claude/CLAUDE.md`,
  `~/.claude/rules/` and `~/.claude/skills/` to remote boxes over SSH
  (deployed by the desktop profile; the private config itself is not part of
  this repo)
- a `bootstrap-worktree` script that makes a freshly created git worktree
  runnable, by copying the gitignored files the app needs from the main clone
  and installing the pinned tools and dependencies (deployed by the desktop
  profile; on remote boxes call it by its path in this repo)
- project-copyable templates
- the Literation Mono Nerd Font used for terminal/editor icons
- a Bash setup script for symlinking configs and bootstrapping user-space tools

The setup targets Arch-derived systems, including Manjaro, and Ubuntu.

## Safety Model

This repo is intended to be public-safe.

Tracked files must not contain real names, email addresses, tokens, or private
machine-specific values. Private overrides live in local files such as:

- `~/.zshrc.local`
- `~/.zshenv.local`
- `~/.bashrc.local`
- `~/.gitconfig.local`
- `~/.config/kitty/local.conf`
- `~/.vim/local.vim`

The setup script can create `~/.gitconfig.local` interactively. It can also
update `~/.npmrc` after asking first, because npm does not provide the same
clean include mechanism as Git.

## Requirements

Install system packages manually before running setup. The script prints the
current package list for the detected distro and profile and stops if
required tools are missing.

For the desktop profile, Arch / Manjaro:

```bash
sudo pacman -S --needed git bash vim zsh kitty ripgrep fzf bat lsd zoxide fontconfig openssh procps-ng curl ca-certificates zsh-autosuggestions nvm
```

Ubuntu:

```bash
sudo apt update
sudo apt install git bash vim zsh kitty ripgrep fzf bat lsd zoxide fontconfig openssh-client procps curl ca-certificates zsh-autosuggestions
```

Install `nvm` separately on Ubuntu before rerunning setup. On some Ubuntu
releases, the `bat` package exposes `batcat`; the shell config handles either
command.

The remote profile requires only `git bash vim zsh curl ca-certificates`.
`ripgrep fzf bat lsd zoxide` are optional there; the shell config picks them
up when present.

## Setup

```bash
git clone <repo-url> dev-machine-setup
cd dev-machine-setup
./scripts/setup            # desktop machine
./scripts/setup --remote   # headless box
```

The desktop setup:

1. checks required tools
2. initializes all plugin submodules
3. installs the Nerd Font into `~/.local/share/fonts/dev-machine-setup`
4. refreshes the font cache
5. symlinks managed configs
6. prompts for Git identity in `~/.gitconfig.local`
7. optionally prompts for npm author defaults in `~/.npmrc`
8. installs the latest Node via `nvm install node`
9. installs global npm packages
10. changes the default shell to Zsh

The script is intended to be rerunnable. Existing config files are not
overwritten silently: interactive runs ask before backing up and replacing a
file, and declining keeps the file and continues; non-interactive runs skip
it with a warning. Skipped files are reported at the end.

## Remote boxes

`./scripts/setup --remote` deploys the Zsh, Git, EditorConfig, Vim, and
agent-rules configs, and skips everything tied to a graphical machine or to
this repo's Node tooling: Kitty, the Nerd Font, the home ESLint/TypeScript
defaults, the ox LSP wrappers, npm author defaults, and the Node/nvm step.
Node on a remote box is the box's own concern (version manager, system
package, or nothing).

Vim plugin submodules are initialized without `coc.nvim` and without the
`opt/` plugins, so Vim runs as a plain native-package setup. The coc mappings
load only when the coc.nvim checkout is present, so the same vimrc serves
both profiles.

The remote profile does not touch `~/.bashrc`, because remote boxes usually
provision it themselves (PATH entries, tool activation, tokens). Instead of
`chsh`, which prompts for a password and does not survive boxes rebuilt from
an image, it appends a guarded block to the login profile that hands
interactive logins over to zsh. Non-interactive SSH commands keep running
under the login shell.

zsh-autosuggestions is available as a repo submodule
(`config/zsh/plugins/zsh-autosuggestions`), so it needs no system package;
the Zsh config prefers a system installation when one exists.

Non-interactive remote runs are prompt-free and rerunnable: existing files
the repo does not manage are skipped with a warning and reported at the end.
Interactive runs prompt for the Git identity and before replacing an
existing file, which is the way to review and adopt skipped files.
Machine-specific initialization (for example activating a tool manager)
belongs in `~/.zshrc.local` or `~/.zshenv.local`.

## Layout

```text
assets/
  fonts/
config/
  agents/
  bash/
  editorconfig/
  eslint/
  git/
  kitty/
  typescript/
  vim/
  zsh/
scripts/
templates/
```

Deployable configs live under `config/`. Project-copyable defaults live under
`templates/`.

## Templates

Copy files from `templates/` into projects when useful:

- `templates/editorconfig/.editorconfig`
- `templates/eslint/eslint.config.mts`
- `templates/prettier/.prettierrc.json`
- `templates/typescript/tsconfig.json`
- `templates/vitest/vitest.config.ts`

The EditorConfig, ESLint, and TypeScript defaults are also deployed to `$HOME`.
Prettier and Vitest are templates only.

## Coding Agent Rules

`config/agents/AGENTS.md` holds the general working agreement for coding agents
— git and PR rules, the definition of done, testing expectations, and shared
code conventions. It is deployed to both agent locations as symlinks to the same
file:

- `~/.codex/AGENTS.md` (Codex)
- `~/.claude/CLAUDE.md` (Claude Code)

Keep it tool-agnostic and repo-agnostic. Project-specific guidance belongs in an
`AGENTS.md` in that project, which takes precedence on conflict.

## Vim

The Vim setup uses native Vim packages and git submodules. It does not use a
separate plugin manager.

Managed Vim files live under:

```text
config/vim/.vimrc
config/vim/.vim/
```

Plugins live under:

```text
config/vim/.vim/pack/plugins/start
config/vim/.vim/pack/plugins/opt
```

Initialize plugins:

```bash
git submodule update --init --recursive
```

Optional plugins:

- `copilot.vim`
- `vim-latex`

`copilot.vim` is loaded explicitly from Vim with:

```vim
:CopilotEnable
```

After first load on a machine, run:

```vim
:Copilot setup
```

`vim-latex` loads automatically for LaTeX files.

Local Vim overrides belong in:

```text
~/.vim/local.vim
```

## Updating Vim Plugins

Example for a `start/` plugin:

```bash
cd config/vim/.vim/pack/plugins/start/<plugin-name>
git fetch origin
git checkout <tag-or-commit>
cd /path/to/dev-machine-setup
git add config/vim/.vim/pack/plugins/start/<plugin-name>
git commit -m "Update <plugin-name>"
```

Example for an `opt/` plugin:

```bash
cd config/vim/.vim/pack/plugins/opt/<plugin-name>
git fetch origin
git checkout <tag-or-commit>
cd /path/to/dev-machine-setup
git add config/vim/.vim/pack/plugins/opt/<plugin-name>
git commit -m "Update <plugin-name>"
```

If `.gitmodules` changed, stage it too:

```bash
git add .gitmodules
```

The parent repo commit stores the submodule pointer.
