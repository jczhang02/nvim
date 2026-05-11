local opt = vim.opt

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_node_provider = 0

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪ "
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "❯", precedes = "❮" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldsep = "│", foldclose = "▸" }

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

opt.updatetime = 200
opt.timeoutlen = 300

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.confirm = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.background = require("config.settings").background
opt.completeopt = { "fuzzy", "menu", "menuone", "noselect", "popup" }
opt.shortmess:append("WIcC")
opt.laststatus = 3
opt.showtabline = 2
opt.cmdheight = 1
opt.pumheight = 15
opt.pumblend = 10
opt.winblend = 0
opt.conceallevel = 0
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "0"
opt.foldenable = true

opt.spelllang = { "en_us" }
opt.spelloptions = "camel"

opt.textwidth = 80
opt.synmaxcol = 2500
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --hidden --vimgrep --smart-case --"

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
