-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Personal cheat sheet in a floating window (q to close).
vim.keymap.set("n", "<leader>k", function()
  Snacks.win({
    file = vim.fn.stdpath("config") .. "/cheatsheet.md",
    width = 0.7,
    height = 0.85,
    border = "rounded",
    title = " Cheat sheet ",
    bo = { modifiable = false, filetype = "markdown" },
    wo = { wrap = false, spell = false, conceallevel = 2 },
  })
end, { desc = "Cheat Sheet" })
