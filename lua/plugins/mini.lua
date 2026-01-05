---@class MiniFilesBufferCreateData
---@field buf_id integer

---@class MiniFilesBufferCreate: vim.api.create_autocmd.callback.args
---@field data MiniFilesBufferCreateData

---@class MiniPickOpts: lazyvim.util.pick.Opts
---@field tool? string
---@field source? table<['cwd'] | string, any>

Util.pick.register {
  name = "mini.pick",
  commands = {
    files = "files",
    live_grep = "grep_live",
  },
  ---@param builtin string
  ---@param opts? MiniPickOpts
  open = function(builtin, opts)
    local extras = require "mini.extra"
    opts = opts or {}
    if opts.tool ~= nil then
      opts.source = vim.tbl_deep_extend("force", opts.source or {}, { cwd = opts.cwd })
      opts.cwd = nil
    end
    if extras.pickers[builtin] then
      extras.pickers[builtin](opts)
    else
      require("mini.pick").builtin[builtin](opts)
    end
  end,
}

return {
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "LazyFile",
    ---@class MiniOpts: table<string, MiniPluginOpts>
    opts = {
      extra = {},
      align = { mappings = { start = "<leader>ga", start_with_preview = "<leader>gA" } },
      pick = {
        options = { use_cache = true },
        window = {
          prompt_prefix = "󰄾 ",
          config = function()
            local height = math.floor(0.618 * vim.o.lines)
            local width = math.floor(0.618 * vim.o.columns)
            return {
              anchor = "NW",
              height = height,
              width = width,
              row = 1 + math.floor(0.21 * (vim.o.lines + height)),
              col = math.floor(0.5 * (vim.o.columns - width)),
            }
          end,
        },
      },
      bracketed = { window = { suffix = "" }, treesitter = { suffix = "" } },
      files = {
        windows = {
          preview = false,
          width_focus = 30,
          width_nofocus = 30,
          width_preview = math.floor(0.45 * vim.o.columns),
          max_number = 3,
        },
        mappings = { synchronize = "<leader>" },
      },
      surround = {
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      },
      pairs = {
        modes = { insert = true, command = true, terminal = false },
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        skip_ts = { "string" },
        skip_unbalanced = true,
        markdown = true,
        filetypes = { "lua", "python" },
      },
      diff = {
        view = {
          style = "sign",
          signs = { add = "▎", change = "▎", delete = "" },
        },
        mappings = {
          apply = "",
          reset = "",
          textobject = "",
          goto_first = "",
          goto_prev = "",
          goto_next = "",
          goto_last = "",
        },
      },
      statusline = {
        enabled = false,
        set_vim_settings = false,
      },
      indentscope = { enabled = false, symbol = "│", options = { try_as_border = true } },
      icons = {
        file = {
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          [".gitignore"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
          [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
          [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
          [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
          ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
          ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
          ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
          [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
          ["*.py"] = { glyph = "󰌠", hl = "MiniIconsYellow" },
        },
        filetype = {
          dotenv = { glyph = "", hl = "MiniIconsYellow" },
          gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
        },
        lsp = {
          supermaven = { glyph = "", hl = "MiniIconsOrange" },
          copilot = { glyph = "", hl = "MiniIconsOrange" },
          namespace = { glyph = "󰅪", hl = "MiniIconsRed" },
          null = { glyph = "NULL", hl = "MiniIconGrey" },
          snippet = { glyph = "", hl = "MiniIconsYellow" },
          struct = { glyph = "", hl = "MiniIconsRed" },
          event = { glyph = "", hl = "MiniIconsYellow" },
          operator = { glyph = "", hl = "MiniIconsGrey" },
          typeparameter = { glyph = "", hl = "MiniIconsBlue" },
        },
      },
      ai = function()
        local ai = require "mini.ai"
        local extra = require "mini.extra"
        return {
          n_lines = 500,
          custom_textobjects = {
            o = ai.gen_spec.treesitter {
              a = { "@block.outer", "@conditional.outer", "@loop.outer" },
              i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            },
            f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
            c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
            d = { "%f[%d]%d+" },
            e = {
              { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
              "^().*()$",
            },
            i = extra.gen_ai_spec.indent(),
            g = extra.gen_ai_spec.buffer(),
            u = ai.gen_spec.function_call(),
            U = ai.gen_spec.function_call { name_pattern = "[%w_]" },
          },
        }
      end,
    },
    specs = { { "nvim-tree/nvim-web-devicons", enabled = false, optional = true } },
    keys = {
      -- mini.pick
      {
        "<Leader>f",
        Util.pick("files", { tool = "git" }),
        desc = "mini.pick: open (git root)",
      },
      {
        "<LocalLeader>f",
        Util.pick "oldfiles",
        desc = "mini.pick: oldfiles",
      },
      {
        "<LocalLeader>w",
        Util.pick "live_grep",
        desc = "mini.pick: grep word",
      },
      {
        "<Leader>/",
        '<CMD>:Pick grep pattern="<cword>"<CR>',
        desc = "mini.pick: grep word",
      },
      -- mini.files
      {
        "<LocalLeader>/",
        function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
        desc = "mini.files: open (directory of current file)",
      },
      {
        "<LocalLeader>.",
        function() require("mini.files").open(Util.root.git(), true) end,
        desc = "mini.files: open (working root)",
      },
      -- mini.diff
      {
        "<leader>gd",
        function() require("mini.diff").toggle_overlay(0) end,
        desc = "git: toggle diff overlay",
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "Trouble", "alpha", "dashboard", "fzf", "help", "lazy", "mason",
          "neo-tree", "notify", "snacks_dashboard", "snacks_notif",
          "snacks_terminal", "snacks_win", "toggleterm", "trouble",
        },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function(data) vim.b[data.buf].miniindentscope_disable = true end,
      })
    end,
    config = function(_, opts)
      vim.iter(opts):each(function(module, _opts)
        local config = type(_opts) == "function" and _opts() or _opts
        if config.enabled == false then return end
        config.enabled = nil
        if Util.mini[module] ~= nil then
          Util.mini[module](config)
        else
          require("mini." .. module).setup(config)
        end
      end)
    end,
  },
  -- Keep telescope as an alternative (from original config)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "telescope: find files" },
      { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "telescope: git files" },
      {
        "<leader>ps",
        function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end,
        desc = "telescope: grep string",
      },
    },
  },
  -- Lualine (from original config)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = { statusline = {}, winbar = {} },
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
    },
  },
  -- Buffer line (from original config)
  { "bling/vim-bufferline", event = "VeryLazy" },
}
