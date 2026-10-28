-- Plugins LazyVim (or one of its extras) would load, but I don't use.
return {
  -- Buffer tabs: harpoon (<leader>h, <leader>1-5) and <leader>, replace them.
  { "akinsho/bufferline.nvim", enabled = false },
  -- Fallback colorscheme; catppuccin is used everywhere.
  { "folke/tokyonight.nvim", enabled = false },
  -- Browser preview; render-markdown.nvim already renders markdown in the buffer.
  { "iamcco/markdown-preview.nvim", enabled = false },
}
