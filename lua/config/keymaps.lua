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
