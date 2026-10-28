# dotfiles

Terminal setup: **Ghostty** → **tmux** → **Neovim (LazyVim)**, all in Catppuccin Mocha.
Built on macOS; runs on Windows through WSL2 ([see below](#windows-wsl2)).

| Package | Links to | What |
|---|---|---|
| `ghostty` | `~/.config/ghostty/` | Terminal: theme, font, transparency, Option as Alt |
| `tmux` | `~/.tmux.conf` | Prefix `C-Space`, sessionx picker (`prefix o`), resurrect/continuum |
| `bin` | `~/.local/bin/` | `tmux-dev-layout`: new sessions in `~/Projects` open as `1: nvim  2: ai` |
| `nvim` | `~/.config/nvim/` | LazyVim + extras; `Space k` opens the [cheat sheet](nvim/.config/nvim/cheatsheet.md) |
| `zsh` | `~/.zshrc` | fzf, zoxide, lazy nvm, cached completions |
| `windows-terminal/` | (copy by hand) | Windows Terminal equivalent of the Ghostty config, for WSL2 |

Each folder is a [GNU Stow](https://www.gnu.org/software/stow/) package: its contents mirror `$HOME`, and
`stow` symlinks them into place, so editing `~/.config/nvim/...` edits this repo.

## Install

```sh
git clone https://github.com/davidgyongyosi/dotfiles ~/dotfiles
cd ~/dotfiles
brew bundle            # tools from the Brewfile
stow ghostty tmux bin nvim zsh
```

Then start `tmux` (plugins install on first launch) and `nvim` (LazyVim installs plugins and LSPs).
The AI tool in the dev layout is [Claude Code](https://claude.com/claude-code); change
`@dev-ai-command` in `tmux/.tmux.conf` to use another.

## Windows (WSL2)

tmux, zsh and stow need a Unix system, so on Windows everything runs inside WSL2;
only the terminal and the font live on the Windows side.

1. **Windows side** (PowerShell):
   ```powershell
   wsl --install                                   # Ubuntu; reboot if asked
   winget install DEVCOM.JetBrainsMonoNerdFont     # or download from nerdfonts.com
   winget install equalsraf.win32yank              # clipboard for Neovim outside tmux
   ```
   Then merge [`windows-terminal/settings.jsonc`](windows-terminal/settings.jsonc) into
   Windows Terminal's settings (Catppuccin Mocha, font, transparency, Ctrl+V freed for Neovim).
2. **Inside WSL** (Ubuntu):
   ```sh
   sudo apt update && sudo apt install -y zsh git build-essential
   chsh -s "$(which zsh)"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
   git clone https://github.com/davidgyongyosi/dotfiles ~/dotfiles
   cd ~/dotfiles
   brew bundle                     # casks are skipped on Linux
   stow tmux bin nvim zsh          # no ghostty package
   ```
3. Keep repos in the Linux filesystem (`~/Projects`), **not** under `/mnt/c/`; Git, LSPs and
   file watching are many times slower across that boundary.

Copying inside tmux reaches the Windows clipboard through OSC 52, which Windows Terminal supports.

## Workflow

- `prefix o` → pick a repo → session with Neovim in window 1 and the AI TUI in window 2
- `prefix p` / `prefix n` to switch between them
- In Neovim, no file tree: `Space Space` find file, `Space /` grep, harpoon `Space H` / `Space 1-5`
