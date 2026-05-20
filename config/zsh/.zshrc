# For environment variables and PATH setup, see ~/.zshenv.

# Options
setopt nobeep
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
unsetopt flow_control

# Do not consider these characters part of a word.
WORDCHARS=${WORDCHARS//[&.;]}

# Key bindings
bindkey -e
bindkey '^Q' push-line
bindkey '^[[3~' delete-char
bindkey '[2~' overwrite-mode
bindkey '^[[7~' beginning-of-line
bindkey '^[[H' beginning-of-line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
fi
bindkey '^[[8~' end-of-line
bindkey '^[[F' end-of-line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey "${terminfo[kend]}" end-of-line
fi
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# History
setopt hist_verify
setopt share_history
setopt hist_ignore_dups
setopt hist_find_no_dups
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

# Prompt
autoload -U colors && colors

function parse_git_dirty() {
  local git_status
  git_status=$(git status --porcelain 2> /dev/null | tail -n1)
  if [[ -n "$git_status" ]]; then
    echo "%F{#ff0000}✗"
  else
    echo "%F{green}✓"
  fi
}

function git_prompt_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo "%{$fg[white]%}[%F{default}${ref#refs/heads/}$(parse_git_dirty)%{$fg[white]%}] "
}

setopt prompt_subst
PROMPT="%m|%{$fg[cyan]%}%80<…<%~%<<"$'\n$(git_prompt_info)'"%(?.%F{white}.%F{red})%#%{$reset_color%} "
RPROMPT="%{$fg[cyan]%}%*%{$reset_color%}"

# Auto-suggest
for autosuggest_source in \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  if [[ -r "$autosuggest_source" ]]; then
    source "$autosuggest_source"
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888'
    break
  fi
done
unset autosuggest_source

# Aliases
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git cz'
alias gcb='git checkout -b'
alias gcl='git clone --filter=blob:none'
alias gcmsg='git commit -m'
alias gs='git switch'
alias grs='git restore'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --graph --decorate'
alias gm='git merge'
alias gp='git push'
alias gst='git status'

if command -v fzf > /dev/null 2>&1; then
  alias gcof='gco $(gb | fzf)'
  alias gbdf='gb -d $(gb | fzf -m)'
  alias gbDf='gb -D $(gb | fzf -m)'
fi

if command -v lsd > /dev/null 2>&1; then
  alias ls='lsd'
fi
alias l='ls -al'
alias cp='cp -i'
alias mv='mv -i'
alias _='sudo'
alias ...='../..'
alias cc='claude'

if command -v bat > /dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat > /dev/null 2>&1; then
  alias cat='batcat'
fi

# Completion
setopt complete_in_word
setopt always_to_end
if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' menu select=2

autoload -U compinit
compinit -d

# SSH agent
if command -v pgrep > /dev/null 2>&1 && command -v ssh-agent > /dev/null 2>&1; then
  ssh_agent_env="${XDG_RUNTIME_DIR:-/tmp}/ssh-agent.env"
  if ! pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
    ssh-agent > "$ssh_agent_env"
  fi
  if [[ -z "${SSH_AUTH_SOCK:-}" && -r "$ssh_agent_env" ]]; then
    eval "$(<"$ssh_agent_env")" > /dev/null
  fi
  unset ssh_agent_env
fi

# nvm
for nvm_source in \
  /usr/share/nvm/init-nvm.sh \
  "$HOME/.nvm/nvm.sh"; do
  if [[ -r "$nvm_source" ]]; then
    source "$nvm_source"
    break
  fi
done
unset nvm_source

# Directory jumping
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
fi

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
