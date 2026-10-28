-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.updatetime = 200
vim.opt.colorcolumn = "80"

-- Needed for the "%S" (pending command) component in lualine.
vim.opt.showcmdloc = "statusline"
