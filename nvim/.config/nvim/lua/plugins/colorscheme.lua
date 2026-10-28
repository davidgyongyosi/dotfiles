-- Catppuccin Mocha everywhere: Ghostty (theme), tmux (catppuccin plugin) and
-- here. LazyVim already ships the plugin spec; these opts are merged into it.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      -- Let Ghostty's background-opacity/blur show through.
      transparent_background = true,
      float = { transparent = true, solid = false },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
