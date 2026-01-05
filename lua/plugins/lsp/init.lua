return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    cmd = "ConformInfo",
    enabled = true,
    dependencies = { "mason.nvim" },
    init = function()
      Util.on_very_lazy(function()
        Util.format.register {
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf) require("conform").format { bufnr = buf } end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            return vim.tbl_map(function(v) return v.name end, ret)
          end,
        }
      end)
    end,
    keys = {
      {
        "<leader>cF",
        function() require("conform").format { formatters = { "injected" }, timeout_ms = 3000 } end,
        mode = { "n", "v" },
        desc = "format: injected langs",
      },
    },
    opts_extend = { "formatters" },
    opts = {
      default_format_opts = { timeout_ms = 3000 },
      formatters_by_ft = {
        lua = { "stylua" },
        toml = { "taplo" },
        proto = { "buf", "protolint" },
        zsh = { "beautysh", fallback = true },
        sh = { "shfmt" },
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
      formatters = {
        injected = {
          options = { ignore_errors = true },
          lang_to_ext = {
            bash = "sh",
            c_sharp = "cs",
            javascript = "js",
            latex = "tex",
            markdown = "md",
            python = "py",
            ruby = "rb",
            rust = "rs",
            typescript = "ts",
          },
        },
        beautysh = { prepend_args = { "-i", "2" } },
        taplo = { append_args = { "-c", "align_entries=false" } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    version = false,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = { "stylua", "shfmt", "beautysh", "selene", "hadolint", "ast-grep", "typos" },
      ui = { backdrop = 100 },
      max_concurrent_installers = 15,
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
    opts = {
      diagnostics = {
        severity_sort = true,
        underline = false,
        update_in_insert = false,
        virtual_text = false,
        float = {
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          focusable = false,
          focus = false,
          format = function(diagnostic) return string.format("%s (%s)", diagnostic.message, diagnostic.source) end,
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✖",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "●",
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue", "typescriptreact", "typescript", "javascript", "python" },
      },
      codelens = { enabled = false },
      document_highlight = { enabled = true },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = { dynamicRegistration = false },
          fileOperations = { didRename = true, willRename = true },
        },
        textDocument = {
          completion = {
            snippetSupport = true,
            resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
            completionItem = {
              documentationFormat = { "markdown", "plaintext" },
              snippetSupport = true,
              preselectSupport = true,
              insertReplaceSupport = true,
              labelDetailsSupport = true,
              deprecatedSupport = true,
              commitCharactersSupport = true,
              tagSupport = { valueSet = { 1 } },
              resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
            },
          },
        },
      },
      servers = {
        bashls = {},
        rust_analyzer = {},
        eslint = {},
        clangd = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT", special = { reload = "require" } },
              library = { vim.env.VIMRUNTIME },
              telemetry = { enable = false },
              semantic = { enable = true },
              completion = { workspaceWord = true, callSnippet = "Replace" },
              hover = { expandAlias = false },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = false,
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = { privateName = { "^_" } },
              type = { castNumberToInteger = true },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = { strong = "Warning", strict = "Warning" },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = true,
                defaultConfig = { indent_style = "space", indent_size = "2", continuation_indent_size = "2" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      Util.format.register(Util.lsp.formatter())
      Util.lsp.setup()

      if opts.inlay_hints.enabled then
        Util.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      if opts.codelens.enabled and vim.lsp.codelens then
        Util.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        Util.has "blink.cmp" and require("blink.cmp").get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local have_mlsp, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mlsp then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
      end

      local function configure(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          flags = { debounce_text_changes = 300 },
        }, servers[server] or {})

        if server_opts.enabled == false then return end

        if opts.setup and opts.setup[server] then
          if opts.setup[server](server, server_opts) then return end
        elseif opts.setup and opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then return end
        end

        vim.lsp.config(server, server_opts)

        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          vim.lsp.enable(server)
          return true
        end
        return false
      end

      local ensure_installed = {}
      local exclude_automatic_enable = {}

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            if configure(server) then
              exclude_automatic_enable[#exclude_automatic_enable + 1] = server
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mlsp then
        mlsp.setup {
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            Util.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          automatic_enable = { exclude = exclude_automatic_enable },
        }
      end
    end,
  },
}
