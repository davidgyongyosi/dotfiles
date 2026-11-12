-- Rex keys, for a Totem and a MacBook keyboard, both on macOS's Hungarian layout.
--
-- Two layers:
--   * Cmd+letter does things: switching, splitting, finding, the app itself.
--     Each is one chord. On the Totem, hold cmd on the opposite hand from the
--     letter: D for right-hand letters, K for left-hand ones.
--   * Layout mode arranges things: panes, tabs and floating panes, with tmux's
--     keys. ctrl+space enters it for one key, like tmux's prefix; cmd+r enters
--     it until escape, for several moves in a row.
-- Rex's own defaults stay as they are: cmd+t, cmd+w, cmd+k, cmd+f, cmd+c,
-- cmd+v, cmd+0, cmd+-, and so on.
--
-- How Rex matches a key: by the character the key types without shift, on the
-- active layout. So "z" is the key that types z (the Y key cap), and "-" is the
-- key that types - (the / key cap). A name for a character that needs Option or
-- shift on Hungarian never fires: [ ] { } \ / = ; ' and 0. Hence:
--   * Letters only, plus "," "." "-", which type themselves on Hungarian.
--   * No alt bindings: Option types @ { [ ] } \ and ~ on Hungarian.
--   * No ctrl bindings other than ctrl+space: Neovim owns those.
--   * No cmd+digit or cmd+arrow. On the Totem those keys are on the NAV layer,
--     which takes over the cmd key. Digits and arrows are in layout mode.

local function mode(name, keys)
  rex.mode(name, { exclusive = true })
  for key, action in pairs(keys) do
    rex.bind(name .. "/" .. key, action[1], action[2])
  end
end

-- Cmd: move around
rex.bind("cmd+u", "client.tab.previous")
rex.bind("cmd+i", "client.tab.next")
rex.bind("cmd+shift+u", "session.previous")
rex.bind("cmd+shift+i", "session.next")
rex.bind("cmd+j", "pane.focus_previous")
rex.bind("cmd+l", "pane.focus_next")
rex.bind("cmd+o", "dev_picker")
rex.bind("cmd+shift+o", "pane.go_to")
rex.bind("cmd+shift+a", "pane.view_activity")

-- Cmd: shape the current tab
rex.bind("cmd+d", "pane.split", { direction = "right" })
rex.bind("cmd+shift+d", "pane.split", { direction = "down" })
rex.bind("cmd+e", "pane.zoom")
rex.bind("cmd+g", "pane.new_floating")
rex.bind("cmd+r", "client.mode.enter", { name = "layout" })
rex.bind("cmd+s", "client.mode.enter", { name = "scroll" })

-- Cmd: the app
rex.bind("cmd+p", "client.palette.toggle")
rex.bind("cmd+b", "client.sidebar.toggle")
rex.bind("cmd+y", "client.quick_look")
rex.bind("cmd+shift+r", "client.config.reload")
rex.bind("cmd+shift+7", "client.font.increase") -- "=" is shift+7 on Hungarian

-- Layout mode. Escape leaves it; on the Totem that's the tap on the ctrl pinky.
rex.bind("ctrl+space", "client.mode.enter", { name = "layout", once = true })
local layout = {
  escape = { "client.mode.exit" },
  enter = { "client.mode.exit" },
  ["ctrl+space"] = { "pane.send_key", { key = "ctrl+space" } },

  -- Panes: hjkl focus, HJKL resize, arrows move
  h = { "pane.focus", { direction = "left" } },
  j = { "pane.focus", { direction = "down" } },
  k = { "pane.focus", { direction = "up" } },
  l = { "pane.focus", { direction = "right" } },
  ["shift+h"] = { "pane.resize", { direction = "left" } },
  ["shift+j"] = { "pane.resize", { direction = "down" } },
  ["shift+k"] = { "pane.resize", { direction = "up" } },
  ["shift+l"] = { "pane.resize", { direction = "right" } },
  left = { "pane.move", { direction = "left" } },
  down = { "pane.move", { direction = "down" } },
  up = { "pane.move", { direction = "up" } },
  right = { "pane.move", { direction = "right" } },
  d = { "pane.split", { direction = "right" } },
  ["shift+d"] = { "pane.split", { direction = "down" } },
  ["-"] = { "pane.split", { direction = "down" } },
  ["shift+5"] = { "pane.split", { direction = "right" } }, -- tmux's %
  z = { "pane.zoom" },
  e = { "pane.balance" },
  x = { "pane.close" },
  ["shift+x"] = { "pane.close_others" },
  ["."] = { "pane.rename" },

  -- Floating panes
  g = { "pane.new_floating" },
  f = { "pane.float" },
  m = { "pane.minimize_all_floating" },

  -- Tabs
  c = { "client.tab.new" },
  p = { "client.tab.previous" },
  n = { "client.tab.next" },
  ["shift+p"] = { "client.tab.move.backward" },
  ["shift+n"] = { "client.tab.move.forward" },
  t = { "pane.move_to_new_tab" },
  ["shift+t"] = { "pane.move_to_tab" },
  [","] = { "client.tab.rename" },
  ["shift+4"] = { "session.rename" }, -- tmux's $
}
for i = 1, 9 do
  layout[tostring(i)] = { "client.tab.goto", { index = i } }
end
mode("layout", layout)

-- Scroll mode: what's left of tmux's copy mode. Select text with the mouse.
mode("scroll", {
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

-- Project picker (cmd+o) in a floating pane. See ~/.local/bin/rex-dev.
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
