return {
  -- Motion plugins (NEW - from yetone, replaces some harpoon functionality)
  {
    "ggandor/flit.nvim",
    opts = { labeled_modes = "nx" },
    keys = function()
      ---@type LazyKeysSpec[]
      local ret = {}
      for _, key in ipairs { "f", "F", "t", "T" } do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "motion: leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "motion: leap backward to" },
      {
        "gA",
        'V<cmd>lua require("leap.treesitter").select()<cr>',
        mode = { "n", "x", "o" },
        desc = "motion: leap treesiter (linewise)",
      },
      {
        "ga",
        function()
          local sk = vim.deepcopy(require("leap").opts.special_keys)
          sk.next_target = vim.fn.flatten(vim.list_extend({ "a" }, { sk.next_target }))
          sk.prev_target = vim.fn.flatten(vim.list_extend({ "A" }, { sk.prev_target }))
          require("leap.treesitter").select { opts = { special_keys = sk } }
        end,
        mode = { "n", "x", "o" },
        desc = "motion: leap treesitter",
      },
      { "|", "V<cmd>lua Util.motion.leap_line_start()<cr>", mode = "o", desc = "motion: leap line start (linewise)" },
      {
        "|",
        function()
          if vim.fn.mode(1) ~= "V" then vim.cmd "normal! V" end
          Util.motion.leap_line_start()
        end,
        mode = "x",
        desc = "motion: leap line start",
      },
    },
    opts = {
      max_highlighted_traversal_targets = 15,
    },
    config = function(_, opts)
      local leap = require "leap"
      for key, val in pairs(opts) do
        leap.opts[key] = val
      end
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")
    end,
  },
  -- Search/replace in multiple files (NEW - from yetone)
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      headerMaxWidth = 50,
      windowCreationCommand = "botright vsplit",
    },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "n", "v" },
        desc = "search: open and replace",
      },
      {
        "<leader>sw",
        function()
          local grug = require "grug-far"
          grug.open {
            transient = true,
            prefills = { search = vim.fn.expand "<cword>" },
          }
        end,
        mode = { "n", "v" },
        desc = "search: open and replace (cursor word)",
      },
    },
  },
  { "folke/ts-comments.nvim", event = "LazyFile", opts = {} },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "conform.nvim", words = { "conform" } },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope" },
    event = "LazyFile",
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "todo: next" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "todo: previous" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    lazy = true,
    enabled = true,
    opts_extend = { "spec" },
    opts = {
      win = { border = "single" },
      spec = {
        { "<BS>", desc = "treesitter: decrement selection", mode = "x" },
        { "<c-space>", desc = "treesiter: increment selection", mode = { "x", "n" } },
        {
          mode = { "n", "v" },
          { "<leader>a", group = "avante", icon = { icon = " ", color = "cyan" } },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>h", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "dignostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function() return require("which-key.extras").expand.buf() end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function() return require("which-key.extras").expand.win() end,
          },
          { "gx", desc = "util: open with system app" },
        },
      },
      disable = { ft = { "minifiles" } },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "which-key: buffer keymaps",
      },
      {
        "<c-w><space>",
        function() require("which-key").show { keys = "<c-w>", loop = true } end,
        desc = "which-key: window hydra mode",
      },
    },
  },
  {
    "stevearc/quicker.nvim",
    event = "LazyFile",
    keys = {
      {
        "<leader>xx",
        function()
          if #vim.fn.getqflist() > 0 then
            require("quicker").toggle()
          else
            Util.warn "Quickfix list is empty"
          end
        end,
        mode = { "n", "v" },
        desc = "qf: toggle quickfix",
      },
      {
        "<leader>xl",
        function()
          if #vim.fn.getloclist(vim.api.nvim_get_current_win()) > 0 then
            require("quicker").toggle { loclist = true }
          else
            Util.warn "Location list is empty"
          end
        end,
        mode = { "n", "v" },
        desc = "qf: toggle loclist",
      },
    },
    opts = {
      opts = {
        buflisted = false,
        number = true,
        relativenumber = true,
        signcolumn = "auto",
        winfixheight = true,
        wrap = false,
      },
      on_qf = function(bufnr)
        Util.safe_keymap_set(
          "n",
          "<Leader>Q",
          function() require("quicker.context").refresh() end,
          { desc = "quickfix: refresh buffer", buffer = bufnr }
        )
      end,
      keys = {
        {
          ">",
          function() require("quicker").expand { before = 2, after = 2, add_to_existing = true } end,
          desc = "qf: expand context",
        },
        {
          "<",
          function() require("quicker").collapse() end,
          desc = "qf: collapse context",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    keys = {
      {
        "]h",
        function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            require("gitsigns.actions").nav_hunk "next"
          end
        end,
        desc = "git: next hunk",
      },
      {
        "[h",
        function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            require("gitsigns.actions").nav_hunk "prev"
          end
        end,
        desc = "git: prev hunk",
      },
      {
        "<leader>hb",
        function() require("gitsigns.actions").blame_line { full = true } end,
        desc = "git: blame line",
      },
      {
        "[H",
        function() require("gitsigns.actions").nav_hunk "first" end,
        desc = "git: first hunk",
      },
      {
        "]H",
        function() require("gitsigns.actions").nav_hunk "last" end,
        desc = "git: last hunk",
      },
      {
        "<leader>hp",
        function() require("gitsigns.actions").preview_hunk_inline() end,
        desc = "git: preview hunk inline",
      },
      {
        "<leader>hP",
        function() require("gitsigns.actions").preview_hunk() end,
        desc = "git: preview hunk",
      },
      { "<leader>hR", ":Gitsigns reset_buffer<CR>", desc = "git: reset buffer" },
      { "<leader>hS", ":Gitsigns stage_buffer<CR>", desc = "git: stage buffer" },
      { "<leader>hs", ":Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "git: stage hunk" },
      { "<leader>hr", ":Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "git: reset hunk" },
      { "<leader>hh", ":Gitsigns setqflist<CR>", mode = { "n", "v" }, desc = "git: set qflist" },
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "git: select hunk" },
    },
    opts = {
      numhl = true,
      attach_to_untracked = true,
      _new_sign_calc = true,
      _refresh_staged_on_update = true,
    },
  },
  -- Support for image pasting
  {
    "HakonHarnes/img-clip.nvim",
    event = "LazyFile",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = { insert_mode = true },
      },
    },
  },
  -- Keep existing plugins from your config
  -- Harpoon (from your original config)
  {
    "theprimeagen/harpoon",
    lazy = false,
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "harpoon: add file" })
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "harpoon: toggle menu" })
      vim.keymap.set("n", "<M-h>", function() ui.nav_file(1) end, { desc = "harpoon: file 1" })
      vim.keymap.set("n", "<M-t>", function() ui.nav_file(2) end, { desc = "harpoon: file 2" })
      vim.keymap.set("n", "<M-n>", function() ui.nav_file(3) end, { desc = "harpoon: file 3" })
      vim.keymap.set("n", "<M-s>", function() ui.nav_file(4) end, { desc = "harpoon: file 4" })
    end,
  },
  -- Undotree (from your original config)
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "undotree: toggle" },
    },
  },
  -- Fugitive (from your original config)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gs", vim.cmd.Git, desc = "git: fugitive status" },
    },
  },
  -- LazyGit (from your original config)
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gl", vim.cmd.LazyGit, desc = "git: open lazygit" },
    },
  },
  -- LeetCode (from your original config)
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = vim.fn.argv()[1] ~= "leetcode.nvim",
    opts = {
      arg = "leetcode.nvim",
      lang = "cpp",
      cn = { enabled = false, translator = true, translate_problems = true },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },
      plugins = { non_standalone = true },
      logging = true,
      cache = { update_interval = 60 * 60 * 24 * 7 },
      console = {
        open_on_runcode = true,
        dir = "row",
        size = { width = "90%", height = "75%" },
        result = { size = "60%" },
        testcase = { virt_text = true, size = "40%" },
      },
      description = { position = "left", width = "40%", show_stats = true },
      keys = {
        toggle = { "q" },
        confirm = { "<CR>" },
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
      image_support = false,
    },
  },
  -- Dressing (enhanced UI) from your original config
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  -- Auto pairs (replaces autoclose.nvim) - handled by mini.pairs
  { "m4xshen/autoclose.nvim", enabled = false },
  -- Copilot (from your original config)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true, auto_trigger = true },
        panel = { enabled = false },
      })
    end,
  },
  -- Supermaven (from your original config)
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
