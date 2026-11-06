# Minimal Bash compatibility config. Zsh is the primary managed shell.

case $- in
  *i*) ;;
  *) return ;;
esac

export EDITOR=vim

case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) PATH="$HOME/bin:$PATH" ;;
esac

case ":$PATH:" in
  *":./node_modules/.bin:"*) ;;
  *) PATH="./node_modules/.bin:$PATH" ;;
esac
export PATH

alias l='ls -al'
alias _='sudo'
alias ...='../..'

# Claude Code sets CLAUDECODE=1 and runs its commands in a shell that loads
# these aliases. Agents expect the coreutils flags and a cp/mv that does not
# stop to ask, so the replacements stay out of their shells.
if [[ -z "${CLAUDECODE:-}" ]]; then
  alias cp='cp -i'
  alias mv='mv -i'

  if command -v lsd > /dev/null 2>&1; then
    alias ls='lsd'
  fi

  if command -v bat > /dev/null 2>&1; then
    alias cat='bat'
  elif command -v batcat > /dev/null 2>&1; then
    alias cat='batcat'
  fi
fi

if [[ -f ~/.bashrc.local ]]; then
  # shellcheck disable=SC1090
  . ~/.bashrc.local
fi
