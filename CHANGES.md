# Neovim Configuration Changes

This document describes all changes made during the migration from Packer to lazy.nvim and the adoption of features from the yetone configuration.

## Overview

- **Package Manager**: Packer → lazy.nvim
- **Theme**: Added flexoki-nvim as default (original themes still available)
- **Completion**: nvim-cmp → blink.cmp
- **File Explorer**: Added oil.nvim alongside netrw

## Structure Changes

### Old Structure
```
nvim/
├── init.lua (loaded lua/theman/)
├── lua/
│   └── theman/
│       ├── init.lua (autocommands)
│       ├── remap.lua (keymaps)
│       ├── set.lua (vim options)
│       └── packer.lua (plugin definitions)
├── after/plugin/ (plugin configs)
└── plugin/packer_compiled.lua
```

### New Structure
```
nvim/
├── init.lua (lazy.nvim bootstrap + globals)
├── plugin/
│   ├── options.lua (vim settings)
│   ├── keymap.lua (all keymappings)
│   └── auto.lua (autocommands)
├── lua/
│   ├── utils/ (utility modules)
│   └── plugins/
│       ├── init.lua (core plugins + themes)
│       ├── editor.lua (editor enhancements)
│       ├── completion.lua (blink.cmp)
│       ├── treesitter.lua
│       ├── mini.lua (mini.nvim suite + telescope + lualine)
│       ├── linting.lua (nvim-lint)
│       ├── xtras.lua (dynamic plugin loader)
│       ├── lsp/
│       │   ├── init.lua (lspconfig, mason, conform)
│       │   └── keymaps.lua
│       ├── lang/ (language-specific configs)
│       ├── formatters/ (formatter configs)
│       └── linters/ (linter configs)
```

---

## New Plugins

### File Explorer
| Plugin | Description | Key |
|--------|-------------|-----|
| **oil.nvim** | Edit filesystem like a buffer | `-` |

### Motion & Navigation
| Plugin | Description | Keys |
|--------|-------------|------|
| **leap.nvim** | Fast 2-char motion | `s`, `S`, `gs` |
| **flit.nvim** | Enhanced f/t motions | `f`, `F`, `t`, `T` |

### Search & Replace
| Plugin | Description | Keys |
|--------|-------------|------|
| **grug-far.nvim** | Search/replace across files | `<leader>sr`, `<leader>sw` |

### Completion
| Plugin | Description | Notes |
|--------|-------------|-------|
| **blink.cmp** | Fast completion engine | Replaces nvim-cmp |

### UI & Utilities
| Plugin | Description | Keys |
|--------|-------------|------|
| **which-key.nvim** | Keybinding popup helper | `<leader>?` |
| **todo-comments.nvim** | Highlight TODO/FIXME/etc | `]t`, `[t` |
| **snacks.nvim** | UI utilities | Buffer delete, etc. |
| **quicker.nvim** | Enhanced quickfix | `<leader>xx`, `<leader>xl` |

### mini.nvim Suite
| Module | Description | Keys/Usage |
|--------|-------------|------------|
| **mini.surround** | Add/change/delete surroundings | `gsa`, `gsd`, `gsr` |
| **mini.pairs** | Auto pairs | Automatic |
| **mini.ai** | Enhanced text objects | `a`, `i` + various |
| **mini.pick** | Fuzzy picker | Various `<leader>f*` |
| **mini.files** | File browser | `<leader>fm` |
| **mini.icons** | Icons | Automatic |
| **mini.diff** | Diff viewer | Various |

### Formatting & Linting
| Plugin | Description | Keys |
|--------|-------------|------|
| **conform.nvim** | Format on save | `<leader>cf` |
| **nvim-lint** | Async linting | Automatic |

---

## Preserved Keymaps (Original)

All your original keymaps have been preserved:

### Movement
| Key | Action |
|-----|--------|
| `<C-d>` | Half page down (centered) |
| `<C-u>` | Half page up (centered) |
| `n` / `N` | Search next/prev (centered) |
| `J` | Join lines (cursor stays) |

