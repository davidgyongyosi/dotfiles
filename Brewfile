# brew bundle --file ~/dotfiles/Brewfile
# Works on macOS and Linux/WSL; casks are macOS-only.

# Terminal (on Windows: Windows Terminal + the font installed on the Windows side)
if OS.mac?
  cask "ghostty"
  cask "font-jetbrains-mono-nerd-font"
end

# Multiplexer, editor, dotfile linking
brew "tmux"
brew "neovim"
brew "stow"

# Search and navigation (used by Neovim, tmux-sessionx and the shell)
brew "fzf"
brew "ripgrep"
brew "fd"
brew "zoxide"

# Git
brew "gh"
brew "lazygit"

# Languages
brew "go"
