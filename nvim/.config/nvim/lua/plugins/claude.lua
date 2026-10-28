-- Claude Code runs in tmux window "ai" (see tmux-dev-layout), not inside Neovim.
--
--   visual <leader>aa  Ask Claude Code: type a question, it's sent to the "ai"
--                      window with the selection as @file#L10-24. Edits come
--                      back as a diff here: :w accepts, :q rejects.
--   visual <leader>aq  Quick question: answer in a float, read-only.
--
-- claudecode.nvim provides the IDE connection (diffs, selection, open files);
-- Claude Code connects to it when started with `claude --ide`.

-- Linewise range and text of the visual selection (call after leaving visual mode).
local function selection()
  local first, last = vim.fn.line("'<"), vim.fn.line("'>")
  return {
    file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":."),
    first = first,
    last = last,
    text = table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n"),
    ft = vim.bo.filetype,
  }
end

-- Leave visual mode (so '< and '> are set), then ask for the question.
local function with_question(prompt, fn)
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  local sel = selection()
  vim.ui.input({ prompt = prompt }, function(question)
    if question and question ~= "" then
      fn(sel, question)
    end
  end)
end

local function send_to_claude(sel, question)
  if not vim.env.TMUX then
    return vim.notify("Not inside tmux", vim.log.levels.ERROR)
  end
  local session = vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "-t", vim.env.TMUX_PANE, "#S" }))
  local target = "=" .. session .. ":ai"
  local message = ("@%s#L%d-%d %s"):format(sel.file, sel.first, sel.last, question)
  vim.fn.system({ "tmux", "send-keys", "-t", target, "-l", message })
  vim.fn.system({ "tmux", "send-keys", "-t", target, "Enter" })
  if vim.v.shell_error ~= 0 then
    return vim.notify("No 'ai' window in session " .. session, vim.log.levels.ERROR)
  end
  vim.notify("Sent to Claude Code", vim.log.levels.INFO)
end

local function quick_question(sel, question)
  local win = Snacks.win({
    text = { "_Asking Claude…_" },
    width = 0.6,
    height = 0.6,
    border = "rounded",
    title = " " .. question .. " ",
    bo = { filetype = "markdown" },
    wo = { wrap = true, conceallevel = 2 },
  })
  local prompt = ("File: %s, lines %d-%d\n\n```%s\n%s\n```\n\n%s\n\nAnswer concisely."):format(
    sel.file, sel.first, sel.last, sel.ft, sel.text, question)
  -- Plan mode: Claude can read the project for context but can't change anything.
  vim.system({ "claude", "-p", "--permission-mode", "plan" }, { stdin = prompt, text = true }, function(out)
    vim.schedule(function()
      if not win:valid() then
        return
      end
      local answer = out.code == 0 and out.stdout or ("**Error**\n\n" .. (out.stderr or ""))
      vim.bo[win.buf].modifiable = true
      vim.api.nvim_buf_set_lines(win.buf, 0, -1, false, vim.split(vim.trim(answer), "\n"))
      vim.bo[win.buf].modifiable = false
    end)
  end)
end

return {
  {
    "coder/claudecode.nvim",
    lazy = false, -- start the IDE server with Neovim so `claude --ide` finds it
    opts = {
      terminal = { provider = "none" }, -- Claude runs in tmux, not in a Neovim terminal
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
      {
        "<leader>aa",
        function() with_question("Ask Claude Code: ", send_to_claude) end,
        mode = "x",
        desc = "Ask Claude Code (can edit)",
      },
      {
        "<leader>aq",
        function() with_question("Quick question: ", quick_question) end,
        mode = "x",
        desc = "Quick Question (read-only)",
      },
    },
  },
}