### Editing
| Key | Action |
|-----|--------|
| `J` / `K` (visual) | Move line down/up |
| `<leader>p` | Paste without register loss |
| `<leader>y` / `<leader>Y` | Yank to clipboard |
| `<leader>d` | Delete to black hole |
| `<leader>s` | Search & replace word under cursor |
| `<leader>x` | Make file executable |

### Navigation
| Key | Action |
|-----|--------|
| `<leader>pv` | Open netrw |
| `<C-f>` | Tmux sessionizer |
| `<leader>cn` / `<leader>cp` | Quickfix next/prev |
| `<leader>k` / `<leader>j` | Location list next/prev |

### LSP & Tools
| Key | Action |
|-----|--------|
| `<leader>zig` | Restart LSP |
| `<leader>u` | Toggle undotree |
| `<leader>gs` | Git fugitive status |
| `<leader>gl` | Open LazyGit |

### C++ Compilation
| Key | Action |
|-----|--------|
| `F8` | Compile and run with input/output files |
| `F9` | Compile only |

### Harpoon (MODIFIED)
| Old Key | New Key | Action |
|---------|---------|--------|
| `<C-h>` | `<M-h>` (Alt+h) | Jump to file 1 |
| `<C-t>` | `<M-t>` (Alt+t) | Jump to file 2 |
| `<C-n>` | `<M-n>` (Alt+n) | Jump to file 3 |
| `<C-s>` | `<M-s>` (Alt+s) | Jump to file 4 |
| `<leader>a` | `<leader>a` | Add file (unchanged) |
| `<C-e>` | `<C-e>` | Toggle menu (unchanged) |

> **Note**: Harpoon keys changed from Ctrl to Alt to avoid conflicts with window navigation.

---

## New Keymaps

### File Explorer
| Key | Action |
|-----|--------|
| `-` | Open oil.nvim (parent directory) |

### Motion (Leap/Flit)
| Key | Action |
|-----|--------|
| `s` | Leap forward |
| `S` | Leap backward |
| `gs` | Leap from window |
| `ga` | Leap treesitter select |
| `gA` | Leap treesitter select (linewise) |

### Window Navigation
| Key | Action |
|-----|--------|
| `<C-h>` | Focus left window |
| `<C-j>` | Focus down window |
| `<C-k>` | Focus up window |
| `<C-l>` | Focus right window |

### Window Management (LocalLeader = `,`)
| Key | Action |
|-----|--------|
| `,\|` | Maximize width |
| `,-` | Maximize height |
| `,0` | Equal window sizes |
| `,vs` | Vertical split |
| `,hs` | Horizontal split |
| `,sw` | Swap window position |
| `,[` / `,]` | Resize window |
| `,cd` | Change dir to current file |

