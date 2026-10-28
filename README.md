# dotfiles

macOS terminal setup: **Ghostty** → **tmux** → **Neovim (LazyVim)**, all in Catppuccin Mocha.

| Package | Links to | What |
|---|---|---|
| `ghostty` | `~/.config/ghostty/` | Terminal: theme, font, transparency, Option as Alt |
| `tmux` | `~/.tmux.conf` | Prefix `C-Space`, sessionx picker (`prefix o`), resurrect/continuum |
| `bin` | `~/.local/bin/` | `tmux-dev-layout`: new sessions in `~/Projects` open as `1: nvim  2: ai` |
| `nvim` | `~/.config/nvim/` | LazyVim + extras; `Space k` opens the [cheat sheet](nvim/.config/nvim/cheatsheet.md) |
| `zsh` | `~/.zshrc` | fzf, zoxide, lazy nvm, cached completions |

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

## Workflow

- `prefix o` → pick a repo → session with Neovim in window 1 and the AI TUI in window 2
- `prefix p` / `prefix n` to switch between them
- In Neovim, no file tree: `Space Space` find file, `Space /` grep, harpoon `Space H` / `Space 1-5`
