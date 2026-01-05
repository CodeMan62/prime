-- Autocommands for nvim config
-- Combines original ThePrimeagen-style autocommands with yetone improvements

-- ============================================================================
-- Close some filetypes with <q> and make them unlisted
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "filetype_q",
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "fugitive",
    "fugitiveblame",
    "oil",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd "close"
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "buffer: delete",
      })
    end)
  end,
})

-- ============================================================================
-- Go to last location when opening a buffer
-- ============================================================================
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].simple_last_loc then return end
    vim.b[buf].simple_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- ============================================================================
-- Make man pages unlisted
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "man_unlisted",
  pattern = { "man" },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- ============================================================================
-- Resize splits when window is resized
-- ============================================================================
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup "resized",
  callback = function()
    local current = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext  " .. current)
  end,
})

-- ============================================================================
-- Enable spell checking for certain filetypes
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "spell",
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function() vim.opt_local.spell = true end,
})

-- ============================================================================
-- Check if file changed when gaining focus
-- ============================================================================
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
  end,
})

-- ============================================================================
-- Auto create directory when saving a file
-- ============================================================================
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ============================================================================
-- Highlight on yank (original from ThePrimeagen)
-- ============================================================================
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 40,
    }
  end,
})

-- ============================================================================
-- Auto trim trailing whitespace (original from ThePrimeagen, improved)
-- ============================================================================
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "trim_whitespace",
  pattern = "*",
  callback = function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
})

-- ============================================================================
-- Toggle relative numbers based on focus/mode
-- ============================================================================
local numtoggle = augroup "numtoggle"

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = numtoggle,
  callback = function()
    if vim.wo.number and vim.fn.mode() ~= "i" then vim.wo.relativenumber = true end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = numtoggle,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})

-- ============================================================================
-- Terminal settings
-- ============================================================================
local term_group = augroup "terminal_io"

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = numtoggle,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Auto enter insert mode in terminal
vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen", "TermEnter" }, {
  group = term_group,
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].buftype == "terminal" then
        vim.cmd.startinsert()
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "TermLeave" }, {
  group = term_group,
  callback = function(ev)
    if vim.fn.mode() == "t" and vim.bo[ev.buf].buftype == "terminal" then
      vim.cmd.stopinsert()
    end
  end,
})

-- ============================================================================
-- Highlight URLs (if enabled in init.lua)
-- ============================================================================
if vim.g.enable_highlighturl then
  local highlighturl_group = augroup "highlighturl"
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = highlighturl_group,
    callback = function() hi("HighlightURL", { default = true, underline = true }) end,
  })
  vim.api.nvim_create_autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
    group = highlighturl_group,
    callback = function(args)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == args.buf and not vim.w[win].highlighturl_enabled then
          Util.set_url_match(win)
        end
      end
    end,
  })
end

-- ============================================================================
-- Netrw settings (original from ThePrimeagen)
-- ============================================================================
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