### Buffer Management
| Key | Action |
|-----|--------|
| `<C-x>` | Delete buffer (snacks) |
| `<C-q>` | Delete buffer |
| `` <leader>` `` | Switch to alternate buffer |

### Terminal
| Key | Action |
|-----|--------|
| `<leader>st` | Open bottom terminal |
| `,st` | Open side terminal |
| `<C-w><C-q>` | Close terminal |
| `<C-w>` | Exit terminal mode |
| `<Esc><Esc>` | Exit terminal mode |

### Search & Replace
| Key | Action |
|-----|--------|
| `<leader>sr` | Open grug-far (search & replace) |
| `<leader>sw` | Search & replace cursor word |

### Git (Gitsigns)
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/prev hunk |
| `]H` / `[H` | Last/first hunk |
| `<leader>hb` | Blame line |
| `<leader>hp` | Preview hunk inline |
| `<leader>hP` | Preview hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `ih` | Select hunk (text object) |

### Quickfix (Quicker)
| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle quickfix |
| `<leader>xl` | Toggle location list |

### Comments
| Key | Action |
|-----|--------|
| `<leader>v` | Toggle comment (normal/visual) |

### TODO Comments
| Key | Action |
|-----|--------|
| `]t` / `[t` | Next/prev TODO comment |

### Misc
| Key | Action |
|-----|--------|
| `\` | Clear search highlight |
| `;` | Enter command mode |
| `jj` / `jk` | Escape (insert mode) |
| `<M-BS>` | Delete word (insert mode) |
| `<leader>?` | Show which-key |
| `,p` | Show Lazy package manager |
| `gl` | Open URL under cursor |
| `<leader>ui` | Inspect position |
| `<leader>uI` | Inspect treesitter tree |
| `<leader>qq` | Write and quit all |

### LSP Keymaps
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format document |
| `<leader>cF` | Format selection |
| `[d` / `]d` | Prev/next diagnostic |
| `[e` / `]e` | Prev/next error |
| `[w` / `]w` | Prev/next warning |
| `<leader>cd` | Line diagnostics |

### Mini.surround
| Key | Action |
|-----|--------|
| `gsa` | Add surrounding |
| `gsd` | Delete surrounding |
| `gsr` | Replace surrounding |
| `gsf` | Find surrounding (right) |
| `gsF` | Find surrounding (left) |
| `gsh` | Highlight surrounding |
| `gsn` | Update `n_lines` |

---

## Themes

### Default Theme
- **flexoki-nvim** - A warm, balanced colorscheme

### Available Alternative Themes (Lazy-loaded)
All your original themes are still available:
- catppuccin
- gruvbox-material
- rose-pine
- nordic
- onedark
- dracula
- vscode
- cyberdream
- tokyonight

To switch themes:
```vim
:colorscheme catppuccin
:colorscheme gruvbox-material
" etc.
```

---

## Language Support

The following language modules are enabled by default in `init.lua`:
- clangd (C/C++)
- json
- go
- rust
- yaml
- python
- markdown
- typescript

Additional language modules available in `lua/plugins/lang/`:
- nix
- ocaml
- sql
- tailwind
- zig

To enable additional languages, add them to `vim.g.extra_plugins` in `init.lua`:
```lua
vim.g.extra_plugins = {
  -- ... existing entries
  "plugins.lang.nix",
  "plugins.lang.zig",
}
```

---

## Autocommands

### Preserved (from original)
- Highlight on yank (40ms timeout)
- Auto trim trailing whitespace on save
- Netrw settings (no banner, 25% width)

### New Autocommands
- Close special buffers with `q` (help, quickfix, fugitive, etc.)
- Go to last cursor position when opening file
- Auto-resize splits on window resize
- Spell checking for text/markdown/gitcommit files
- Auto-create parent directories on save
- Auto-reload files changed outside vim
- Toggle relative numbers based on mode/focus
- Terminal auto insert mode

---

## Migration Notes

### Files to Remove (Optional)
The following old files are no longer needed:
```
lua/theman/          # Old config modules
after/plugin/        # Old plugin configs
plugin/packer_compiled.lua
```

### First Run
On first run, lazy.nvim will:
1. Clone itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Install all plugins
3. Compile plugin specs

### Troubleshooting
If you encounter issues:
1. Run `:checkhealth` to diagnose problems
2. Run `:Lazy` to check plugin status
3. Clear lazy cache: `rm -rf ~/.local/share/nvim/lazy`
4. Clear state: `rm -rf ~/.local/state/nvim`

---

## Quick Reference Card

```
LEADER: <Space>    LOCALLEADER: ,

File Explorer:     -           (oil.nvim)
                   <leader>pv  (netrw)
                   <leader>fm  (mini.files)

Motion:            s/S         (leap forward/back)
                   gs          (leap from window)

Harpoon:           <leader>a   (add file)
                   <C-e>       (toggle menu)
                   <M-h/t/n/s> (jump to file 1-4)

Git:               <leader>gs  (fugitive)
                   <leader>gl  (lazygit)
                   <leader>h*  (gitsigns)

Search/Replace:    <leader>sr  (grug-far)
                   <leader>s   (word under cursor)

LSP:               gd/gr/gI    (go to def/ref/impl)
                   K           (hover)
                   <leader>ca  (code action)
                   <leader>cr  (rename)

Window Nav:        <C-h/j/k/l> (focus windows)
Split:             ,vs / ,hs   (vertical/horizontal)

Terminal:          <leader>st  (bottom)
                   ,st         (side)

Quickfix:          <leader>xx  (toggle)
                   <leader>cn/cp (next/prev)

Package Manager:   ,p          (lazy.nvim)
```
