typeset -U path
path=(./node_modules/.bin ~/bin ~/.local/bin $path)

# nvm (and the node/npm it puts on PATH) is loaded here rather than in
# .zshrc so PATH is correct in every shell, not just interactive ones:
# scripts, tmux panes fed commands immediately after creation, etc.
for nvm_source in \
  /usr/share/nvm/init-nvm.sh \
  "$HOME/.nvm/nvm.sh"; do
  if [[ -r "$nvm_source" ]]; then
    source "$nvm_source"
    break
  fi
done
unset nvm_source

# SSH agent. Prefer the systemd user-managed agent (socket-activated,
# one persistent instance per login, no manual process tracking) and
# only fall back to spawning a plain ssh-agent on systems that don't
# have it. Set here, not .zshrc, so scripts and non-interactive shells
# get a working SSH_AUTH_SOCK too.
if [[ -S "${XDG_RUNTIME_DIR:-/run/user/$UID}/openssh_agent" ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/openssh_agent"
elif command -v pgrep > /dev/null 2>&1 && command -v ssh-agent > /dev/null 2>&1; then
  ssh_agent_env="${XDG_RUNTIME_DIR:-/tmp}/ssh-agent.env"
  if ! pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
    ssh-agent > "$ssh_agent_env"
  fi
  if [[ -z "${SSH_AUTH_SOCK:-}" && -r "$ssh_agent_env" ]]; then
    eval "$(<"$ssh_agent_env")" > /dev/null
  fi
  unset ssh_agent_env
fi

if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
