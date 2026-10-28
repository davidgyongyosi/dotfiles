-- Claude Code runs in tmux (see tmux-dev-layout), not inside Neovim.
--
--   visual <leader>aa  Ask: a temporary Claude Code in a side pane gets the
--                      selection + your question; the pane closes when you
--                      exit it. Window "ai" stays free for long discussions.
--   visual <leader>as  Send the selection + question to the long-running
--                      Claude Code in window "ai" instead.
--   visual <leader>aq  Quick question: answer in a float, read-only.
--
-- Edits from either Claude come back as a diff here: :w accepts, :q rejects.
-- claudecode.nvim provides that IDE connection; Claude Code connects to it
-- when started with `claude --ide`.

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

local function ask_in_pane(sel, question)
  if not vim.env.TMUX then
    return vim.notify("Not inside tmux", vim.log.levels.ERROR)
  end
  -- The prompt goes through a temp file to avoid shell-quoting the code.
  local prompt_file = vim.fn.tempname()
  vim.fn.writefile(vim.split(("In @%s, lines %d-%d:\n\n```%s\n%s\n```\n\n%s"):format(
    sel.file, sel.first, sel.last, sel.ft, sel.text, question), "\n"), prompt_file)
  -- -d keeps focus in Neovim; the pane closes when this Claude exits.
  vim.fn.system({
    "tmux", "split-window", "-d", "-h", "-l", "40%", "-t", vim.env.TMUX_PANE, "-c", vim.fn.getcwd(),
    ("claude --ide \"$(cat '%s')\"; rm -f '%s'"):format(prompt_file, prompt_file),
  })
  if vim.v.shell_error ~= 0 then
    return vim.notify("Couldn't open the Claude pane", vim.log.levels.ERROR)
  end
end

local function send_to_session(sel, question)
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
        function() with_question("Ask Claude Code: ", ask_in_pane) end,
        mode = "x",
        desc = "Ask Claude Code (temporary pane)",
      },
      {
        "<leader>as",
        function() with_question("Send to Claude session: ", send_to_session) end,
        mode = "x",
        desc = "Send to Claude Session (window ai)",
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
