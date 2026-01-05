-- Vim options configuration
-- Preserves your original settings while adding yetone improvements

local wo = vim.wo
wo.scrolloff = 8  -- Keep from your original config (was 2 in yetone)
wo.sidescrolloff = 5
wo.wrap = false  -- Keep from your original config (no wrap)
wo.cursorline = false  -- Keep from your original config
wo.cursorcolumn = false

local o = vim.o
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
o.confirm = true
o.winminwidth = 3
o.termguicolors = true

o.writebackup = false
o.autowrite = true
o.undofile = true
o.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- Keep your original undodir
o.breakindent = true
o.breakindentopt = "shift:2,min:20"
o.pumheight = 20
o.expandtab = true
o.mouse = "a"
o.number = true
o.swapfile = false
o.backup = false  -- Keep from your original config
o.undolevels = 9999
o.showtabline = 0
o.smoothscroll = true

o.shortmess = "ltTaoOIcF"
o.formatexpr = "v:lua.require'utils'.format.formatexpr()"
o.completeopt = "menu,menuone,noinsert,fuzzy,popup"
o.formatoptions = "tcqjron"
o.diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience"

o.smartcase = true
o.smartindent = true
o.ignorecase = true
o.infercase = true
o.hlsearch = false  -- Keep from your original config (no highlight after search)
o.incsearch = true  -- Keep from your original config

o.linebreak = true
o.jumpoptions = "stack"
o.list = true
o.listchars = "tab:»·,lead:·,leadmultispace:»···,nbsp:+,trail:·,extends:→,precedes:←"
o.inccommand = "split"
o.foldenable = true
vim.opt.fillchars = {
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

o.foldmethod = "indent"
o.foldtext = "v:lua.require'utils'.ui.foldtext()"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldopen = "block,mark,percent,quickfix,search,tag,undo"
o.foldcolumn = "0"  -- Keep from your original

-- Tab settings - keep your original 4-space tabs
local TABWIDTH = 4

o.tabstop = TABWIDTH
o.softtabstop = TABWIDTH
o.shiftwidth = TABWIDTH
o.shiftround = true

-- UI config
o.showmode = true
o.showcmd = true
o.showbreak = "↳  "
o.splitbelow = true
o.splitright = true
o.timeout = true
o.timeoutlen = vim.g.vscode and 1000 or 200
o.updatetime = 50  -- Keep your original fast update
o.virtualedit = "block"

o.laststatus = 3
o.whichwrap = "b,s,<,>,[,],~"
o.guifont = "Berkeley Mono:h16"
o.cmdheight = 1
o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
o.conceallevel = 0
o.colorcolumn = ""  -- Keep from your original
o.numberwidth = 1  -- Keep from your original
o.signcolumn = "yes"  -- Changed to yes for gitsigns

o.wildchar = 9
o.wildignorecase = true
o.wildmode = "longest:full,full"

-- Keep your original netrw settings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Keep your original isfname setting
vim.opt.isfname:append("@-@")

-- Note: fillchars is set above with foldopen/foldclose etc.
