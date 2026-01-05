---@param mode string|string[]
---@param lhs string
---@param rhs string|(fun(...): any)
---@param opts? vim.keymap.set.LazyOpts
local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Clear leader space
map({ "n", "x" }, " ", "", { noremap = true })

-- ============================================================================
-- YOUR ORIGINAL KEYMAPS (PRESERVED)
-- ============================================================================

-- File explorer (your original - kept alongside oil.nvim)
map("n", "<leader>pv", vim.cmd.Ex, { desc = "netrw: open explorer" })

-- Visual mode line movement (your original)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "edit: Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "edit: Move line up" })

-- Join lines keeping cursor (your original)
map("n", "J", "mzJ`z", { desc = "edit: Join next line" })

-- Half page navigation centered (your original)
map("n", "<C-d>", "<C-d>zz", { desc = "nav: Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "nav: Half page up" })

-- Search navigation centered (your original)
map("n", "n", "nzzzv", { desc = "search: next result centered" })
map("n", "N", "Nzzzv", { desc = "search: prev result centered" })

-- LSP restart (your original)
map("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "lsp: restart" })

-- Paste without losing register (your original - greatest remap ever)
map("x", "<leader>p", [["_dP]], { desc = "edit: paste without register loss" })

-- Clipboard operations (your original)
map({"n", "v"}, "<leader>y", [["+y]], { desc = "edit: yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "edit: yank line to clipboard" })

-- Delete to black hole (your original)
map({"n", "v"}, "<leader>d", [["_d]], { desc = "edit: delete to black hole" })

-- Escape alternatives (your original)
map("i", "<C-c>", "<Esc>", { desc = "normal: escape" })

-- Disable Ex mode (your original)
map("n", "Q", "<nop>", { desc = "disabled" })

-- Tmux sessionizer (your original)
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "tmux: sessionizer" })

-- Quickfix navigation (your original)
-- Note: <C-k> and <C-j> conflict with window nav, using original behavior
map("n", "<leader>cn", "<cmd>cnext<CR>zz", { desc = "quickfix: next" })
map("n", "<leader>cp", "<cmd>cprev<CR>zz", { desc = "quickfix: prev" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "loclist: next" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "loclist: prev" })

-- Search and replace word under cursor (your original)
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "edit: search & replace word" })

-- Make file executable (your original)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "file: make executable" })

-- Disable arrow keys (your original)
map("n", '<up>', '<nop>')
map("n", '<down>', '<nop>')
map("i", '<down>', '<nop>')
map("i", '<up>', '<nop>')
map("i", '<left>', '<nop>')
map("i", '<right>', '<nop>')

-- Go error handling snippet (your original)
map("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "go: insert error handling" })

-- Source file (your original)
map("n", "<leader><leader>", function() vim.cmd("so") end, { desc = "source: current file" })

-- C++ compilation (your original)
map('n', '<F8>', ':w<CR>:!g++ -std=c++17 -O2 -Wall % -o %:r && ./%:r < input.txt > output.txt<CR>', { desc = 'cpp: compile and run' })
map('n', '<F9>', ':w<CR>:!g++ -std=c++17 -O2 -Wall % -o %:r<CR>', { desc = 'cpp: compile only' })

-- ============================================================================
-- NEW KEYMAPS FROM YETONE
-- ============================================================================

-- Terminal (NEW)
map("n", "<leader>st", function() Util.terminal.bottom(nil, { height = 10, startinsert = true }) end, { desc = "terminal: bottom" })
map("n", "<LocalLeader>st", function() Util.terminal.side(nil, { startinsert = true }) end, { desc = "terminal: side" })
map("t", "<C-w><C-q>", "<C-\\><C-n><C-w>q", { desc = "terminal: close" })
map("t", "<C-w>", "<C-\\><C-n>", { desc = "terminal: normal mode" })
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "terminal: enter normal mode" })
map("t", "<C-w>h", "<cmd>wincmd h<cr>", { desc = "terminal: go to left window" })
map("t", "<C-w>j", "<cmd>wincmd j<cr>", { desc = "terminal: go to lower window" })
map("t", "<C-w>k", "<cmd>wincmd k<cr>", { desc = "terminal: go to upper window" })
map("t", "<C-w>l", "<cmd>wincmd l<cr>", { desc = "terminal: go to right window" })

-- Buffer management (NEW)
map("n", "<C-x>", function() Snacks.bufdelete() end, { desc = "buffer: delete" })
map("n", "<C-q>", "<cmd>:bd<cr>", { desc = "buffer: delete" })
map("n", "<Leader>`", "<cmd>e #<cr>", { desc = "buffer: switch to other" })

-- Insert mode helpers (NEW)
map("i", "<M-BS>", "<C-W>", { desc = "insert: delete word", remap = false })
map("i", "jj", "<Esc>", { desc = "normal: escape" })
map("i", "jk", "<Esc>", { desc = "normal: escape" })

-- Comments (NEW)
map("n", "<Leader>v", "gcc", { desc = "comment: visual line", remap = true })
map("x", "<Leader>v", "gc", { desc = "comment: visual line", remap = true })

-- Editing helpers (NEW)
map("n", "<leader><leader>a", "<CMD>normal za<CR>", { desc = "edit: Toggle code fold" })
map("n", "Y", "y$", { desc = "edit: Yank text to EOL" })
map("n", "D", "d$", { desc = "edit: Delete text to EOL" })
map("n", "<leader><leader>l", ":lua ", { noremap = true, silent = true, desc = "cmdline: enter lua command" })
map("n", "<LocalLeader>g", ":grep ", { noremap = false, desc = "edit: grep pattern" })
map("n", "<LocalLeader>l", ":lgrep ", { noremap = false, desc = "edit: grep pattern (window)" })
map("n", "\\", ":let @/=''<CR>:noh<CR>", { desc = "window: Clean highlight" })

-- URL handling (NEW)
map("n", "gl", function()
  local url = Util.url_under_cursor()
  if not url then
    Util.warn "open-url: no link under cursor"
    return
  end
  Util.open_url(url)
end, { desc = "util: open link under cursor" })

-- Command mode (NEW)
map("n", ";", ":", { silent = false, desc = "command: Enter command mode" })

-- Visual indentation (NEW)
map("v", "<", "<gv", { desc = "edit: Decrease indent" })
map("v", ">", ">gv", { desc = "edit: Increase indent" })

-- Sudo save (NEW)
map("c", "W!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!", { desc = "edit: Save file using sudo" })

-- Window navigation (NEW - using standard vim keys)
map("n", "<C-h>", "<C-w>h", { desc = "window: Focus left" })
map("n", "<C-l>", "<C-w>l", { desc = "window: Focus right" })
map("n", "<C-j>", "<C-w>j", { desc = "window: Focus down" })
map("n", "<C-k>", "<C-w>k", { desc = "window: Focus up" })

-- Window management (NEW)
map("n", "<LocalLeader>|", "<C-w>|", { desc = "window: Maxout width" })
map("n", "<LocalLeader>-", "<C-w>_", { desc = "window: Maxout height" })
map("n", "<LocalLeader>0", "<C-w>=", { desc = "window: Equal size" })
map("n", "<Leader>qq", "<cmd>wqa!<cr>", { desc = "editor: write quit all" })
map("n", "<LocalLeader>sw", "<C-w>r", { desc = "window: swap position" })
map("n", "<LocalLeader>vs", "<C-w>v", { desc = "edit: split window vertically" })
map("n", "<LocalLeader>hs", "<C-w>s", { desc = "edit: split window horizontally" })
map("n", "<LocalLeader>cd", ":lcd %:p:h<cr>", { desc = "misc: change directory to current file" })
map("n", "<LocalLeader>]", "<cmd>vertical resize -5<cr>", { desc = "windows: resize right" })
map("n", "<LocalLeader>[", "<cmd>vertical resize +5<cr>", { desc = "windows: resize left" })
map("n", "<leader><leader>b", "<cmd>wincmd =<cr>", { desc = "windows: balance" })

-- Better n/N (NEW - from vim-galore)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "search: next" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "search: next" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "search: next" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "search: prev" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "search: prev" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "search: prev" })

-- Inspect (NEW)
map("n", "<leader>ui", vim.show_pos, { desc = "inspect: position" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "inspect: tree" })

-- Add undo break-points (NEW)
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Lazy plugin manager (NEW)
map("n", "<LocalLeader>p", "<cmd>Lazy<cr>", { desc = "package: show manager" })

-- Oil.nvim file explorer (NEW)
map("n", "-", "<CMD>Oil<CR>", { desc = "fs: open parent directory" })
