# Cheat sheet  (`<leader>` = Space · open with `Space k` · `q` closes)

## Instead of the file tree
| Keys | What |
|---|---|
| `Space Space` | Find file by name (project root) |
| `Space ,` | Switch between open buffers |
| `Space f r` | Recent files |
| `Space /` | Grep text across the project |
| `Space s w` | Grep the word under the cursor |
| `Space s s` / `Space s S` | Jump to symbol: this file / whole workspace |
| `Space s R` | Reopen the last picker where you left it |
| `Space f n` | New file (or `:e path/to/file.go`) |
| `Ctrl-v` / `Ctrl-s` (in a picker) | Open the result in a vertical / horizontal split |

## Harpoon (your 4–5 main files)
| Keys | What |
|---|---|
| `Space H` | Pin current file |
| `Space h` | Menu: reorder (`dd` + `p`) or remove pins |
| `Space 1` … `Space 5` | Jump to pinned file 1…5 |

## Moving around code
| Keys | What |
|---|---|
| `gd` / `gr` | Go to definition / list references |
| `gI` / `gy` | Go to implementation / type definition |
| `K` | Hover docs |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward (undo a `gd`) |
| `H` / `L` | Previous / next buffer |
| `s` + 2 chars | Flash: jump anywhere on screen |
| `]d` / `[d` | Next / previous diagnostic |
| `]h` / `[h` | Next / previous git change |

## Editing with the LSP
| Keys | What |
|---|---|
| `Space c a` | Code action (fill struct, add import, …) |
| `Space c r` | Rename symbol everywhere |
| `Space c f` | Format file |
| `Space x x` | All diagnostics (Trouble) |
| `Space s r` | Search & replace across files |

## Tests  (neotest)
| Keys | What |
|---|---|
| `Space t r` | Run the test under the cursor |
| `Space t t` | Run the whole file |
| `Space t T` | Run all test files |
| `Space t l` | Re-run the last test |
| `Space t o` | Show output of the test under cursor |
| `Space t s` | Summary tree of all tests |
| `Space t w` | Watch: re-run file on save |
| `Space t d` | Debug the nearest test |

## Debugging  (dap + delve)
| Keys | What |
|---|---|
| `Space d b` | Toggle breakpoint |
| `Space d B` | Conditional breakpoint |
| `Space d c` | Start / continue  (VS Code F5) |
| `Space d O` | Step over  (F10) |
| `Space d i` / `Space d o` | Step into / out  (F11 / Shift-F11) |
| `Space d C` | Run to cursor |
| `Space d e` | Evaluate expression under cursor |
| `Space d u` | Toggle the debugger UI |
| `Space d t` | Stop |

## Git
| Keys | What |
|---|---|
| `Space g g` | lazygit (`?` inside shows its keys) |
| `Space g b` | Blame current line |
| `Space g h s` / `Space g h r` | Stage / reset the hunk under cursor |
| `Space g h p` | Preview the hunk |

## Claude Code  (runs in tmux window 2)
| Keys | What |
|---|---|
| `Space a a` (visual) | Ask a **temporary** Claude in a side pane; it may edit. `/exit` closes it |
| `Space a s` (visual) | Send selection + question to the long-running Claude in window 2 |
| `Space a q` (visual) | Quick question: answer in a float, read-only (`q` closes) |
| `prefix →` / `prefix ←` | Jump into the side pane for a follow-up / back to nvim |
| `:w` / `:q` in a diff | Accept / reject Claude's proposed change |
| `/ide` in Claude | Reconnect to Neovim if it started first or nvim restarted |

## Buffers & windows
| Keys | What |
|---|---|
| `Space b d` / `Space b o` | Close buffer / close all others |
| `Space -` / `Space \|` | Split below / right |
| `Ctrl-h/j/k/l` | Move between splits |

## When you forget
| Keys | What |
|---|---|
| `Space` (wait) | which-key shows what comes next |
| `Space s k` | Search every keymap |
| `Space ?` | Keymaps for this buffer |

## tmux & shell
| Keys | What |
|---|---|
| `prefix o` | Session picker; a repo under ~/Projects opens as nvim + ai |
| `prefix p` / `prefix n` | Previous / next window |
| `prefix \` / `prefix -` | Split right / below (same folder) |
| `prefix z` | Zoom the current pane |
| `z name` | cd to a frequent folder (zoxide) · `zi` interactive |
| `Ctrl-R` / `Ctrl-T` | fzf: history / insert a file path |
