-- Rex keys, for a Totem and a MacBook keyboard, both on macOS's Hungarian layout.
--
-- How Rex matches a key: by the character the key types without shift, on the
-- active layout. So "z" is the key that types z (the Y key cap), and "-" is the
-- key that types - (the / key cap). A name for a character that needs Option or
-- shift on Hungarian never fires: [ ] { } \ / = ; ' and 0. Names in brackets,
-- such as [Minus], are physical keys instead.
--
-- So the rules here:
--   * Letters first. They sit in the same place on both keyboards.
--   * Cmd+letter for what's used constantly. On the Totem, hold cmd on the
--     opposite hand from the letter: D for the right hand, K for the left.
--   * Prefix ctrl+space for the rest, with tmux's keys where they exist.
--   * No alt bindings: Option types @ { [ ] } \ and ~ on Hungarian.
--   * No ctrl bindings other than the prefix: Neovim owns those.
--   * No shortcut that needs a digit or an arrow together with cmd. On the
--     Totem those are on the NAV layer, which takes over the cmd key.

local function modal(mode, keys)
  for key, action in pairs(keys) do
    rex.bind(mode .. "/" .. key, action[1], action[2])
  end
end

-- Cmd+letter
rex.bind("cmd+u", "client.tab.previous")
rex.bind("cmd+i", "client.tab.next")
rex.bind("cmd+shift+u", "session.previous")
rex.bind("cmd+shift+i", "session.next")
rex.bind("cmd+j", "pane.focus_previous")
rex.bind("cmd+l", "pane.focus_next")
rex.bind("cmd+d", "pane.split", { direction = "right" })
rex.bind("cmd+shift+d", "pane.split", { direction = "down" })
rex.bind("cmd+e", "pane.zoom")
rex.bind("cmd+b", "client.sidebar.toggle")
rex.bind("cmd+p", "client.palette.toggle")
rex.bind("cmd+o", "dev_picker")
rex.bind("cmd+shift+7", "client.font.increase") -- "=" is shift+7 on Hungarian

-- Prefix: sending it through, and the config
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>space", "client.palette.toggle")
rex.bind("ctrl+space>r", "client.config.reload")

-- Prefix: sessions
rex.bind("ctrl+space>o", "dev_picker")
rex.bind("ctrl+space>s", "session.switch")
rex.bind("ctrl+space>shift+p", "session.previous")
rex.bind("ctrl+space>shift+n", "session.next")

-- Prefix: tabs. Digits are held on NAV on the Totem, which works here because
-- the prefix is already released.
rex.bind("ctrl+space>c", "client.tab.new")
rex.bind("ctrl+space>p", "client.tab.previous")
rex.bind("ctrl+space>n", "client.tab.next")
rex.bind("ctrl+space>,", "client.tab.rename")
for i = 1, 9 do
  rex.bind("ctrl+space>" .. i, "client.tab.goto", { index = i })
end

-- Prefix: splits. "%" is shift+5, and the tap on the Totem's left thumb layer key.
rex.bind("ctrl+space>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+space>-", "pane.split", { direction = "down" })
rex.bind("ctrl+space>shift+2", "pane.split", { direction = "down" }) -- tmux's "

-- Prefix: panes
rex.bind("ctrl+space>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+space>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+space>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+space>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+space>shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("ctrl+space>shift+j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("ctrl+space>shift+k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("ctrl+space>shift+l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("ctrl+space>z", "pane.zoom")
rex.bind("ctrl+space>x", "pane.close")
rex.bind("ctrl+space>shift+x", "pane.close_others")
rex.bind("ctrl+space>e", "pane.balance")
rex.bind("ctrl+space>shift+t", "pane.move_to_new_tab")
rex.bind("ctrl+space>d", "pane.go_to_directory")
rex.bind("ctrl+space>i", "pane.insert_path")

-- Prefix: floating panes, what tmux's popups were
rex.bind("ctrl+space>g", "pane.new_floating")
rex.bind("ctrl+space>b", "pane.float")
rex.bind("ctrl+space>m", "pane.minimize_all_floating")

-- Prefix: the rest of the app
rex.bind("ctrl+space>a", "client.sidebar.activity.toggle")
rex.bind("ctrl+space>f", "client.find.open")

-- Pane mode: prefix w, for doing several of these in a row, as tmux's bind -r
-- did. Escape is the tap on the Totem's ctrl pinky. Arrows move the pane.
rex.mode("pane", { exclusive = true })
rex.bind("ctrl+space>w", "client.mode.enter", { name = "pane" })
modal("pane", {
  escape = { "client.mode.exit" },
  enter = { "client.mode.exit" },
  h = { "pane.focus", { direction = "left" } },
  j = { "pane.focus", { direction = "down" } },
  k = { "pane.focus", { direction = "up" } },
  l = { "pane.focus", { direction = "right" } },
  ["shift+h"] = { "pane.resize", { amount = 5, direction = "left" } },
  ["shift+j"] = { "pane.resize", { amount = 5, direction = "down" } },
  ["shift+k"] = { "pane.resize", { amount = 5, direction = "up" } },
  ["shift+l"] = { "pane.resize", { amount = 5, direction = "right" } },
  left = { "pane.move", { direction = "left" } },
  down = { "pane.move", { direction = "down" } },
  up = { "pane.move", { direction = "up" } },
  right = { "pane.move", { direction = "right" } },
  p = { "client.tab.previous" },
  n = { "client.tab.next" },
  z = { "pane.zoom" },
  x = { "pane.close" },
  e = { "pane.balance" },
})

-- Scroll mode: prefix v, what's left of tmux's copy mode. Moves between command
-- prompts and pages; select text with the mouse.
rex.mode("scroll", { exclusive = true })
rex.bind("ctrl+space>v", "client.mode.enter", { name = "scroll" })
modal("scroll", {
  escape = { "client.mode.exit" },
  enter = { "client.mode.exit" },
  k = { "client.prompt.previous" },
  j = { "client.prompt.next" },
  u = { "client.scroll.page_up" },
  d = { "client.scroll.page_down" },
  f = { "client.find.open" },
  n = { "client.find.next" },
  ["shift+n"] = { "client.find.previous" },
})

-- Project picker in a floating pane, like sessionx on prefix o. See
-- ~/.local/bin/rex-dev.
rex.action({
  name = "dev_picker",
  title = "Open Project",
  run = function(ctx)
    rex.call("session.new_layer", {
      session_id = ctx.session_id,
      bounds = { 0.125, 0.075, 0.75, 0.85 },
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        label = "projects",
        options = { command = { os.getenv("HOME") .. "/.local/bin/rex-dev" } },
      }),
    })
  end,
})
