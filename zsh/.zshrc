# Homebrew on Linux/WSL. (On macOS, ~/.zprofile runs /opt/homebrew's shellenv.)
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

PATH=$HOME/.dotnet/tools:$PATH
export PATH="$HOME/.local/bin:$PATH"
source "$HOME/.docker/init-zsh.sh" 2>/dev/null || true # Added by Docker Desktop

export EDITOR=nvim
export VISUAL=nvim

# History shared across tmux panes, without duplicates.
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

# Completion system (needed by the ng/bun/brew completions below).
autoload -Uz compinit && compinit

# Load Angular CLI autocompletion. Generating it spawns node on every shell,
# so cache it and regenerate with: rm ~/.cache/ng-completion.zsh
if [[ ! -s ~/.cache/ng-completion.zsh ]] && command -v ng >/dev/null; then
  mkdir -p ~/.cache && ng completion script > ~/.cache/ng-completion.zsh
fi
[[ -s ~/.cache/ng-completion.zsh ]] && source ~/.cache/ng-completion.zsh


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# nvm is loaded lazily on the first `nvm` call; node itself comes from Vite+.
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

export PATH="$HOME/.cargo/bin:$PATH"

# Vite+ bin (https://viteplus.dev)
[ -s "$HOME/.config/vite-plus/env" ] && . "$HOME/.config/vite-plus/env"

# fzf: Ctrl-R history search, Ctrl-T file picker, Alt-C cd into a directory.
source <(fzf --zsh)

# zoxide: `z proj` jumps to the best-matching directory you've visited
# (also feeds tmux-sessionx's zoxide mode).
eval "$(zoxide init zsh)"
