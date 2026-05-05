local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("i", "jk", "<Esc>", "Escape insert")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<C-s>", "<cmd>w<CR>", "Save")
map("i", "<C-s>", "<Esc><cmd>w<CR>a", "Save (insert)")

map("n", "<S-h>", "<cmd>bprevious<CR>", "Prev buffer")
map("n", "<S-l>", "<cmd>bnext<CR>", "Next buffer")
map("n", "<leader>bn", "<cmd>enew<CR>", "New buffer")

map("n", "<leader>wh", "<C-w>h", "Window left")
map("n", "<leader>wj", "<C-w>j", "Window down")
map("n", "<leader>wk", "<C-w>k", "Window up")
map("n", "<leader>wl", "<C-w>l", "Window right")
map("n", "<leader>ws", "<cmd>split<CR>", "Split horizontal")
map("n", "<leader>wv", "<cmd>vsplit<CR>", "Split vertical")
map("n", "<leader>wc", "<cmd>close<CR>", "Close window")
map("n", "<leader>wo", "<cmd>only<CR>", "Only this window")

map("n", "<leader>tn", "<cmd>tabnew<CR>", "New tab")
map("n", "<leader>tc", "<cmd>tabclose<CR>", "Close tab")
map("n", "<leader>to", "<cmd>tabonly<CR>", "Only this tab")
map("n", "<leader>tl", "<cmd>tabnext<CR>", "Next tab")
map("n", "<leader>th", "<cmd>tabprevious<CR>", "Prev tab")

map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")
map("v", "<", "<gv", "Indent left and reselect")
map("v", ">", ">gv", "Indent right and reselect")

map("v", "p", '"_dP', "Paste without overwriting register")
map({ "n", "v" }, "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>Y", '"+Y', "Yank line to system clipboard")

map("n", "[d", function() vim.diagnostic.goto_prev() end, "Prev diagnostic")
map("n", "]d", function() vim.diagnostic.goto_next() end, "Next diagnostic")
map("n", "<leader>cd", function() vim.diagnostic.open_float() end, "Diagnostic float")

-- Save & quit
map("n", "<C-q>", "<cmd>wq<CR>", "Save and quit")
map("i", "<C-q>", "<Esc><cmd>wq<CR>", "Save and quit (insert)")
map("n", "<A-S-q>", "<cmd>q!<CR>", "Force quit")

-- Insert mode helpers (legacy)
map("i", "<C-u>", "<C-G>u<C-U>", "Delete previous block")
map("i", "<C-b>", "<Left>", "Move cursor left")
map("i", "<C-a>", "<Esc>^i", "Move cursor to line start")

-- Command-mode helpers (legacy)
map("c", "<C-b>", "<Left>", "Left")
map("c", "<C-f>", "<Right>", "Right")
map("c", "<C-a>", "<Home>", "Home")
map("c", "<C-e>", "<End>", "End")
map("c", "<C-d>", "<Del>", "Delete")
map("c", "<C-h>", "<BS>", "Backspace")
map("c", "<C-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]], "Path of current file")

-- "Suckless" niceties
map("n", "Y", "y$", "Yank to EOL")
map("n", "D", "d$", "Delete to EOL")
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Prev search result (centered)")
map("n", "J", "mzJ`z", "Join next line (cursor stays)")
map("n", "<S-Tab>", "<cmd>normal! za<CR>", "Toggle code fold")
map("n", "<leader>o", "<cmd>setlocal spell! spelllang=en_us<CR>", "Toggle spell check")

-- Tabs (legacy)
map("n", "tn", "<cmd>tabnew<CR>", "Tab new")
map("n", "tk", "<cmd>tabnext<CR>", "Tab next")
map("n", "tj", "<cmd>tabprevious<CR>", "Tab prev")
map("n", "to", "<cmd>tabonly<CR>", "Tab only")

-- Terminal-mode window focus
map("t", "<C-w>h", [[<Cmd>wincmd h<CR>]], "Window left")
map("t", "<C-w>l", [[<Cmd>wincmd l<CR>]], "Window right")
map("t", "<C-w>j", [[<Cmd>wincmd j<CR>]], "Window down")
map("t", "<C-w>k", [[<Cmd>wincmd k<CR>]], "Window up")
map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Terminal: normal mode")

-- Suda (sudo write)
map("n", "<A-s>", "<cmd>SudaWrite<CR>", "Sudo write")

-- Plenary profile (legacy user)
map("n", "<leader>hpb", function()
  local ok, p = pcall(require, "plenary.profile")
  if ok then p.start("profile.log", { flame = true }) end
end, "Profile start")
map("n", "<leader>hps", function()
  local ok, p = pcall(require, "plenary.profile")
  if ok then p.stop() end
end, "Profile stop")

-- Lazy package manager (legacy `<leader>P*` to avoid conflict with persisted)
map("n", "<leader>Ph", "<cmd>Lazy<CR>",         "Lazy show")
map("n", "<leader>Ps", "<cmd>Lazy sync<CR>",    "Lazy sync")
map("n", "<leader>Pu", "<cmd>Lazy update<CR>",  "Lazy update")
map("n", "<leader>Pi", "<cmd>Lazy install<CR>", "Lazy install")
map("n", "<leader>Pl", "<cmd>Lazy log<CR>",     "Lazy log")
map("n", "<leader>Pc", "<cmd>Lazy check<CR>",   "Lazy check")
map("n", "<leader>Pp", "<cmd>Lazy profile<CR>", "Lazy profile")
map("n", "<leader>Pr", "<cmd>Lazy restore<CR>", "Lazy restore")
map("n", "<leader>Px", "<cmd>Lazy clean<CR>",   "Lazy clean")
