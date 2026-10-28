-- Sidekick runs Claude Code in a split on the right; the base setup and keys
-- come from LazyVim's ai.sidekick extra. Here: always use Claude (opencode and
-- codex are installed too, which would otherwise prompt for a tool), and turn
-- off Copilot next edit suggestions.
local function claude(fn, opts)
  return function()
    require("sidekick.cli")[fn](vim.tbl_extend("force", { name = "claude" }, opts or {}))
  end
end

return {
  {
    "folke/sidekick.nvim",
    opts = { nes = { enabled = false } },
    -- stylua: ignore
    keys = {
      { "<tab>", false, mode = "n" },      -- NES only
      { "<leader>as", false },             -- tool picker
      { "<leader>aa", claude("toggle", { focus = true }), desc = "Toggle Claude" },
      { "<leader>at", claude("send", { msg = "{this}" }), mode = { "x", "n" }, desc = "Send This" },
      { "<leader>af", claude("send", { msg = "{file}" }), desc = "Send File" },
      { "<leader>av", claude("send", { msg = "{selection}" }), mode = "x", desc = "Send Visual Selection" },
      { "<leader>ap", claude("prompt"), mode = { "n", "x" }, desc = "Sidekick Select Prompt" },
    },
  },
}
