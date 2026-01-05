return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-repeat",
  { "romainl/vim-cool", event = { "CursorMoved", "InsertEnter" } },
  { "folke/lazy.nvim", version = false },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    lazy = false,
    opts = {
      delete_to_trash = false,
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@return snacks.Config
    opts = function()
      return {
        toggle = { map = Util.safe_keymap_set },
        bigfile = { enabled = true, line_length = 1000 },
        notifier = { enabled = false },
        input = { enabled = true },
        image = { enabled = false, math = { enabled = false }, convert = { notify = false } },
        rename = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = false },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          _G.P = function(...)
            print(vim.inspect(...))
            return ...
          end
        end,
      })
    end,
  },
  -- Flexoki theme (from yetone)
  {
    "nuvic/flexoki-nvim",
    name = "flexoki",
    enabled = true,
    priority = 1000,
    ---@return Options
    opts = function()
      local palette = require "flexoki.palette"
      return {
        styles = {
          italic = true,
          transparency = true,  -- Enable transparent background
        },
        highlight_groups = {
          -- treesitter disabling italics for parameters
          -- because it is kinda annoying
          ["@variable"] = { fg = palette.text, italic = false },
          ["@parameter"] = { fg = palette.purple_two, italic = false },
          ["@variable.parameter"] = { fg = palette.purple_two, italic = false },
          -- normal colorscheme
          StatusLine = { fg = palette.orange_two, bg = palette.overlay },
          StatusLineNC = { bg = palette.overlay },
          QuickFixLine = { bg = palette.highlight_high },
          WinBar = { bg = palette.base },
          WinBarNC = { bg = palette.base },
          -- avante.nvim
          AvanteTitle = { bg = palette.red_two },
          AvanteReversedTitle = { fg = palette.red_two },
          AvanteSubtitle = { fg = palette.highlight_med, bg = palette.cyan_two },
          AvanteReversedSubtitle = { fg = palette.cyan_two },
          AvanteThirdTitle = { fg = palette.highlight_med, bg = palette.purple_two },
          AvanteReversedThirdTitle = { fg = palette.purple_two },
          AvanteConflictCurrent = { bg = palette.red_two },
          AvanteConflictIncoming = { bg = palette.green_two },
          -- mini.nvim
          MiniStatuslineModeNormal = { bg = palette.blue_two },
          MiniStatuslineModeVisual = { bg = palette.green_two },
          MiniStatuslineModeInsert = { bg = palette.orange_two },
          MiniStatuslineModeReplace = { bg = palette.red_two },
          MiniStatuslineModeCommand = { bg = palette.purple_two },
          MiniStatuslineModeOther = { bg = palette.purple_two },
          -- dropbar.nvim
          DropBarMenuCurrentContext = { bg = palette.base },
        },
      }
    end,
    config = function(_, opts)
      require("flexoki").setup(opts)
      vim.cmd "colorscheme flexoki"
    end,
  },
  -- Keep existing themes as alternatives
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        no_bold = true,
        no_italic = true,
        no_underline = true,
        integrations = {
          blink_cmp = { style = 'bordered' },
          snacks = { enabled = true },
          gitsigns = true,
          native_lsp = { enabled = true, inlay_hints = { background = true } },
          semantic_tokens = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
          mason = true,
        },
      })
    end,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "bright"
      vim.g.gruvbox_material_statusline_style = "mix"
      vim.g.gruvbox_material_cursor = "auto"
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      require('rose-pine').setup({
        disable_background = true,
        styles = { italics = false },
      })
    end
  },
  {
    'AlexvZyl/nordic.nvim',
    lazy = true,
    config = function()
      require('nordic').setup({
        bold_keywords = false,
        italic_comments = false,
        transparent = { bg = false, float = false },
        bright_border = false,
        reduced_blue = true,
        cursorline = { bold = false, bold_number = true, theme = 'dark', blend = 0.85 },
        telescope = { style = 'flat' },
        leap = { dim_backdrop = false },
      })
    end
  },
  { 'aliqyan-21/darkvoid.nvim', lazy = true },
  { 'adibhanna/forest-night.nvim', lazy = true },
  { 'blazkowolf/gruber-darker.nvim', lazy = true },
  { 'lunarvim/horizon.nvim', lazy = true },
  { 'erikbackman/brightburn.vim', lazy = true },
  { 'lifepillar/vim-solarized8', branch = 'neovim', lazy = true },
  { 'projekt0n/github-nvim-theme', lazy = true },
}
